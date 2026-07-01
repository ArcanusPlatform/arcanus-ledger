import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column, Table;
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../services/csv_service.dart';
import '../services/csv_platform.dart';
import '../services/customer_service.dart';
import '../utils/csv_file_picker.dart';
import '../widgets/responsive_fab.dart';
import '../widgets/responsive_filter_panel.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../features/customers/models/customer_board_models.dart';
import '../features/customers/widgets/new_sale_card.dart';
import '../features/customers/widgets/receipt_card.dart';
import '../features/customers/widgets/customer_detail_dialog.dart';
import '../features/customers/widgets/workbench_card.dart';
import '../widgets/responsive_dialog.dart';
import '../widgets/edit_sale_dialog.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final AppDatabase _db = AppDatabase.instance;
  late final CustomerService _service;

  List<PeopleData> _customers = [];
  List<PeopleData> _filteredCustomers = [];
  String _searchQuery = '';
  String _selectedSort = 'Name';
  bool _isLoading = true;
  Future<List<CustomerControlRow>>? _customersFuture;
  final _shortDateFormat = DateFormat('dd/MM');
  final _fullDateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _service = CustomerService(_db);
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);

    try {
      final people = await _db.getAllPeople();
      final customers = people
          .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
          .cast<PeopleData>()
          .toList();
      setState(() {
        _customers = customers;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading customers: $e')));
      }
    }
  }

  void _applyFilters() {
    List<PeopleData> filtered = List.from(_customers);

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((customer) {
        final query = _searchQuery.toLowerCase();
        return customer.name.toLowerCase().contains(query) ||
            (customer.phone?.toLowerCase().contains(query) ?? false) ||
            (customer.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    switch (_selectedSort) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Balance':
        // Balance is calculated asynchronously from outstanding invoices.
        break;
      case 'Credit Limit':
        filtered.sort((a, b) => b.creditLimit.compareTo(a.creditLimit));
        break;
    }

    setState(() {
      _filteredCustomers = filtered;
      _customersFuture =
          _service.buildControlRows(filtered, sortBy: _selectedSort);
    });
  }

  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < ResponsiveUtils.mobileBreakpoint;

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);
    final useWorkbench =
        MediaQuery.of(context).size.width >= ResponsiveUtils.tabletBreakpoint;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Customer Control Board',
        subtitle: 'Outstanding totals, credit limits and due dates',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: AppIconSizes.appBar),
            onPressed: () => _showCustomerForm(),
            tooltip: 'Add Customer',
          ),
        ],
      ),
      body: useWorkbench
          ? _buildMonitorWorkbench()
          : _buildCustomerBoardColumn(isMobile),
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
            onPressed: () => _showCustomerForm(),
            tooltip: 'Add Customer',
            child: const Icon(Icons.add, size: AppIconSizes.fab),
          ),
        ],
      ),
    );
  }

  Widget _buildMonitorWorkbench() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // LEFT SIDE: Action Panel (40%)
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD7E7DB)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    NewSaleCard(onSaved: _loadCustomers),
                    const SizedBox(height: 10),
                    ReceiptCard(onSaved: _loadCustomers),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // RIGHT SIDE: Control Board (60%)
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFDDE4EE)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: _buildCustomerBoardColumn(false),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerBoardColumn(bool isMobile) {
    return Column(
      children: [
        _buildSearchAndFilters(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredCustomers.isEmpty
                  ? _buildEmptyState()
                  : _buildCustomerControlBoard(isMobile),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
      child: ResponsiveFilterPanel(
        searchField: TextField(
          decoration: InputDecoration(
            hintText: 'Search customers...',
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
              DropdownMenuItem(
                value: 'Credit Limit',
                child: Text('Credit Limit'),
              ),
            ],
            onChanged: (value) {
              _selectedSort = value!;
              _applyFilters();
            },
          ),
        ],
        hasActiveFilters: _searchQuery.isNotEmpty || _selectedSort != 'Name',
        onClearFilters: () {
          _searchQuery = '';
          _selectedSort = 'Name';
          _applyFilters();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No customers found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCustomerForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Customer'),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildMobileList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: Future<List<Map<String, dynamic>>>.value(const []),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final customersWithStatus = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
          itemCount: customersWithStatus.length,
          itemBuilder: (context, index) {
            final item = customersWithStatus[index];
            final customer = item['customer'] as PeopleData;
            final rowColor = item['rowColor'] as Color;
            final balance = item['balance'] as double;
            final isOverLimit = balance > customer.creditLimit;

            return Card(
              elevation: 2,
              color: rowColor,
              margin: EdgeInsets.only(
                bottom: AppSpacing.getCardSpacing(context),
              ),
              child: InkWell(
                onTap: () => _showCustomerDetail(customer),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade700,
                            radius:
                                AppIconSizes.getCardDecorativeSize(context) / 2,
                            child: Text(
                              customer.name[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppTypography.getHeading3Size(
                                  context,
                                ),
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
                                  customer.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (customer.phone != null)
                                  Text(
                                    customer.phone!,
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
                              if (value == 'edit') _showCustomerForm(customer);
                              if (value == 'delete') _deleteCustomer(customer);
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
                            isOverLimit ? Colors.red : Colors.green,
                          ),
                          _buildInfoChip(
                            'Credit',
                            '£${customer.creditLimit.toStringAsFixed(2)}',
                            Colors.blue,
                          ),
                          _buildInfoChip(
                            'Terms',
                            '${customer.paymentTermsDays}d',
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

  // ignore: unused_element
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
                      'Credit Limit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Payment Terms',
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
                    width: 100,
                    child: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: Future<List<Map<String, dynamic>>>.value(const []),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No customers to display.'),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  );
                }

                final customersWithStatus = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customersWithStatus.length,
                  itemBuilder: (context, index) {
                    final item = customersWithStatus[index];
                    final customer = item['customer'] as PeopleData;
                    final balance = item['balance'] as double;
                    final rowColor = item['rowColor'] as Color;

                    return InkWell(
                      onTap: () => _showCustomerDetail(customer),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: rowColor,
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
                                    backgroundColor: Colors.blue.shade700,
                                    radius: AppIconSizes.listItem / 2,
                                    child: Text(
                                      customer.name[0].toUpperCase(),
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
                                      customer.name,
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
                                customer.phone ?? '-',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '£${customer.creditLimit.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${customer.paymentTermsDays} days',
                                style: const TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '£${balance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: AppIconSizes.button,
                                    ),
                                    onPressed: () =>
                                        _showCustomerForm(customer),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: AppIconSizes.button,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteCustomer(customer),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Future<List<Map<String, dynamic>>> _getCustomersWithDueStatus() async {
    List<Map<String, dynamic>> result = [];

    for (var customer in _filteredCustomers) {
      final outstanding = await _db.getOutstandingInvoices(customer.id);
      final accountSummary = await _db.getPersonAccountSummary(customer.id);

      final balance = accountSummary['balance'] as double;
      Color rowColor = Colors.grey[50]!; // Default grey for £0 balance

      // Check if there's any balance (including start balance)
      final hasBalance = balance > 0.01 || outstanding.isNotEmpty;

      if (hasBalance) {
        // Calculate the earliest due date
        DateTime? earliestDueDate;

        // Include start balance as an opening invoice if it exists
        if (customer.startBalance > 0 && customer.startDate != null) {
          final startDate = DateTime.parse(customer.startDate!);
          final startDueDate = startDate.add(
            Duration(days: customer.paymentTermsDays),
          );
          earliestDueDate = startDueDate;
        }

        // Check outstanding invoices
        for (var invoice in outstanding) {
          final invoiceDate = DateTime.parse(invoice['date']);
          final dueDate = _parseDate(invoice['dueDate'] as String?) ??
              invoiceDate.add(
                Duration(days: customer.paymentTermsDays),
              );

          if (earliestDueDate == null || dueDate.isBefore(earliestDueDate)) {
            earliestDueDate = dueDate;
          }
        }

        if (earliestDueDate != null) {
          final now = DateTime.now();
          final daysUntilDue = earliestDueDate.difference(now).inDays;

          if (daysUntilDue < 0) {
            // Overdue - Red
            rowColor = Colors.red[100]!;
          } else if (daysUntilDue <= 3) {
            // Due within 3 days - Amber
            rowColor = Colors.amber[100]!;
          } else {
            // Due in 4+ days - Green
            rowColor = Colors.green[100]!;
          }
        }
      }

      result.add(
          {'customer': customer, 'rowColor': rowColor, 'balance': balance});
    }

    return result;
  }

  Widget _buildCustomerControlBoard(bool isMobile) {
    return FutureBuilder<List<CustomerControlRow>>(
      future: _customersFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading board: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rows = snapshot.data!;
        if (rows.isEmpty) return _buildEmptyState();

        return ListView.builder(
          padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
          itemCount: rows.length,
          itemBuilder: (context, index) =>
              _buildCustomerControlTile(rows[index], isMobile),
        );
      },
    );
  }

  Widget _buildCustomerControlTile(CustomerControlRow row, bool isMobile) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(
          bottom: isMobile ? AppSpacing.getCardSpacing(context) : 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: row.riskColor, width: isMobile ? 5 : 3)),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 10,
            vertical: isMobile ? 4 : 0,
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            isMobile ? 12 : 10,
            0,
            isMobile ? 12 : 10,
            isMobile ? 16 : 8,
          ),
          minTileHeight: isMobile ? null : 48,
          backgroundColor: row.riskColor.withAlpha(18),
          collapsedBackgroundColor: row.riskColor.withAlpha(12),
          title: _buildCollapsedSummary(row, isMobile),
          subtitle: _buildCollapsedMeta(row, isMobile),
          children: [
            SizedBox(height: isMobile ? 6 : 4),
            _buildMatrixTable(row),
            SizedBox(height: isMobile ? 10 : 6),
            _buildEditableFooter(row, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsedSummary(CustomerControlRow row, bool isMobile) {
    final name = Text(
      row.customer.name,
      style: TextStyle(
        fontSize: isMobile ? AppTypography.getBodyTextSize(context) : 14,
        fontWeight: FontWeight.w700,
      ),
      overflow: TextOverflow.ellipsis,
    );
    final total = Text(
      _formatCurrency(row.total),
      style: TextStyle(
        color: row.total > 0 ? row.riskColor : Colors.grey[700],
        fontSize: isMobile ? 22 : 16,
        fontWeight: FontWeight.w800,
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          name,
          const SizedBox(height: 4),
          total,
        ],
      );
    }

    // Desktop: compact accounting columns — name | balance | LIM • DUE
    return Row(
      children: [
        Expanded(flex: 4, child: name),
        total,
        const SizedBox(width: 20),
        Text(
          'LIM ${_formatCurrency(row.customer.creditLimit)}',
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 6),
        Text('•', style: TextStyle(fontSize: 10, color: Colors.grey[400])),
        const SizedBox(width: 6),
        Text(
          'DUE ${_formatDate(row.dueDate)}',
          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCollapsedMeta(CustomerControlRow row, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 6 : 2, bottom: isMobile ? 2 : 0),
      child: Wrap(
        spacing: isMobile ? 8 : 4,
        runSpacing: isMobile ? 6 : 2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _statusChip(row.riskLabel, row.riskColor, isMobile),
          if (isMobile)
            _plainChip('Limit: ${_formatCurrency(row.customer.creditLimit)}',
                isMobile),
          if (isMobile)
            _plainChip('Due: ${_formatDate(row.dueDate)}', isMobile),
          ...row.topIndicators.map(
            (entry) => _productIndicator(entry.key, entry.value, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label, Color color, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 7,
        vertical: isMobile ? 4 : 2,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(28),
        borderRadius: BorderRadius.circular(isMobile ? 20 : 12),
        border: Border.all(color: color.withAlpha(120)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: isMobile ? AppTypography.mobileLabel : 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _plainChip(String label, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 10 : 7,
        vertical: isMobile ? 4 : 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(isMobile ? 20 : 12),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: isMobile ? 12 : 10),
      ),
    );
  }

  Widget _productIndicator(String product, double amount, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 6,
        vertical: isMobile ? 4 : 2,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(30),
        borderRadius: BorderRadius.circular(isMobile ? 20 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: isMobile ? 14 : 11,
            color: Colors.amber[800],
          ),
          SizedBox(width: isMobile ? 4 : 3),
          Text(
            '$product ${_formatCurrency(amount)}',
            style: TextStyle(
              fontSize: isMobile ? 12 : 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatrixTable(CustomerControlRow row) {
    if (row.matrix.rows.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const Text('No outstanding invoices'),
      );
    }

    final columns = row.matrix.columns;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStatePropertyAll(Colors.grey[100]),
          columns: [
            const DataColumn(label: Text('WEEK')),
            ...columns.map(
              (column) => DataColumn(label: Text(column), numeric: true),
            ),
            const DataColumn(label: Text('TOTAL'), numeric: true),
            const DataColumn(label: Text('DUE DATE')),
          ],
          rows: [
            ...row.matrix.rows.map(
              (matrixRow) => DataRow(
                cells: [
                  DataCell(_buildWeekCell(matrixRow)),
                  ...columns.map(
                    (column) => DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          matrixRow.values[column] == null
                              ? '0'
                              : _formatCurrency(matrixRow.values[column]!),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatCurrency(matrixRow.total),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  DataCell(_buildDueDateCell(matrixRow.dueDate)),
                ],
              ),
            ),
            DataRow(
              color: WidgetStatePropertyAll(Colors.grey[50]),
              cells: [
                const DataCell(
                  Text('TOTAL', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
                ...columns.map(
                  (column) => DataCell(
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _formatCurrency(row.matrix.columnTotals[column] ?? 0),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatCurrency(row.matrix.grandTotal),
                      style: const TextStyle(fontWeight: FontWeight.w800),
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

  Widget _buildWeekCell(CustomerMatrixRow row) {
    return SizedBox(
      width: 96,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(row.label, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(
            '${_shortDateFormat.format(row.date)} ${row.reference}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDueDateCell(DateTime? dueDate) {
    if (dueDate == null) {
      return Text('-', style: TextStyle(color: Colors.grey[400], fontSize: 12));
    }
    final today = _dateOnly(DateTime.now());
    final due = _dateOnly(dueDate);
    final daysLeft = due.difference(today).inDays;
    final isOverdue = daysLeft < 0;
    final isDueSoon = daysLeft >= 0 && daysLeft <= 3;
    final color = isOverdue
        ? Colors.red.shade700
        : isDueSoon
            ? Colors.amber.shade800
            : Colors.green.shade700;
    final label = isOverdue
        ? '${daysLeft.abs()}d overdue'
        : daysLeft == 0
            ? 'Due today'
            : '${daysLeft}d left';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _fullDateFormat.format(dueDate),
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10, color: color),
        ),
      ],
    );
  }

  Widget _buildEditableFooter(CustomerControlRow row, bool isMobile) {
    final fieldWidth =
        isMobile ? MediaQuery.of(context).size.width - 72 : 180.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: fieldWidth,
            child: InlineMoneyEditor(
              label: 'Credit Limit',
              value: row.customer.creditLimit,
              onSaved: (value) => _saveCreditLimit(row.customer, value),
            ),
          ),
          SizedBox(
            width: fieldWidth,
            child: InlineDateEditor(
              label: 'Due Date',
              value: row.dueDate,
              formatter: _fullDateFormat,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: AppIconSizes.button),
            onPressed: () => _showCustomerForm(row.customer),
            tooltip: 'Edit customer',
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long, size: AppIconSizes.button),
            onPressed: () => _showCustomerDetail(row.customer),
            tooltip: 'Ledger',
          ),
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: AppIconSizes.button,
              color: Colors.red,
            ),
            onPressed: () => _deleteCustomer(row.customer),
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  Future<void> _saveCreditLimit(PeopleData customer, double creditLimit) async {
    await _service.saveCreditLimit(customer, creditLimit);
    await _loadCustomers();
  }

  DateTime _dateOnly(DateTime date) => CustomerService.dateOnly(date);
  DateTime? _parseDate(String? value) => CustomerService.parseDate(value);
  String _formatDate(DateTime? date) =>
      date == null ? '-' : _fullDateFormat.format(date);
  String _formatCurrency(double amount) =>
      CustomerService.formatCurrency(amount);

  Future<void> _showCustomerForm([PeopleData? customer]) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _CustomerFormDialog(customer: customer),
    );
    if (result == true) _loadCustomers();
  }

  Future<void> _showCustomerDetail(PeopleData customer) async {
    showDialog(
      context: context,
      builder: (context) => CustomerDetailDialog(
        customer: customer,
        onEdit: () {
          Navigator.pop(context);
          _showCustomerForm(customer);
        },
        onEditSale: (saleId) async {
          final sale = await _db.getSaleById(saleId);
          if (sale == null || !context.mounted) return false;
          final updated = await showDialog<bool>(
            context: context,
            builder: (context) => EditSaleDialog(db: _db, sale: sale),
          );
          if (updated == true) {
            await _loadCustomers();
            return true;
          }
          return false;
        },
      ),
    );
  }

  Future<void> _deleteCustomer(PeopleData customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Delete "${customer.name}"?'),
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
        await _db.deletePerson(customer.id);
        await _loadCustomers();
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Customer deleted')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to delete customer: $e')));
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
              subtitle: const Text('Get CSV template for customers'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file, color: Colors.green),
              title: const Text('Import CSV'),
              subtitle: const Text('Import customers from CSV'),
              onTap: () {
                Navigator.pop(context);
                _importCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_download, color: Colors.orange),
              title: const Text('Export CSV'),
              subtitle: Text('Export ${_filteredCustomers.length} customers'),
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
      final template = csvService.generateCustomerTemplate();
      await CsvPlatform.downloadFile('customers_template.csv', template);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Template downloaded!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _importCSV() async {
    bool dialogShown = false;
    try {
      final csvContent = await CsvFilePicker.pickAndReadCsvFile();
      if (csvContent == null) return;
      final csvService = CsvService();
      if (!mounted) return;
      dialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      final importResult = await csvService.importCustomers(csvContent);
      if (!mounted) return;
      Navigator.pop(context);
      dialogShown = false;
      if (importResult['success']) {
        await _loadCustomers();
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Import failed: ${importResult['message']}')));
      }
    } catch (e) {
      if (mounted && dialogShown) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _exportCSV() async {
    try {
      final csvService = CsvService();
      final csvData = await csvService.exportCustomers();
      await CsvPlatform.downloadFile(
        'customers_export_${DateTime.now().millisecondsSinceEpoch}.csv',
        csvData,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Exported ${_filteredCustomers.length} customers')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _CustomerFormDialog extends StatefulWidget {
  final PeopleData? customer;
  const _CustomerFormDialog({this.customer});

  @override
  State<_CustomerFormDialog> createState() => _CustomerFormDialogState();
}

class _CustomerFormDialogState extends State<_CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  bool _isLoading = false;
  final _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _nameController.text = widget.customer!.name;
      _phoneController.text = widget.customer!.phone ?? '';
      _emailController.text = widget.customer!.email ?? '';
      _addressController.text = widget.customer!.address ?? '';
      _notesController.text = widget.customer!.notes ?? '';
      _creditLimitController.text = widget.customer!.creditLimit.toString();
      _paymentTermsController.text =
          widget.customer!.paymentTermsDays.toString();
    } else {
      _creditLimitController.text = '1000.00';
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
    _creditLimitController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final companion = PeopleCompanion(
        id: widget.customer != null
            ? Value(widget.customer!.id)
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
        type: const Value('CUSTOMER'),
        creditLimit: Value(
          double.tryParse(_creditLimitController.text) ?? 1000.0,
        ),
        paymentTermsDays: Value(
          int.tryParse(_paymentTermsController.text) ?? 30,
        ),
        startBalance: widget.customer != null
            ? Value(widget.customer!.startBalance)
            : const Value(0.0),
        startDate: widget.customer != null
            ? Value(widget.customer!.startDate)
            : Value(DateTime.now().toIso8601String().split('T')[0]),
        dueDate: widget.customer != null
            ? Value(widget.customer!.dueDate)
            : const Value.absent(),
        isDeleted: const Value(0),
      );

      if (widget.customer != null) {
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
      title: Text(widget.customer == null ? 'Add Customer' : 'Edit Customer'),
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
                controller: _creditLimitController,
                decoration: const InputDecoration(
                  labelText: 'Credit Limit (£)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              : Text(widget.customer == null ? 'Add' : 'Save'),
        ),
      ],
    );
  }
}
