import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../services/csv_platform.dart';
import '../services/csv_service.dart';
import '../utils/csv_file_picker.dart';
import '../widgets/responsive_fab.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/responsive_filter_panel.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../purchase_invoice_screen.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  final AppDatabase _db = AppDatabase.instance;

  List<PeopleData> _suppliers = [];
  List<PeopleData> _filteredSuppliers = [];
  final Map<int, double> _supplierBalances = {};
  final Map<int, int> _supplierOutstandingCounts = {};
  final Map<int, DateTime?> _supplierDueDates = {};
  String _searchQuery = '';
  String _selectedSort = 'Name';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    setState(() => _isLoading = true);

    try {
      final people = await _db.getAllPeople();
      final suppliers = people
          .where((p) => p.type == 'SUPPLIER' && p.isDeleted == 0)
          .cast<PeopleData>()
          .toList();
      final balances = <int, double>{};
      final outstandingCounts = <int, int>{};
      final dueDates = <int, DateTime?>{};

      for (final supplier in suppliers) {
        final summary = await _db.getSupplierAccountSummary(supplier.id);
        final outstanding = await _db.getOutstandingSupplierInvoices(
          supplier.id,
        );
        balances[supplier.id] = summary['balance'] as double? ?? 0.0;
        outstandingCounts[supplier.id] = outstanding.length;
        dueDates[supplier.id] = _earliestSupplierDueDate(
          supplier,
          outstanding,
        );
      }

      setState(() {
        _suppliers = suppliers;
        _supplierBalances
          ..clear()
          ..addAll(balances);
        _supplierOutstandingCounts
          ..clear()
          ..addAll(outstandingCounts);
        _supplierDueDates
          ..clear()
          ..addAll(dueDates);
        _filteredSuppliers = _filteredAndSortedSuppliers();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading suppliers: $e')));
      }
    }
  }

  void _applyFilters() {
    setState(() => _filteredSuppliers = _filteredAndSortedSuppliers());
  }

  List<PeopleData> _filteredAndSortedSuppliers() {
    List<PeopleData> filtered = List.from(_suppliers);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((supplier) {
        final query = _searchQuery.toLowerCase();
        return supplier.name.toLowerCase().contains(query) ||
            (supplier.phone?.toLowerCase().contains(query) ?? false) ||
            (supplier.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Balance':
        filtered.sort((a, b) => _balanceFor(b).compareTo(_balanceFor(a)));
        break;
    }

    return filtered;
  }

  double _balanceFor(PeopleData supplier) =>
      _supplierBalances[supplier.id] ?? supplier.startBalance;

  int _outstandingCountFor(PeopleData supplier) =>
      _supplierOutstandingCounts[supplier.id] ?? 0;

  DateTime? _dueDateFor(PeopleData supplier) => _supplierDueDates[supplier.id];

  DateTime? _earliestSupplierDueDate(
    PeopleData supplier,
    List<Map<String, dynamic>> outstanding,
  ) {
    DateTime? earliest;
    for (final invoice in outstanding) {
      final due = _parseDate(invoice['dueDate'] as String?) ??
          (_parseDate(invoice['date'] as String?)?.add(
            Duration(days: supplier.paymentTermsDays),
          ));
      if (due != null && (earliest == null || due.isBefore(earliest))) {
        earliest = due;
      }
    }
    return earliest;
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value);
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Suppliers',
        subtitle: 'Manage your supplier list',
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, size: AppIconSizes.appBar),
            onPressed: () => _openPurchaseInvoice(),
            tooltip: 'New Purchase Invoice',
          ),
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: () => _showSupplierForm(),
            tooltip: 'Add Supplier',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredSuppliers.isEmpty
                    ? _buildEmptyState()
                    : isMobile
                        ? _buildMobileList()
                        : _buildDesktopTable(),
          ),
        ],
      ),
      floatingActionButton: StackedFABs(
        fabs: [
          FloatingActionButton(
            heroTag: 'csv',
            mini: true,
            onPressed: _showCSVMenu,
            tooltip: 'CSV Import/Export',
            child: const Icon(Icons.upload_file, size: AppIconSizes.fab),
          ),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => _showSupplierForm(),
            tooltip: 'Add Supplier',
            child: const Icon(Icons.add, size: AppIconSizes.fab),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: ResponsiveFilterPanel(
        searchField: TextField(
          decoration: InputDecoration(
            hintText: 'Search suppliers...',
            prefixIcon: const Icon(Icons.search, size: AppIconSizes.listItem),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: (value) {
            _searchQuery = value;
            _applyFilters();
          },
        ),
        filters: [
          DropdownButtonFormField<String>(
            initialValue: _selectedSort,
            decoration: const InputDecoration(
              labelText: 'Sort',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Name', child: Text('Name')),
              DropdownMenuItem(value: 'Balance', child: Text('Balance')),
            ],
            onChanged: (value) {
              _selectedSort = value!;
              _applyFilters();
            },
          ),
        ],
        hasActiveFilters: _searchQuery.isNotEmpty || _selectedSort != 'Name',
        onClearFilters: () {
          setState(() {
            _searchQuery = '';
            _selectedSort = 'Name';
            _applyFilters();
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No suppliers found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showSupplierForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Supplier'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      itemCount: _filteredSuppliers.length,
      itemBuilder: (context, index) {
        final supplier = _filteredSuppliers[index];
        final balance = _balanceFor(supplier);
        final outstandingCount = _outstandingCountFor(supplier);

        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: AppSpacing.getCardSpacing(context)),
          child: InkWell(
            onTap: () => _showSupplierDetail(supplier),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.orange.shade700,
                        radius: AppIconSizes.getCardDecorativeSize(context) / 2,
                        child: Text(
                          supplier.name[0].toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppTypography.getHeading3Size(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supplier.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (supplier.phone != null)
                              Text(
                                supplier.phone!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        icon: const Icon(
                          Icons.more_vert,
                          size: AppIconSizes.listItem,
                        ),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'invoice',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: AppIconSizes.button,
                                ),
                                SizedBox(width: 8),
                                Text('New Invoice'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'payment',
                            child: Row(
                              children: [
                                Icon(Icons.payments, size: AppIconSizes.button),
                                SizedBox(width: 8),
                                Text('Record Payment'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: AppIconSizes.button),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: AppIconSizes.button,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'invoice') {
                            _openPurchaseInvoice(supplier);
                          }
                          if (value == 'payment') {
                            _showSupplierPaymentDialog(supplier);
                          }
                          if (value == 'edit') _showSupplierForm(supplier);
                          if (value == 'delete') _deleteSupplier(supplier);
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoChip(
                        'Balance',
                        '£${balance.toStringAsFixed(2)}',
                        balance > 0.01 ? Colors.red : Colors.green,
                      ),
                      _buildInfoChip(
                        'Open Invoices',
                        outstandingCount.toString(),
                        outstandingCount > 0 ? Colors.orange : Colors.green,
                      ),
                      _buildInfoChip(
                        'Terms',
                        '${supplier.paymentTermsDays}d',
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) {
            return Text(
              label,
              style: AppTypography.getLabelStyle(
                context,
                color: Colors.grey[600],
              ),
            );
          },
        ),
        const SizedBox(height: 2),
        Builder(
          builder: (context) {
            return Text(
              value,
              style: AppTypography.getBodyTextStyle(
                context,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDesktopTable() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Telephone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Notes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Balance',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 176,
                    child: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredSuppliers.length,
              itemBuilder: (context, index) {
                final supplier = _filteredSuppliers[index];
                final balance = _balanceFor(supplier);
                final outstandingCount = _outstandingCountFor(supplier);

                return InkWell(
                  onTap: () => _showSupplierDetail(supplier),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.orange.shade700,
                                radius: AppIconSizes.listItem / 2,
                                child: Text(
                                  supplier.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppTypography.getLabelSize(
                                      context,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  supplier.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            supplier.phone ?? '-',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            supplier.address ?? '-',
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            supplier.notes ?? '-',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            outstandingCount == 0
                                ? '£${balance.toStringAsFixed(2)}'
                                : '£${balance.toStringAsFixed(2)} ($outstandingCount)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: balance > 0.01
                                  ? Colors.red
                                  : Colors.green.shade700,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 176,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.receipt_long,
                                  size: AppIconSizes.button,
                                ),
                                onPressed: () => _openPurchaseInvoice(supplier),
                                tooltip: 'New Invoice',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.payments,
                                  size: AppIconSizes.button,
                                ),
                                onPressed: () =>
                                    _showSupplierPaymentDialog(supplier),
                                tooltip: 'Record Payment',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  size: AppIconSizes.button,
                                ),
                                onPressed: () => _showSupplierForm(supplier),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: AppIconSizes.button,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteSupplier(supplier),
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSupplierForm([PeopleData? supplier]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _SupplierFormDialog(supplier: supplier),
    );
    if (result == true) _loadSuppliers();
  }

  void _showSupplierDetail(PeopleData supplier) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680, maxHeight: 760),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade700, Colors.orange.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 32,
                      child: Text(
                        supplier.name[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.orange.shade700,
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
                            supplier.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(51),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SUPPLIER',
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
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: AppIconSizes.appBar,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildDetailSection(
                        'Contact Information',
                        Icons.contact_phone,
                        [
                          _detailRow(
                            Icons.phone,
                            'Telephone',
                            supplier.phone ?? 'Not provided',
                          ),
                          _detailRow(
                            Icons.email,
                            'Email',
                            supplier.email ?? 'Not provided',
                          ),
                          _detailRow(
                            Icons.location_on,
                            'Location',
                            supplier.address ?? 'Not provided',
                          ),
                          if (supplier.notes != null &&
                              supplier.notes!.isNotEmpty)
                            _detailRow(Icons.note, 'Notes', supplier.notes!),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDetailSection(
                        'Financial Information',
                        Icons.account_balance_wallet,
                        [
                          _detailRow(
                            Icons.account_balance,
                            'Current Balance',
                            '£${_balanceFor(supplier).toStringAsFixed(2)}',
                            valueColor: _balanceFor(supplier) > 0.01
                                ? Colors.red
                                : Colors.green.shade700,
                          ),
                          _detailRow(
                            Icons.receipt_long,
                            'Open Invoices',
                            _outstandingCountFor(supplier).toString(),
                          ),
                          _detailRow(
                            Icons.event,
                            'Next Due',
                            _formatOptionalDate(_dueDateFor(supplier)),
                          ),
                          _detailRow(
                            Icons.calendar_today,
                            'Payment Terms',
                            '${supplier.paymentTermsDays} days',
                          ),
                          if (supplier.startDate != null)
                            _detailRow(
                              Icons.event,
                              'Start Date',
                              supplier.startDate!,
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder<_SupplierDetailData>(
                        future: _loadSupplierDetailData(supplier.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError || snapshot.data == null) {
                            return _buildDetailSection(
                              'Supplier Ledger',
                              Icons.error_outline,
                              [
                                Text(
                                  'Could not load supplier ledger.',
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ],
                            );
                          }

                          return _buildSupplierLedgerSection(
                            supplier,
                            snapshot.data!,
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSupplierPaymentDialog(supplier);
                            },
                            icon: const Icon(Icons.payments),
                            label: const Text('Record Payment'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _openPurchaseInvoice(supplier);
                            },
                            icon: const Icon(Icons.receipt_long),
                            label: const Text('New Invoice'),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSupplierForm(supplier);
                            },
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.orange.shade700),
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

  Widget _detailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: AppIconSizes.button, color: Colors.grey[600]),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
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

  Future<_SupplierDetailData> _loadSupplierDetailData(int supplierId) async {
    final summary = await _db.getSupplierAccountSummary(supplierId);
    final outstanding = await _db.getOutstandingSupplierInvoices(supplierId);

    return _SupplierDetailData(
      summary: summary,
      outstandingInvoices: outstanding,
    );
  }

  Widget _buildSupplierLedgerSection(
    PeopleData supplier,
    _SupplierDetailData data,
  ) {
    final totalOwed = data.summary['totalOwed'] as double? ?? 0.0;
    final totalPaid = data.summary['totalPaid'] as double? ?? 0.0;
    final balance = data.summary['balance'] as double? ?? 0.0;
    final ledger = (data.summary['ledger'] as List<Map<String, dynamic>>?) ??
        const <Map<String, dynamic>>[];
    final recentLedger = ledger.reversed.take(6).toList();

    return Column(
      children: [
        _buildDetailSection(
          'Supplier Ledger',
          Icons.account_balance_wallet,
          [
            _detailRow(
              Icons.receipt_long,
              'Total Invoices',
              '£${totalOwed.toStringAsFixed(2)}',
            ),
            _detailRow(
              Icons.payments,
              'Total Paid',
              '£${totalPaid.toStringAsFixed(2)}',
              valueColor: Colors.green.shade700,
            ),
            _detailRow(
              Icons.account_balance,
              'Balance Due',
              '£${balance.toStringAsFixed(2)}',
              valueColor: balance > 0.01 ? Colors.red : Colors.green.shade700,
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildDetailSection(
          'Outstanding Invoices',
          Icons.pending_actions,
          data.outstandingInvoices.isEmpty
              ? [
                  Text(
                    'No outstanding supplier invoices.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ]
              : data.outstandingInvoices.map((invoice) {
                  return _supplierInvoiceRow(supplier, invoice);
                }).toList(),
        ),
        if (recentLedger.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildDetailSection(
            'Recent Activity',
            Icons.history,
            recentLedger.map((entry) {
              final debit = entry['debit'] as double? ?? 0.0;
              final credit = entry['credit'] as double? ?? 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      credit > 0 ? Icons.payments : Icons.receipt_long,
                      size: AppIconSizes.button,
                      color: credit > 0
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry['reference']?.toString() ?? 'Ledger entry',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatDateString(entry['date']?.toString()),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      credit > 0
                          ? '-£${credit.toStringAsFixed(2)}'
                          : '£${debit.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: credit > 0
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _supplierInvoiceRow(
    PeopleData supplier,
    Map<String, dynamic> invoice,
  ) {
    final remaining = invoice['remaining'] as double? ?? 0.0;
    final dueDate = _parseDate(invoice['dueDate'] as String?);
    final isOverdue =
        dueDate != null && dueDate.isBefore(DateTime.now()) && remaining > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isOverdue ? Icons.warning_amber : Icons.receipt_long,
            size: AppIconSizes.button,
            color: isOverdue ? Colors.red.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'INV-${invoice['invoiceNumber']}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Due ${_formatDateString(invoice['dueDate'] as String?)}',
                  style: TextStyle(
                    color: isOverdue ? Colors.red.shade700 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '£${remaining.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: remaining > 0.01 ? Colors.red : Colors.green.shade700,
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSupplierPaymentDialog(supplier, invoice: invoice);
            },
            child: const Text('Pay'),
          ),
        ],
      ),
    );
  }

  String _formatOptionalDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateString(String? value) {
    final parsed = _parseDate(value);
    return parsed == null ? '-' : _formatOptionalDate(parsed);
  }

  Future<void> _openPurchaseInvoice([PeopleData? supplier]) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PurchaseInvoiceScreen(initialSupplier: supplier),
      ),
    );
    if (result == true) {
      await _loadSuppliers();
    }
  }

  Future<void> _showSupplierPaymentDialog(
    PeopleData supplier, {
    Map<String, dynamic>? invoice,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _SupplierPaymentDialog(
        supplier: supplier,
        initialInvoice: invoice,
      ),
    );

    if (result == true) {
      await _loadSuppliers();
    }
  }

  Future<void> _deleteSupplier(PeopleData supplier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text('Delete "${supplier.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deletePerson(supplier.id);
        await _loadSuppliers();
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Supplier deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete supplier: $e')),
          );
        }
      }
    }
  }

  void _showCSVMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Download Template'),
              subtitle: const Text('Get CSV template for suppliers'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.green),
              title: const Text('Import CSV'),
              subtitle: const Text('Import suppliers from CSV'),
              onTap: () {
                Navigator.pop(context);
                _importCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download, color: Colors.orange),
              title: const Text('Export CSV'),
              subtitle: Text('Export ${_filteredSuppliers.length} suppliers'),
              onTap: () {
                Navigator.pop(context);
                _exportCSV();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadTemplate() async {
    try {
      final csvService = CsvService();
      final template = csvService.generateSupplierTemplate();
      await CsvPlatform.downloadFile('suppliers_template.csv', template);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Template downloaded!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _importCSV() async {
    try {
      final csvContent = await CsvFilePicker.pickAndReadCsvFile();
      if (csvContent == null) return;

      final csvService = CsvService();

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final importResult = await csvService.importSuppliers(csvContent);

      if (!mounted) return;
      Navigator.pop(context);

      if (importResult['success']) {
        await _loadSuppliers();
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Import Complete'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅ Imported: ${importResult['imported']}'),
                if (importResult['failed'] > 0)
                  Text('❌ Failed: ${importResult['failed']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: ${importResult['message']}')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _exportCSV() async {
    try {
      final csvService = CsvService();
      final csvData = await csvService.exportSuppliers();
      await CsvPlatform.downloadFile(
        'suppliers_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        csvData,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${_filteredSuppliers.length} suppliers'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _SupplierDetailData {
  const _SupplierDetailData({
    required this.summary,
    required this.outstandingInvoices,
  });

  final Map<String, dynamic> summary;
  final List<Map<String, dynamic>> outstandingInvoices;
}

class _SupplierPaymentDialog extends StatefulWidget {
  const _SupplierPaymentDialog({
    required this.supplier,
    this.initialInvoice,
  });

  final PeopleData supplier;
  final Map<String, dynamic>? initialInvoice;

  @override
  State<_SupplierPaymentDialog> createState() => _SupplierPaymentDialogState();
}

class _SupplierPaymentDialogState extends State<_SupplierPaymentDialog> {
  static const _autoAllocateId = -1;
  static const _paymentMethods = [
    'Bank Transfer',
    'Card',
    'Cash',
    'Direct Debit',
    'Cheque',
    'Other',
  ];

  final _db = AppDatabase.instance;
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  List<Map<String, dynamic>> _outstanding = [];
  DateTime _paidDate = DateTime.now();
  String _paymentMethod = _paymentMethods.first;
  int _selectedInvoiceId = _autoAllocateId;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadOutstanding();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _loadOutstanding() async {
    final outstanding = await _db.getOutstandingSupplierInvoices(
      widget.supplier.id,
    );
    outstanding.sort((a, b) {
      final aDate = (a['dueDate'] ?? a['date']).toString();
      final bDate = (b['dueDate'] ?? b['date']).toString();
      return aDate.compareTo(bDate);
    });

    final initialInvoiceId = widget.initialInvoice?['id'] as int?;
    Map<String, dynamic>? selectedInvoice;
    if (initialInvoiceId != null) {
      for (final invoice in outstanding) {
        if (invoice['id'] == initialInvoiceId) {
          selectedInvoice = invoice;
          break;
        }
      }
    }

    final defaultAmount = selectedInvoice == null
        ? outstanding.fold(
            0.0,
            (sum, invoice) =>
                sum + ((invoice['remaining'] as num?)?.toDouble() ?? 0.0),
          )
        : (selectedInvoice['remaining'] as num?)?.toDouble() ?? 0.0;

    setState(() {
      _outstanding = outstanding;
      _selectedInvoiceId = selectedInvoice == null
          ? _autoAllocateId
          : selectedInvoice['id'] as int;
      _amountController.text =
          defaultAmount == 0 ? '' : defaultAmount.toStringAsFixed(2);
      _referenceController.text = selectedInvoice == null
          ? 'Supplier payment - ${widget.supplier.name}'
          : 'Payment for supplier invoice ${selectedInvoice['invoiceNumber']}';
      _loading = false;
    });
  }

  Future<void> _pickPaidDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paidDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _paidDate = picked);
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    if (amount <= 0) {
      _snack('Enter a payment amount');
      return;
    }

    if (_outstanding.isEmpty) {
      _snack('No outstanding supplier invoices to pay');
      return;
    }

    final allocations = <Map<String, dynamic>>[];

    if (_selectedInvoiceId == _autoAllocateId) {
      var remainingPayment = amount;
      for (final invoice in _outstanding) {
        if (remainingPayment <= 0) break;
        final remaining = (invoice['remaining'] as num?)?.toDouble() ?? 0.0;
        final allocation =
            remainingPayment < remaining ? remainingPayment : remaining;
        if (allocation > 0) {
          allocations.add({
            'invoiceId': invoice['id'] as int,
            'amount': allocation,
          });
          remainingPayment -= allocation;
        }
      }
    } else {
      final invoice = _outstanding.firstWhere(
        (item) => item['id'] == _selectedInvoiceId,
      );
      final remaining = (invoice['remaining'] as num?)?.toDouble() ?? 0.0;
      if (amount > remaining + 0.01) {
        _snack('Payment is greater than the selected invoice balance');
        return;
      }
      allocations.add({
        'invoiceId': _selectedInvoiceId,
        'amount': amount,
      });
    }

    setState(() => _saving = true);
    try {
      await _db.recordSupplierPayment(
        supplierId: widget.supplier.id,
        date: _dateFormat.format(_paidDate),
        amount: amount,
        paymentMethod: _paymentMethod,
        reference: _referenceController.text.trim().isEmpty
            ? null
            : _referenceController.text.trim(),
        allocations: allocations,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      _snack('Payment failed: $error');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Supplier Payment'),
      content: SizedBox(
        width: 460,
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.supplier.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedInvoiceId,
                    decoration: const InputDecoration(
                      labelText: 'Invoice Allocation',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: _autoAllocateId,
                        child: Text('Oldest outstanding first'),
                      ),
                      ..._outstanding.map((invoice) {
                        final remaining =
                            (invoice['remaining'] as num?)?.toDouble() ?? 0.0;
                        return DropdownMenuItem<int>(
                          value: invoice['id'] as int,
                          child: Text(
                            'INV-${invoice['invoiceNumber']} - £${remaining.toStringAsFixed(2)}',
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _selectedInvoiceId = value;
                        if (value != _autoAllocateId) {
                          final invoice = _outstanding.firstWhere(
                            (item) => item['id'] == value,
                          );
                          final remaining =
                              (invoice['remaining'] as num?)?.toDouble() ?? 0.0;
                          _amountController.text = remaining.toStringAsFixed(2);
                          _referenceController.text =
                              'Payment for supplier invoice ${invoice['invoiceNumber']}';
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '£',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _paymentMethod,
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            border: OutlineInputBorder(),
                          ),
                          items: _paymentMethods
                              .map(
                                (method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _paymentMethod = value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.event_available, size: 16),
                          label: Text('Paid: ${_dateFormat.format(_paidDate)}'),
                          onPressed: _pickPaidDate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _referenceController,
                    decoration: const InputDecoration(
                      labelText: 'Reference',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: Text(_saving ? 'Saving...' : 'Save Payment'),
        ),
      ],
    );
  }
}

class _SupplierFormDialog extends StatefulWidget {
  final PeopleData? supplier;
  const _SupplierFormDialog({this.supplier});

  @override
  State<_SupplierFormDialog> createState() => _SupplierFormDialogState();
}

class _SupplierFormDialogState extends State<_SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  bool _isLoading = false;
  final _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _phoneController.text = widget.supplier!.phone ?? '';
      _emailController.text = widget.supplier!.email ?? '';
      _addressController.text = widget.supplier!.address ?? '';
      _notesController.text = widget.supplier!.notes ?? '';
      _paymentTermsController.text =
          widget.supplier!.paymentTermsDays.toString();
    } else {
      _paymentTermsController.text = '30';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final companion = PeopleCompanion(
        id: widget.supplier != null
            ? Value(widget.supplier!.id)
            : const Value.absent(),
        name: Value(_nameController.text.trim()),
        phone: Value(
          _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
        email: Value(
          _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
        ),
        address: Value(
          _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
        ),
        notes: Value(
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
        type: const Value('SUPPLIER'),
        creditLimit: const Value(0.0),
        paymentTermsDays: Value(
          int.tryParse(_paymentTermsController.text) ?? 30,
        ),
        startBalance: widget.supplier != null
            ? Value(widget.supplier!.startBalance)
            : const Value(0.0),
        startDate: widget.supplier != null
            ? Value(widget.supplier!.startDate)
            : Value(DateTime.now().toIso8601String().split('T')[0]),
        isDeleted: const Value(0),
      );

      if (widget.supplier != null) {
        await _db.updatePerson(companion);
      } else {
        await _db.addPerson(companion);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      title: Text(widget.supplier == null ? 'Add Supplier' : 'Edit Supplier'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telephone',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.mobileFormFieldSpacing),
              TextFormField(
                controller: _paymentTermsController,
                decoration: const InputDecoration(
                  labelText: 'Payment Terms (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          style: TextButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.minButtonHeight),
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, AppSpacing.minButtonHeight),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.supplier == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
