import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../database/database.dart';

/// Tabbed dialog showing a customer's contact details and full ledger.
class CustomerDetailDialog extends StatefulWidget {
  final PeopleData customer;
  final VoidCallback onEdit;
  final Future<bool> Function(int saleId)? onEditSale;

  const CustomerDetailDialog({
    super.key,
    required this.customer,
    required this.onEdit,
    this.onEditSale,
  });

  @override
  State<CustomerDetailDialog> createState() => _CustomerDetailDialogState();
}

class _CustomerDetailDialogState extends State<CustomerDetailDialog>
    with TickerProviderStateMixin {
  final AppDatabase _db = AppDatabase.instance;
  late TabController _tabController;
  Map<String, dynamic>? _accountSummary;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAccountSummary();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountSummary() async {
    try {
      final summary = await _db.getPersonAccountSummary(widget.customer.id);
      // Enrich invoice entries with product names
      final ledger = summary['ledger'] as List;
      for (final entry in ledger) {
        if (entry['type'] == 'invoice' &&
            entry['id'] != null &&
            entry['id'] != 0) {
          final saleItems =
              (await _db.getSaleItems(entry['id'] as int)).cast<SaleItem>();
          final productNames = <String>[];
          for (final si in saleItems) {
            final product = await _db.getProductById(si.productId);
            if (product != null) productNames.add(product.name);
          }
          entry['products'] = productNames;
        }
      }
      setState(() {
        _accountSummary = summary;
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
        child: Column(
          children: [
            _buildHeader(),
            TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Details'), Tab(text: 'Ledger')],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildDetailsTab(), _buildLedgerTab()],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 32,
            child: Text(
              widget.customer.name[0].toUpperCase(),
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customer.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'CUSTOMER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: widget.onEdit,
            icon: const Icon(Icons.edit),
            label: const Text('Edit'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ── Details tab ──────────────────────────────────────────────────────────────

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildDetailSection('Contact Information', Icons.contact_phone, [
            _detailRow(Icons.phone, 'Telephone',
                widget.customer.phone ?? 'Not provided'),
            _detailRow(
                Icons.email, 'Email', widget.customer.email ?? 'Not provided'),
            _detailRow(Icons.location_on, 'Location',
                widget.customer.address ?? 'Not provided'),
            if (widget.customer.notes != null &&
                widget.customer.notes!.isNotEmpty)
              _detailRow(Icons.note, 'Notes', widget.customer.notes!),
          ]),
          const SizedBox(height: 20),
          _buildDetailSection(
            'Financial Information',
            Icons.account_balance_wallet,
            [
              _detailRow(Icons.account_balance, 'Start Balance',
                  '£${widget.customer.startBalance.toStringAsFixed(2)}'),
              _detailRow(Icons.credit_card, 'Credit Limit',
                  '£${widget.customer.creditLimit.toStringAsFixed(2)}'),
              _detailRow(Icons.calendar_today, 'Payment Terms',
                  '${widget.customer.paymentTermsDays} days'),
              if (widget.customer.startDate != null)
                _detailRow(
                    Icons.event, 'Start Date', widget.customer.startDate!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
      String title, IconData icon, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _detailRow(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.grey[800],
                fontWeight:
                    valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Ledger tab ───────────────────────────────────────────────────────────────

  Widget _buildLedgerTab() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_accountSummary == null) {
      return const Center(child: Text('Error loading ledger'));
    }

    final ledger = _accountSummary!['ledger'] as List;
    final totalInvoiced = _accountSummary!['totalInvoiced'] as double;
    final totalPaid = _accountSummary!['totalPaid'] as double;
    final balance = _accountSummary!['balance'] as double;

    return Column(
      children: [
        _buildLedgerSummary(totalInvoiced, totalPaid, balance),
        Expanded(
          child: ledger.isEmpty
              ? const Center(child: Text('No transactions yet'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: ledger.length,
                  itemBuilder: (context, index) =>
                      _buildLedgerTile(ledger[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildLedgerSummary(
      double totalInvoiced, double totalPaid, double balance) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue.shade50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem(
              'Start Balance', widget.customer.startBalance, Colors.grey),
          _summaryItem('Invoiced', totalInvoiced, Colors.orange),
          _summaryItem('Paid', totalPaid, Colors.green),
          _summaryItem(
              'Balance', balance, balance > 0 ? Colors.red : Colors.green),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          '£${amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildLedgerTile(Map<String, dynamic> entry) {
    final entryType = entry['type'] as String;
    final isInvoice = entryType == 'invoice' || entryType == 'opening';
    final isOpening = entryType == 'opening';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isInvoice
              ? (isOpening ? Colors.blue.shade100 : Colors.orange.shade100)
              : Colors.green.shade100,
          child: Icon(
            isOpening
                ? Icons.account_balance
                : (isInvoice ? Icons.receipt : Icons.payment),
            color: isInvoice
                ? (isOpening ? Colors.blue.shade700 : Colors.orange.shade700)
                : Colors.green.shade700,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(entry['reference'] as String)),
            if (isInvoice && !isOpening && widget.onEditSale != null)
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                tooltip: 'Edit invoice',
                visualDensity: VisualDensity.compact,
                onPressed: () async {
                  final saleId = entry['id'] as int?;
                  if (saleId == null) return;
                  final updated = await widget.onEditSale!(saleId);
                  if (updated && mounted) {
                    await _loadAccountSummary();
                  }
                },
              ),
          ],
        ),
        subtitle: _buildLedgerSubtitle(entry),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if ((entry['debit'] as double) > 0)
              Text(
                '£${(entry['debit'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            if ((entry['credit'] as double) > 0)
              Text(
                '£${(entry['credit'] as double).toStringAsFixed(2)}',
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLedgerSubtitle(Map<String, dynamic> entry) {
    final date = entry['date'] as String? ?? '';
    final dueDate = entry['dueDate'] as String?;
    final products = entry['products'] as List<String>?;
    final fmt = DateFormat('dd/MM/yyyy');

    final parts = <InlineSpan>[
      TextSpan(text: date, style: TextStyle(color: Colors.grey[600])),
    ];

    if (dueDate != null && dueDate.isNotEmpty) {
      final due = DateTime.tryParse(dueDate);
      if (due != null) {
        final today = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);
        final dueOnly = DateTime(due.year, due.month, due.day);
        final daysLeft = dueOnly.difference(today).inDays;
        final isOverdue = daysLeft < 0;
        final dueDateColor =
            isOverdue ? Colors.red.shade700 : Colors.amber.shade800;
        final dueDateLabel = isOverdue
            ? '${daysLeft.abs()}d overdue'
            : daysLeft == 0
                ? 'due today'
                : '${daysLeft}d left';
        parts.add(TextSpan(
          text: '  •  Due: ${fmt.format(due)} ($dueDateLabel)',
          style: TextStyle(color: dueDateColor, fontWeight: FontWeight.w600),
        ));
      }
    }

    if (products != null && products.isNotEmpty) {
      parts.add(TextSpan(
        text: '\n${products.join(', ')}',
        style: TextStyle(color: Colors.grey[700], fontSize: 11),
      ));
    }

    return RichText(text: TextSpan(children: parts));
  }
}
