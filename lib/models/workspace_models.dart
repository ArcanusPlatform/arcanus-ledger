import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../features/finance/services/finance_service.dart';
import '../services/customer_service.dart';
import '../models/payment_allocation_model.dart';
import '../features/customers/models/customer_board_models.dart';

/// Status enum for navigator items indicating payment risk
enum NavigatorItemStatus {
  normal, // Green: no balance or 4+ days until due
  dueSoon, // Amber: due within 3 days
  overdue, // Red: overdue
  overLimit // Red: exceeds credit limit
}

/// Represents a single item in the navigator pane (customer row)
class NavigatorItem {
  final String id;
  final String primaryText; // Customer name
  final String? secondaryText; // Phone or email
  final double balance;
  final double financeBalance;
  final double creditLimit;
  final DateTime? dueDate;
  final NavigatorItemStatus status;
  final Color riskColor;

  const NavigatorItem({
    required this.id,
    required this.primaryText,
    this.secondaryText,
    required this.balance,
    required this.financeBalance,
    required this.creditLimit,
    this.dueDate,
    required this.status,
    required this.riskColor,
  });

  bool get hasActiveFinance => financeBalance > 0.01;

  /// Calculate risk color based on status
  static Color getRiskColor(NavigatorItemStatus status) {
    switch (status) {
      case NavigatorItemStatus.normal:
        return Colors.green;
      case NavigatorItemStatus.dueSoon:
        return Colors.amber.shade700;
      case NavigatorItemStatus.overdue:
      case NavigatorItemStatus.overLimit:
        return Colors.red;
    }
  }

  /// Calculate status based on balance, credit limit, and due date
  static NavigatorItemStatus calculateStatus({
    required double balance,
    required double creditLimit,
    DateTime? dueDate,
  }) {
    // Check if over credit limit
    if (balance > creditLimit) {
      return NavigatorItemStatus.overLimit;
    }

    // Check due date if balance exists
    if (balance > 0.01 && dueDate != null) {
      final now = DateTime.now();
      final daysUntilDue = dueDate.difference(now).inDays;

      if (daysUntilDue < 0) {
        return NavigatorItemStatus.overdue;
      } else if (daysUntilDue <= 3) {
        return NavigatorItemStatus.dueSoon;
      }
    }

    return NavigatorItemStatus.normal;
  }

  /// Create NavigatorItem from customer data
  static NavigatorItem fromCustomer(
    PeopleData customer,
    double balance,
    DateTime? dueDate,
    double financeBalance,
  ) {
    final status = calculateStatus(
      balance: balance,
      creditLimit: customer.creditLimit,
      dueDate: dueDate,
    );

    return NavigatorItem(
      id: customer.id.toString(),
      primaryText: customer.name,
      secondaryText: customer.phone ?? customer.email,
      balance: balance,
      financeBalance: financeBalance,
      creditLimit: customer.creditLimit,
      dueDate: dueDate,
      status: status,
      riskColor: getRiskColor(status),
    );
  }
}

/// Represents a tab in the workspace pane
class WorkspaceTab {
  final String label;
  final IconData icon;
  final Widget content;

  const WorkspaceTab({
    required this.label,
    required this.icon,
    required this.content,
  });
}

/// Represents the content displayed in the workspace pane
class WorkspaceContent {
  final String itemId;
  final List<WorkspaceTab> tabs;
  final int initialTabIndex;

  const WorkspaceContent({
    required this.itemId,
    required this.tabs,
    this.initialTabIndex = 0,
  });
}

/// Abstract interface for loading workspace data
abstract class WorkspaceDataSource {
  /// Load all navigator items (customer list)
  Future<List<NavigatorItem>> loadNavigatorItems();

  /// Load workspace content for a specific item
  Future<WorkspaceContent> loadWorkspaceContent(String itemId);

  /// Refresh all data
  Future<void> refreshData();
}

/// Implementation of WorkspaceDataSource for customer data
class CustomerWorkspaceDataSource implements WorkspaceDataSource {
  final AppDatabase _db;
  final Future<void> Function()? _onFinancePaymentUpdated;

  CustomerWorkspaceDataSource(
    this._db, {
    Future<void> Function()? onFinancePaymentUpdated,
  }) : _onFinancePaymentUpdated = onFinancePaymentUpdated;

  @override
  Future<List<NavigatorItem>> loadNavigatorItems() async {
    final people = await _db.getAllPeople();
    final customers = people
        .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
        .cast<PeopleData>()
        .toList();

    final List<NavigatorItem> items = [];

    for (var customer in customers) {
      final accountSummary = await _db.getPersonAccountSummary(customer.id);
      final balance = accountSummary['balance'] as double;
      final financeView =
          await FinanceService.buildCustomerFinanceView(customer.id, _db);

      // Calculate earliest due date
      DateTime? earliestDueDate;

      // Check start balance due date
      if (customer.startBalance > 0 && customer.startDate != null) {
        try {
          final startDate = DateTime.parse(customer.startDate!);
          earliestDueDate = startDate.add(
            Duration(days: customer.paymentTermsDays),
          );
        } catch (e) {
          // Invalid date format, skip
        }
      }

      // Check outstanding invoices
      final outstanding = await _db.getOutstandingInvoices(customer.id);
      for (var invoice in outstanding) {
        try {
          final invoiceDate = DateTime.parse(invoice['date']);
          final dueDate = invoice['dueDate'] != null
              ? DateTime.parse(invoice['dueDate'])
              : invoiceDate.add(Duration(days: customer.paymentTermsDays));

          if (earliestDueDate == null || dueDate.isBefore(earliestDueDate)) {
            earliestDueDate = dueDate;
          }
        } catch (e) {
          // Invalid date format, skip this invoice
        }
      }

      items.add(
        NavigatorItem.fromCustomer(
          customer,
          balance,
          earliestDueDate,
          financeView.totalOutstanding,
        ),
      );
    }

    // Sort by name
    items.sort((a, b) => a.primaryText.compareTo(b.primaryText));

    return items;
  }

  @override
  Future<WorkspaceContent> loadWorkspaceContent(String itemId) async {
    try {
      final customerId = int.parse(itemId);
      final customer = await _db.getPersonById(customerId);

      if (customer == null) {
        throw Exception('Customer not found');
      }

      final accountSummary = await _db.getPersonAccountSummary(customerId);
      final outstandingItems =
          await _db.getOutstandingItemsForCustomer(customerId);
      final financeView =
          await FinanceService.buildCustomerFinanceView(customerId, _db);
      final upcomingFinancePayments =
          await _loadUpcomingFinancePayments(customerId);

      // Build the aged invoice matrix
      final customerService = CustomerService(_db);
      final matrix =
          await customerService.buildCustomerMatrix(outstandingItems);

      // Create tabs for workspace
      final tabs = <WorkspaceTab>[
        WorkspaceTab(
          label: 'Summary',
          icon: Icons.dashboard,
          content: _buildSummaryTab(
            customer,
            accountSummary,
            outstandingItems,
            matrix,
            financeView.totalOutstanding,
            upcomingFinancePayments,
          ),
        ),
        WorkspaceTab(
          label: 'Ledger',
          icon: Icons.receipt_long,
          content: _buildLedgerTab(accountSummary),
        ),
        WorkspaceTab(
          label: 'Contact',
          icon: Icons.person,
          content: _buildContactTab(customer),
        ),
      ];

      return WorkspaceContent(
        itemId: itemId,
        tabs: tabs,
        initialTabIndex: 0,
      );
    } catch (e) {
      // If there's any error (including date parsing), return error content
      throw Exception('Error loading customer data: ${e.toString()}');
    }
  }

  Widget _buildSummaryTab(
    PeopleData customer,
    Map<String, dynamic> accountSummary,
    List<OutstandingItem> outstandingItems,
    CustomerMatrix matrix,
    double financeBalance,
    List<_UpcomingFinancePaymentRow> upcomingFinancePayments,
  ) {
    final balance = accountSummary['balance'] as double;
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial summary cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Balance',
                  '£${balance.toStringAsFixed(2)}',
                  balance > 0 ? Colors.red : Colors.green,
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Finance Balance',
                  FinanceService.formatCurrency(financeBalance),
                  Colors.orange.shade700,
                  Icons.account_balance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Credit Limit',
                  '£${customer.creditLimit.toStringAsFixed(2)}',
                  Colors.blue,
                  Icons.credit_card,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // AGED INVOICE MATRIX - Main feature
          if (matrix.rows.isNotEmpty) ...[
            Row(
              children: [
                const Text(
                  'Outstanding Balance Breakdown',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: balance > customer.creditLimit
                        ? Colors.red.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: balance > customer.creditLimit
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                  child: Text(
                    '£${matrix.grandTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: balance > customer.creditLimit
                          ? Colors.red.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMatrixTable(matrix, dateFormat),
            const SizedBox(height: 24),
          ],
          if (upcomingFinancePayments.isNotEmpty) ...[
            const Text(
              'Upcoming Finance Payments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildUpcomingFinanceTable(upcomingFinancePayments, dateFormat),
            const SizedBox(height: 24),
          ],
        ],
      ),
    );
  }

  Future<List<_UpcomingFinancePaymentRow>> _loadUpcomingFinancePayments(
    int customerId,
  ) async {
    final agreements = await _db.getActiveFinanceAgreementsForCustomer(
      customerId,
    );
    final rows = <_UpcomingFinancePaymentRow>[];

    for (final agreement in agreements) {
      final payments = await _db.getFinancePayments(agreement.id);
      for (final payment in payments) {
        if (payment.paid == 0 && payment.rowType == 'SCHEDULED') {
          rows.add(
            _UpcomingFinancePaymentRow(
              agreementId: agreement.id,
              paymentId: payment.id,
              paymentNo: payment.paymentNo,
              dueDate: payment.dueDate,
              ref:
                  'FIN-${agreement.id.toString().padLeft(3, '0')} P${payment.paymentNo}',
              amount: payment.paymentAmount,
            ),
          );
        }
      }
    }

    rows.sort((a, b) => a.sortDate.compareTo(b.sortDate));
    return rows.take(4).toList();
  }

  Widget _buildSummaryCard(
      String label, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildMatrixTable(CustomerMatrix matrix, DateFormat dateFormat) {
    if (matrix.rows.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('No outstanding invoices'),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
          dataRowMinHeight: 48,
          dataRowMaxHeight: 64,
          columns: [
            const DataColumn(
                label: Text('WEEK',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ...matrix.columns.map(
              (col) => DataColumn(
                label: Text(col,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                numeric: true,
              ),
            ),
            const DataColumn(
              label:
                  Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
              numeric: true,
            ),
            const DataColumn(
                label: Text('DUE DATE',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: [
            // Data rows
            ...matrix.rows.map((row) {
              final isOverdue =
                  row.dueDate != null && row.dueDate!.isBefore(DateTime.now());

              return DataRow(
                color: WidgetStatePropertyAll(
                  isOverdue ? Colors.red.shade50 : null,
                ),
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${_formatDateSafe(row.date, dateFormat)} ${row.reference}',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  ...matrix.columns.map((col) {
                    final value = row.values[col] ?? 0;
                    return DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          value > 0 ? '£${value.toStringAsFixed(0)}' : '-',
                          style: TextStyle(
                            color: value > 0
                                ? Colors.orange.shade700
                                : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }),
                  DataCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '£${row.total.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  DataCell(
                    row.dueDate != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDateSafe(row.dueDate!, dateFormat),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isOverdue
                                      ? Colors.red.shade700
                                      : Colors.grey[700],
                                ),
                              ),
                              if (isOverdue)
                                Text(
                                  '${DateTime.now().difference(row.dueDate!).inDays}d overdue',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          )
                        : const Text('-'),
                  ),
                ],
              );
            }),
            // Total row
            DataRow(
              color: WidgetStatePropertyAll(Colors.blue.shade50),
              cells: [
                const DataCell(
                  Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
                ...matrix.columns.map((col) {
                  final total = matrix.columnTotals[col] ?? 0;
                  return DataCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '£${total.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  );
                }),
                DataCell(
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '£${matrix.grandTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ),
                const DataCell(SizedBox.shrink()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingFinanceTable(
    List<_UpcomingFinancePaymentRow> rows,
    DateFormat dateFormat,
  ) {
    return Builder(
      builder: (context) => Card(
        elevation: 2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
            dataRowMinHeight: 48,
            dataRowMaxHeight: 56,
            columns: [
              const DataColumn(
                label: Text(
                  'DUE DATE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const DataColumn(
                label: Text(
                  'REF',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const DataColumn(
                label: Text(
                  'AMOUNT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                numeric: true,
              ),
              const DataColumn(
                label: Text(
                  'STATUS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const DataColumn(
                label: Text(
                  'ACTION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: rows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(_formatDateSafe(row.sortDate, dateFormat))),
                      DataCell(Text(row.ref)),
                      DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            FinanceService.formatCurrency(row.amount),
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(_buildPendingBadge()),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: Colors.green.shade700,
                          ),
                          tooltip: 'Mark Paid',
                          onPressed: () => _markUpcomingFinancePaymentPaid(
                            context,
                            row,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildPendingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        'Pending',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.orange.shade700,
        ),
      ),
    );
  }

  Future<void> _markUpcomingFinancePaymentPaid(
    BuildContext context,
    _UpcomingFinancePaymentRow row,
  ) async {
    try {
      final payments = await _db.getFinancePayments(row.agreementId);
      final unpaidBefore = payments
          .where(
            (p) =>
                p.paid == 0 &&
                p.rowType == 'SCHEDULED' &&
                p.paymentNo < row.paymentNo,
          )
          .toList();

      bool markAll = false;

      if (unpaidBefore.isNotEmpty) {
        if (!context.mounted) return;
        final choice = await showDialog<String>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Mark Payments Paid'),
            content: Text(
              '${unpaidBefore.length} earlier payment(s) are unpaid.\n\n'
              'Mark all payments up to and including #${row.paymentNo} as paid?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: const Text('Cancel'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context, 'single'),
                child: Text('Only #${row.paymentNo}'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, 'all'),
                child: Text('All up to #${row.paymentNo}'),
              ),
            ],
          ),
        );
        if (choice == null || choice == 'cancel') return;
        markAll = choice == 'all';
      } else {
        if (!context.mounted) return;
        final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Mark Paid'),
            content: Text('Mark payment #${row.paymentNo} as paid?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Mark Paid'),
              ),
            ],
          ),
        );
        if (ok != true) return;
      }

      final today = FinanceService.todayIso();

      if (markAll) {
        final ids = payments
            .where(
              (p) =>
                  p.paid == 0 &&
                  p.rowType == 'SCHEDULED' &&
                  p.paymentNo <= row.paymentNo,
            )
            .map((p) => p.id)
            .toList();
        await _db.bulkMarkFinancePaymentsPaid(ids, today);
      } else {
        await _db.updateFinancePaymentPaid(
          row.paymentId,
          paid: true,
          paidDate: today,
        );
      }

      await _checkFinanceAgreementAutoComplete(row.agreementId);
      await _onFinancePaymentUpdated?.call();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error marking finance payment paid: $e')),
      );
    }
  }

  Future<void> _checkFinanceAgreementAutoComplete(int agreementId) async {
    final fresh = await _db.getFinancePayments(agreementId);
    final allPaid =
        fresh.where((p) => p.rowType == 'SCHEDULED').every((p) => p.paid == 1);
    if (allPaid) {
      await _db.updateFinanceAgreementStatus(agreementId, 'COMPLETE');
    }
  }

  String _formatDateSafe(DateTime date, DateFormat formatter) {
    try {
      return formatter.format(date);
    } catch (e) {
      return date.toString().split(' ')[0]; // Fallback to YYYY-MM-DD
    }
  }

  Widget _buildLedgerTab(Map<String, dynamic> accountSummary) {
    final ledger = accountSummary['ledger'] as List<Map<String, dynamic>>;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (ledger.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No transactions'),
              ),
            )
          else
            ...ledger.map((entry) => _buildLedgerEntry(entry)),
        ],
      ),
    );
  }

  Widget _buildLedgerEntry(Map<String, dynamic> entry) {
    final type = entry['type'] as String;
    final date = entry['date'] as String;
    final reference = entry['reference'] as String;
    final debit = entry['debit'] as double;
    final credit = entry['credit'] as double;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              type == 'invoice'
                  ? Icons.receipt
                  : type == 'payment'
                      ? Icons.payment
                      : Icons.account_balance,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reference,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (debit > 0)
              Text(
                '£${debit.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (credit > 0)
              Text(
                '£${credit.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTab(PeopleData customer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoCard([
            _buildInfoRow(Icons.person, 'Name', customer.name),
            if (customer.phone != null)
              _buildInfoRow(Icons.phone, 'Phone', customer.phone!),
            if (customer.email != null)
              _buildInfoRow(Icons.email, 'Email', customer.email!),
            if (customer.address != null)
              _buildInfoRow(Icons.location_on, 'Address', customer.address!),
            _buildInfoRow(Icons.calendar_today, 'Payment Terms',
                '${customer.paymentTermsDays} days'),
            if (customer.notes != null && customer.notes!.isNotEmpty)
              _buildInfoRow(Icons.notes, 'Notes', customer.notes!),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> refreshData() async {
    // Data is loaded fresh each time from database
    // No caching to refresh
  }
}

class _UpcomingFinancePaymentRow {
  final int agreementId;
  final int paymentId;
  final int paymentNo;
  final String dueDate;
  final String ref;
  final double amount;

  const _UpcomingFinancePaymentRow({
    required this.agreementId,
    required this.paymentId,
    required this.paymentNo,
    required this.dueDate,
    required this.ref,
    required this.amount,
  });

  DateTime get sortDate => DateTime.tryParse(dueDate) ?? DateTime(9999);
}
