import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../database/database.dart';
import '../../../services/csv_platform.dart';
import '../../../utils/responsive_utils.dart';
import '../../../widgets/custom_app_bar.dart';
import '../services/finance_document_service.dart';
import '../services/finance_service.dart';
import 'finance_agreement_form_screen.dart';

class FinanceAgreementDetailScreen extends StatefulWidget {
  final int agreementId;
  const FinanceAgreementDetailScreen({super.key, required this.agreementId});

  @override
  State<FinanceAgreementDetailScreen> createState() =>
      _FinanceAgreementDetailScreenState();
}

class _FinanceAgreementDetailScreenState
    extends State<FinanceAgreementDetailScreen> {
  final _db = AppDatabase.instance;

  FinanceAgreement? _agreement;
  List<FinancePayment> _payments = [];
  bool _isLoading = true;
  bool _showSettlement = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final a = await _db.getFinanceAgreementById(widget.agreementId);
      final p = await _db.getFinancePayments(widget.agreementId);
      if (!mounted) return;
      setState(() {
        _agreement = a;
        _payments = p;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ── Derived values ────────────────────────────────────────────────────────

  double get _outstanding =>
      FinanceService.outstandingCapital(_agreement!, _payments);

  bool get _isComplete =>
      (_agreement?.status.toUpperCase() ?? '') == 'COMPLETE';

  int get _paidCount => _payments.where((p) => p.paid == 1).length;

  // ── Mark paid ─────────────────────────────────────────────────────────────

  Future<void> _markPaid(FinancePayment payment) async {
    final unpaidBefore = _payments
        .where((p) => p.paid == 0 && p.paymentNo < payment.paymentNo)
        .toList();

    bool markAll = false;

    if (unpaidBefore.isNotEmpty) {
      final choice = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Mark Payments Paid'),
          content: Text(
            '${unpaidBefore.length} earlier payment(s) are unpaid.\n\n'
            'Mark all payments up to and including #${payment.paymentNo} as paid?',
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: const Text('Cancel')),
            OutlinedButton(
                onPressed: () => Navigator.pop(context, 'single'),
                child: Text('Only #${payment.paymentNo}')),
            FilledButton(
                onPressed: () => Navigator.pop(context, 'all'),
                child: Text('All up to #${payment.paymentNo}')),
          ],
        ),
      );
      if (choice == null || choice == 'cancel') return;
      markAll = choice == 'all';
    } else {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Mark Paid'),
          content: Text('Mark payment #${payment.paymentNo} as paid?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Mark Paid')),
          ],
        ),
      );
      if (ok != true) return;
    }

    final today = FinanceService.todayIso();

    if (markAll) {
      final ids = _payments
          .where((p) => p.paid == 0 && p.paymentNo <= payment.paymentNo)
          .map((p) => p.id)
          .toList();
      await _db.bulkMarkFinancePaymentsPaid(ids, today);
    } else {
      await _db.updateFinancePaymentPaid(payment.id,
          paid: true, paidDate: today);
    }

    // Auto-complete if all scheduled rows are now paid
    await _checkAutoComplete();
    _load();
  }

  Future<void> _markUnpaid(FinancePayment payment) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark Unpaid'),
        content: Text('Mark payment #${payment.paymentNo} as unpaid?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Mark Unpaid')),
        ],
      ),
    );
    if (ok != true) return;
    await _db.updateFinancePaymentPaid(payment.id, paid: false);
    // Reactivate if was complete
    if (_isComplete) {
      await _db.updateFinanceAgreementStatus(widget.agreementId, 'ACTIVE');
    }
    _load();
  }

  Future<void> _checkAutoComplete() async {
    final fresh = await _db.getFinancePayments(widget.agreementId);
    final allPaid =
        fresh.where((p) => p.rowType == 'SCHEDULED').every((p) => p.paid == 1);
    if (allPaid) {
      await _db.updateFinanceAgreementStatus(widget.agreementId, 'COMPLETE');
    }
  }

  // ── Early settlement ──────────────────────────────────────────────────────

  Future<void> _confirmSettlement() async {
    final outstanding = _outstanding;

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Early Settlement'),
        content: Text(
          'Settle this agreement for ${FinanceService.formatCurrency(outstanding)}?\n\n'
          'Remaining scheduled payments will be replaced with a single settlement entry. '
          'No additional interest is charged.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm Settlement'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    // Build settlement row
    final paidRows = _payments.where((p) => p.paid == 1).toList();
    final settlementNo = paidRows.isEmpty ? 1 : paidRows.last.paymentNo + 1;

    final settlementRow = FinancePaymentsCompanion(
      agreementId: const Value.absent(),
      paymentNo: Value(settlementNo),
      dueDate: Value(FinanceService.todayIso()),
      openingBalance: Value(outstanding),
      paymentAmount: Value(outstanding),
      interestAmount: const Value(0),
      capitalAmount: Value(outstanding),
      closingBalance: const Value(0),
      paid: const Value(1),
      paidDate: Value(FinanceService.todayIso()),
      rowType: const Value('SETTLEMENT'),
    );

    await _db.settleFinanceAgreementEarly(widget.agreementId, settlementRow);

    setState(() => _showSettlement = false);
    _load();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agreement settled early')));
    }
  }

  // ── Edit / Delete ─────────────────────────────────────────────────────────

  Future<void> _edit() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => FinanceAgreementFormScreen(existing: _agreement),
      ),
    );
    if (saved == true) _load();
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Agreement'),
        content: const Text(
            'Delete this agreement and all payment records? This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _db.deleteFinanceAgreement(widget.agreementId);
    if (mounted) Navigator.pop(context, true);
  }

  Future<void> _generateAgreementDocument() async {
    final agreement = _agreement;
    if (agreement == null) return;

    try {
      await CsvPlatform.downloadFile(
        FinanceDocumentService.agreementFilename(agreement),
        FinanceDocumentService.buildAgreementHtml(agreement, _payments),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agreement document generated')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate agreement: $e')),
      );
    }
  }

  Future<void> _exportAgreement() async {
    final agreement = _agreement;
    if (agreement == null) return;

    try {
      await CsvPlatform.downloadFile(
        FinanceDocumentService.exportFilename(agreement),
        FinanceDocumentService.buildAgreementCsv(agreement, _payments),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agreement export created')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export agreement: $e')),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _agreement == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Agreement', subtitle: ''),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final a = _agreement!;
    final status = a.status.toUpperCase();
    final statusColor = status == 'COMPLETE'
        ? Colors.green
        : status == 'OVERDUE'
            ? Colors.red
            : Colors.blue;

    return Scaffold(
      appBar: CustomAppBar(
        title: a.customerName,
        subtitle: 'Ledger agreement',
        actions: [
          if (!_isComplete)
            TextButton(
              onPressed: () =>
                  setState(() => _showSettlement = !_showSettlement),
              child: Text(
                'Early Settlement',
                style: TextStyle(
                    color: Colors.orange.shade700, fontWeight: FontWeight.bold),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.description, size: AppIconSizes.appBar),
            onPressed: _generateAgreementDocument,
            tooltip: 'Agreement',
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined,
                size: AppIconSizes.appBar),
            onPressed: _exportAgreement,
            tooltip: 'Export',
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: AppIconSizes.appBar),
            onPressed: _edit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete,
                size: AppIconSizes.appBar, color: Colors.red),
            onPressed: _delete,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── KPI stat cards ─────────────────────────────────────────────
            _buildStatCards(a, statusColor),

            SizedBox(height: AppSpacing.getCardSpacing(context)),

            // ── Agreement details ──────────────────────────────────────────
            _buildDetailsCard(a),

            SizedBox(height: AppSpacing.getCardSpacing(context)),

            // ── Early settlement panel ─────────────────────────────────────
            if (_showSettlement && !_isComplete) _buildSettlementPanel(),

            if (_showSettlement && !_isComplete)
              SizedBox(height: AppSpacing.getCardSpacing(context)),

            // ── Repayment schedule ─────────────────────────────────────────
            _buildScheduleCard(),
          ],
        ),
      ),
    );
  }

  // ── Stat cards ────────────────────────────────────────────────────────────

  Widget _buildStatCards(FinanceAgreement a, Color statusColor) {
    return Row(
      children: [
        Expanded(
            child: _statCard('Loan Amount',
                FinanceService.formatCurrency(a.loanAmount), Colors.blue)),
        const SizedBox(width: 10),
        Expanded(
            child: _statCard(
                'Total Repayable',
                FinanceService.formatCurrency(a.totalRepayable),
                Colors.purple)),
        const SizedBox(width: 10),
        Expanded(
            child: _statCard(
                'Outstanding',
                _isComplete
                    ? '£0.00'
                    : FinanceService.formatCurrency(_outstanding),
                _isComplete ? Colors.green : Colors.orange)),
        const SizedBox(width: 10),
        Expanded(
            child: _statCard('Status', a.status.toUpperCase(), statusColor)),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: AppTypography.mobileLabel,
                    color: Colors.grey.shade600)),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: AppTypography.mobileHeading3,
                    fontWeight: FontWeight.bold,
                    color: color)),
          ],
        ),
      ),
    );
  }

  // ── Details card ──────────────────────────────────────────────────────────

  Widget _buildDetailsCard(FinanceAgreement a) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Agreement Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            _detailsGrid(a),
          ],
        ),
      ),
    );
  }

  Widget _detailsGrid(FinanceAgreement a) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final items = [
      _DetailItem('Customer', a.customerName),
      _DetailItem('Address', a.customerAddress ?? '-'),
      _DetailItem('Agreement Date', FinanceService.formatDate(a.agreementDate)),
      _DetailItem(
          'First Payment', FinanceService.formatDate(a.firstPaymentDate)),
      _DetailItem('Interest Rate', '${a.interestRate}%'),
      _DetailItem('Frequency', a.paymentFrequency),
      _DetailItem('Payments', '${a.paymentCount}'),
      _DetailItem(
          'Payment Amount', FinanceService.formatCurrency(a.paymentAmount)),
      _DetailItem(
          'Total Interest', FinanceService.formatCurrency(a.totalInterest)),
    ];

    if (isMobile) {
      return Column(
        children: items
            .map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 130,
                        child: Text(i.label,
                            style: TextStyle(
                                fontSize: AppTypography.mobileLabel,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600)),
                      ),
                      Expanded(
                          child: Text(i.value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600))),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    return Wrap(
      spacing: 24,
      runSpacing: 14,
      children: items
          .map((i) => SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(i.label,
                        style: TextStyle(
                            fontSize: AppTypography.mobileLabel,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(i.value,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  // ── Settlement panel ──────────────────────────────────────────────────────

  Widget _buildSettlementPanel() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade300, width: 1.5),
      ),
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.handshake, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text('Early Settlement',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800)),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Settlement figure based on capital outstanding after last paid payment — '
              'no additional interest charged.',
              style: TextStyle(
                  fontSize: AppTypography.mobileLabel,
                  color: Colors.grey.shade700),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settlement Figure',
                        style: TextStyle(
                            fontSize: AppTypography.mobileLabel,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      FinanceService.formatCurrency(_outstanding),
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.orange.shade700),
                      onPressed: _confirmSettlement,
                      child: const Text('Confirm Settlement'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => setState(() => _showSettlement = false),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Schedule card ─────────────────────────────────────────────────────────

  Widget _buildScheduleCard() {
    final paidCount = _paidCount;
    final total = _payments.length;
    final pct = total > 0 ? paidCount / total : 0.0;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Repayment Schedule',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        _isComplete
                            ? '$total of $total payments complete'
                            : '$paidCount of $total payments made',
                        style: TextStyle(
                            fontSize: AppTypography.mobileLabel,
                            color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _isComplete ? 1.0 : pct,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                    _isComplete ? Colors.green : Colors.blue),
              ),
            ),
          ),

          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
              dataRowMinHeight: 44,
              dataRowMaxHeight: 52,
              columns: [
                const DataColumn(label: Text('#')),
                const DataColumn(label: Text('Due Date')),
                const DataColumn(label: Text('Opening'), numeric: true),
                const DataColumn(label: Text('Payment'), numeric: true),
                const DataColumn(label: Text('Interest'), numeric: true),
                const DataColumn(label: Text('Capital'), numeric: true),
                const DataColumn(label: Text('Closing'), numeric: true),
                const DataColumn(label: Text('Status')),
                const DataColumn(label: Text('Action')),
              ],
              rows: _buildScheduleRows(),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<DataRow> _buildScheduleRows() {
    final rows = <DataRow>[];

    for (final p in _payments) {
      final isPaid = p.paid == 1;
      final isSettlement = p.rowType == 'SETTLEMENT';

      rows.add(DataRow(
        color: WidgetStatePropertyAll(
          isSettlement
              ? Colors.green.shade50
              : isPaid
                  ? Colors.grey.shade50
                  : null,
        ),
        cells: [
          DataCell(Text(
            isSettlement ? 'S' : '${p.paymentNo}',
            style: isSettlement
                ? TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green.shade700)
                : null,
          )),
          DataCell(Text(
            isSettlement ? 'Settlement' : FinanceService.formatDate(p.dueDate),
            style: isSettlement
                ? TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green.shade700)
                : null,
          )),
          DataCell(Text(
            FinanceService.formatCurrency(p.openingBalance),
            style: TextStyle(color: isPaid ? Colors.grey.shade500 : null),
          )),
          DataCell(Text(
            FinanceService.formatCurrency(p.paymentAmount),
            style: TextStyle(
                color: isPaid ? Colors.grey.shade500 : Colors.green.shade700,
                fontWeight: FontWeight.bold),
          )),
          DataCell(Text(
            FinanceService.formatCurrency(p.interestAmount),
            style: TextStyle(
                color: isPaid ? Colors.grey.shade500 : Colors.orange.shade700),
          )),
          DataCell(Text(
            FinanceService.formatCurrency(p.capitalAmount),
            style: TextStyle(color: isPaid ? Colors.grey.shade500 : null),
          )),
          DataCell(Text(
            FinanceService.formatCurrency(p.closingBalance),
            style: TextStyle(color: isPaid ? Colors.grey.shade500 : null),
          )),
          DataCell(_statusBadge(p)),
          DataCell(_actionButton(p)),
        ],
      ));
    }

    return rows;
  }

  Widget _statusBadge(FinancePayment p) {
    if (p.rowType == 'SETTLEMENT') {
      return _pill('SETTLED', Colors.green);
    }
    return p.paid == 1
        ? _pill('PAID', Colors.green)
        : _pill('PENDING', Colors.blue);
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _actionButton(FinancePayment p) {
    if (p.rowType == 'SETTLEMENT') {
      return const Text('—');
    }
    if (p.paid == 1) {
      return IconButton(
        icon: const Icon(Icons.undo, size: AppIconSizes.button),
        tooltip: 'Mark Unpaid',
        onPressed: () => _markUnpaid(p),
      );
    }
    return IconButton(
      icon: Icon(Icons.check_circle_outline,
          size: AppIconSizes.button, color: Colors.green.shade700),
      tooltip: 'Mark Paid',
      onPressed: () => _markPaid(p),
    );
  }
}

class _DetailItem {
  final String label;
  final String value;
  const _DetailItem(this.label, this.value);
}
