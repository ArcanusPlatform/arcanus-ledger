// ─────────────────────────────────────────────────────────────────────────────
// FINANCE MODULE — SERVICE
// Pure Dart — no Flutter imports.
// ─────────────────────────────────────────────────────────────────────────────

import '../models/finance_models.dart';
import '../../../database/database.dart';

class FinanceService {
  // _db retained for future instance methods (buildSummary uses it as a param)
  // ignore: unused_field
  final AppDatabase _db;

  FinanceService(this._db);

  // ── Schedule generation ───────────────────────────────────────────────────

  /// Generate a reducing-balance repayment schedule.
  ///
  /// [loanAmount]       — capital lent
  /// [annualRatePercent]— annual interest rate (e.g. 10.0 = 10 %)
  /// [paymentCount]     — total number of payments
  /// [frequency]        — 'Weekly' or 'Monthly'
  /// [firstPaymentDate] — ISO yyyy-MM-dd
  static GeneratedSchedule generateSchedule({
    required double loanAmount,
    required double annualRatePercent,
    required int paymentCount,
    required String frequency,
    required String firstPaymentDate,
  }) {
    final periodsPerYear = frequency == 'Weekly' ? 52.0 : 12.0;
    final periodRate = (annualRatePercent / 100.0) / periodsPerYear;

    // Annuity payment formula
    final paymentAmount = periodRate == 0
        ? loanAmount / paymentCount
        : (loanAmount * periodRate) / (1 - _pow(1 + periodRate, -paymentCount));

    double balance = loanAmount;
    final rows = <ScheduleRow>[];

    for (int i = 1; i <= paymentCount; i++) {
      final opening = balance;
      final interest = opening * periodRate;
      final capital = paymentAmount - interest;
      balance = opening - capital;
      if (balance < 0) balance = 0;

      rows.add(ScheduleRow(
        paymentNo: i,
        dueDate: _addPeriods(firstPaymentDate, frequency, i - 1),
        openingBalance: opening,
        paymentAmount: paymentAmount,
        interestAmount: interest,
        capitalAmount: capital,
        closingBalance: balance,
      ));
    }

    final totalRepayable = paymentAmount * paymentCount;
    final totals = AgreementTotals(
      paymentAmount: paymentAmount,
      totalRepayable: totalRepayable,
      totalInterest: totalRepayable - loanAmount,
    );

    return GeneratedSchedule(rows: rows, totals: totals);
  }

  // ── Summary / KPIs ────────────────────────────────────────────────────────

  /// Build dashboard summary from a list of agreements + their payment rows.
  static Future<FinanceSummary> buildSummary(
    List<FinanceAgreement> agreements,
    AppDatabase db,
  ) async {
    final today = _dateOnly(DateTime.now());
    final nextWeek = today.add(const Duration(days: 7));

    int activeCount = 0;
    int completedCount = 0;
    double totalOutstanding = 0;
    double dueThisWeek = 0;

    for (final a in agreements) {
      final status = a.status.toUpperCase();

      if (status == 'COMPLETE') {
        completedCount++;
        continue;
      }

      activeCount++;

      // Outstanding = closing balance of last paid payment,
      // or full loan amount if nothing paid yet.
      final payments = await db.getFinancePayments(a.id);
      final paid = payments.where((p) => p.paid == 1).toList();

      final outstanding =
          paid.isEmpty ? a.loanAmount : paid.last.closingBalance;

      totalOutstanding += outstanding;

      // Next unpaid scheduled payment
      final nextPending = payments
          .where((p) => p.paid == 0 && p.rowType == 'SCHEDULED')
          .toList();

      if (nextPending.isNotEmpty) {
        final due = _parseDate(nextPending.first.dueDate);
        if (due != null && !due.isAfter(nextWeek)) {
          dueThisWeek += nextPending.first.paymentAmount;
        }
      }
    }

    return FinanceSummary(
      activeCount: activeCount,
      completedCount: completedCount,
      totalOutstanding: totalOutstanding,
      dueThisWeek: dueThisWeek,
    );
  }

  // ── Outstanding capital ───────────────────────────────────────────────────

  /// Returns the outstanding capital balance for an agreement based on
  /// the closing balance of the last paid payment row.
  static double outstandingCapital(
    FinanceAgreement agreement,
    List<FinancePayment> payments,
  ) {
    if (agreement.status.toUpperCase() == 'COMPLETE') return 0;
    final paid = payments.where((p) => p.paid == 1).toList();
    if (paid.isEmpty) return agreement.loanAmount;
    return paid.last.closingBalance;
  }

  /// Returns the next unpaid scheduled payment, or null if all paid.
  static FinancePayment? nextPendingPayment(List<FinancePayment> payments) {
    final pending =
        payments.where((p) => p.paid == 0 && p.rowType == 'SCHEDULED').toList();
    return pending.isEmpty ? null : pending.first;
  }

  // ── Customer workspace finance view ──────────────────────────────────────

  /// Build the finance exposure summary for the customer workspace.
  ///
  /// Shows the next [upcomingCount] pending payments individually,
  /// then collapses the rest into a single future-balance figure.
  static Future<CustomerFinanceView> buildCustomerFinanceView(
    int personId,
    AppDatabase db, {
    int upcomingCount = 3,
  }) async {
    final agreements = await db.getActiveFinanceAgreementsForCustomer(personId);

    if (agreements.isEmpty) return CustomerFinanceView.empty;

    double totalOutstanding = 0;
    final upcoming = <UpcomingFinancePayment>[];
    double futureBalance = 0;

    for (final a in agreements) {
      final payments = await db.getFinancePayments(a.id);
      totalOutstanding += outstandingCapital(a, payments);

      final pending = payments
          .where((p) => p.paid == 0 && p.rowType == 'SCHEDULED')
          .toList();

      for (int i = 0; i < pending.length; i++) {
        final p = pending[i];
        if (upcoming.length < upcomingCount) {
          upcoming.add(UpcomingFinancePayment(
            amount: p.paymentAmount,
            dueDate: p.dueDate,
            agreementRef: a.customerName,
          ));
        } else {
          futureBalance += p.paymentAmount;
        }
      }
    }

    // Sort upcoming by due date ascending
    upcoming.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return CustomerFinanceView(
      upcomingPayments: upcoming,
      futureBalance: futureBalance,
      totalOutstanding: totalOutstanding,
    );
  }

  // ── Date helpers ──────────────────────────────────────────────────────────

  static String _addPeriods(String startIso, String frequency, int index) {
    final date = DateTime.parse(startIso);
    final DateTime result;
    if (frequency == 'Weekly') {
      result = date.add(Duration(days: 7 * index));
    } else {
      result = DateTime(date.year, date.month + index, date.day);
    }
    return _isoDate(result);
  }

  static String _isoDate(DateTime d) => '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  static double _pow(double base, int exp) {
    double result = 1;
    for (int i = 0; i < exp.abs(); i++) {
      result *= base;
    }
    return exp < 0 ? 1 / result : result;
  }

  // ── Formatters (used by screens) ──────────────────────────────────────────

  static String formatCurrency(double v) =>
      '£${v.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+\.)'),
            (m) => '${m[1]},',
          )}';

  static String formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final d = DateTime.parse(iso);
      return '${d.day.toString().padLeft(2, '0')}/'
          '${d.month.toString().padLeft(2, '0')}/'
          '${d.year}';
    } catch (_) {
      return iso;
    }
  }

  static String todayIso() => _isoDate(_dateOnly(DateTime.now()));
}
