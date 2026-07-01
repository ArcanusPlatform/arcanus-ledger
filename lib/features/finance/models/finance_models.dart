// ─────────────────────────────────────────────────────────────────────────────
// FINANCE MODULE — PURE DART MODELS
// No Flutter imports — safe to unit test independently.
// ─────────────────────────────────────────────────────────────────────────────

/// The three ways a finance agreement can be created.
enum FinanceSource {
  /// No linked sales — simple repayment arrangement.
  standalone,

  /// One or more outstanding sales absorbed into the agreement.
  allocated,

  /// Selected sales plus an additional manual top-up amount.
  hybrid;

  String get label {
    switch (this) {
      case FinanceSource.standalone:
        return 'Standalone';
      case FinanceSource.allocated:
        return 'Allocated Sales';
      case FinanceSource.hybrid:
        return 'Hybrid';
    }
  }

  static FinanceSource fromString(String? s) {
    switch (s) {
      case 'allocated':
        return FinanceSource.allocated;
      case 'hybrid':
        return FinanceSource.hybrid;
      default:
        return FinanceSource.standalone;
    }
  }
}

/// One row in the generated repayment schedule (before saving to DB).
class ScheduleRow {
  final int paymentNo;
  final String dueDate; // ISO yyyy-MM-dd
  final double openingBalance;
  final double paymentAmount;
  final double interestAmount;
  final double capitalAmount;
  final double closingBalance;

  const ScheduleRow({
    required this.paymentNo,
    required this.dueDate,
    required this.openingBalance,
    required this.paymentAmount,
    required this.interestAmount,
    required this.capitalAmount,
    required this.closingBalance,
  });
}

/// Calculated totals returned alongside the schedule.
class AgreementTotals {
  final double paymentAmount;
  final double totalRepayable;
  final double totalInterest;

  const AgreementTotals({
    required this.paymentAmount,
    required this.totalRepayable,
    required this.totalInterest,
  });
}

/// Combined result from schedule generation.
class GeneratedSchedule {
  final List<ScheduleRow> rows;
  final AgreementTotals totals;

  const GeneratedSchedule({required this.rows, required this.totals});
}

/// Summary used on the agreements list and dashboard KPIs.
class FinanceSummary {
  final int activeCount;
  final int completedCount;
  final double totalOutstanding; // sum of outstanding capital across active
  final double dueThisWeek; // sum of next-payment amounts due ≤7 days

  const FinanceSummary({
    required this.activeCount,
    required this.completedCount,
    required this.totalOutstanding,
    required this.dueThisWeek,
  });
}

/// A single upcoming finance payment row for the customer workspace.
class UpcomingFinancePayment {
  final double amount;
  final String dueDate; // ISO yyyy-MM-dd
  final String agreementRef; // e.g. customer name or agreement id

  const UpcomingFinancePayment({
    required this.amount,
    required this.dueDate,
    required this.agreementRef,
  });
}

/// Finance exposure summary for the customer workspace summary tab.
/// Shows the next [upcomingPayments] individually, then a single
/// [futureBalance] row for everything beyond that.
class CustomerFinanceView {
  /// Next N pending payment rows (typically 2–3).
  final List<UpcomingFinancePayment> upcomingPayments;

  /// Sum of all remaining scheduled payments beyond the upcoming ones.
  final double futureBalance;

  /// Total outstanding capital across all active agreements.
  final double totalOutstanding;

  /// True if the customer has any active finance agreements.
  bool get hasFinance => totalOutstanding > 0.01 || upcomingPayments.isNotEmpty;

  const CustomerFinanceView({
    required this.upcomingPayments,
    required this.futureBalance,
    required this.totalOutstanding,
  });

  static const CustomerFinanceView empty = CustomerFinanceView(
    upcomingPayments: [],
    futureBalance: 0,
    totalOutstanding: 0,
  );
}

/// A selectable outstanding sale for the finance form.
class SelectableSale {
  final int saleId;
  final String invoiceNumber;
  final String date;
  final double outstanding;
  bool selected;

  SelectableSale({
    required this.saleId,
    required this.invoiceNumber,
    required this.date,
    required this.outstanding,
    this.selected = false,
  });
}
