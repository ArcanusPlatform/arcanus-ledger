import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database.dart';
import '../services/csv_platform.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _db = AppDatabase.instance;
  final _displayDateFormat = DateFormat('dd/MM/yyyy');
  final _fileDateFormat = DateFormat('yyyy-MM-dd');

  String _selectedReport = 'Sales by Customer';
  String _selectedPreset = 'This Month';
  String _saleSettlementFilter = 'All';
  String _agingBucketFilter = 'All';
  int? _selectedCustomerId;
  int? _selectedProductId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<PeopleData> _customers = [];
  List<Product> _products = [];
  Map<String, dynamic>? _selectedItem;

  final List<String> _reportTypes = [
    'Sales by Customer',
    'Sales by Product',
    'Invoice Totals',
    'Cashflow',
    'Aging Report',
    'Customer Balances',
    'Product Performance',
  ];

  final List<String> _periodPresets = [
    'Today',
    'This Week',
    'This Month',
    'This Quarter',
    'This Year',
    'Custom',
  ];

  final List<String> _agingBuckets = [
    'All',
    'Not Due',
    '0-30',
    '31-60',
    '61-90',
    '90+',
  ];

  @override
  void initState() {
    super.initState();
    _setPreset('This Month', notify: false);
    _loadFilterOptions();
  }

  Future<void> _loadFilterOptions() async {
    final people = (await _db.getAllPeople()).cast<PeopleData>();
    final products = (await _db.getAllProducts()).cast<Product>();

    if (!mounted) return;
    setState(() {
      _customers = people
          .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _products = products.where((p) => p.isDeleted == 0).toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reports',
        subtitle: 'Period-based accounting reports',
      ),
      body: Column(
        children: [
          _buildFilterBar(isSmallScreen),
          _buildReportSelector(isSmallScreen),
          Expanded(
            child: isSmallScreen
                ? _buildReportContent(true)
                : _buildEnhancedLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(bool isSmall) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isSmall ? 12 : 16,
          12,
          isSmall ? 12 : 16,
          8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _periodPresets.map((preset) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(preset),
                      selected: _selectedPreset == preset,
                      onSelected: (_) => _setPreset(preset),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _dateButton(
                  label: 'Start Date',
                  date: _startDate,
                  onPressed: () => _pickDate(isStartDate: true),
                ),
                _dateButton(
                  label: 'End Date',
                  date: _endDate,
                  onPressed: () => _pickDate(isStartDate: false),
                ),
                _dropdown<String>(
                  width: 190,
                  label: 'Sale / Receipt Type',
                  value: _saleSettlementFilter,
                  items: const ['All', 'Cash Sales', 'Credit Sales'],
                  onChanged: (value) {
                    setState(() {
                      _saleSettlementFilter = value ?? 'All';
                      _selectedItem = null;
                    });
                  },
                ),
                _dropdown<int>(
                  width: 220,
                  label: 'Customer',
                  value: _selectedCustomerId ?? -1,
                  items: [-1, ..._customers.map((c) => c.id)],
                  itemLabel: (id) =>
                      id == -1 ? 'All Customers' : _customerName(id),
                  onChanged: (value) {
                    setState(() {
                      _selectedCustomerId = value == -1 ? null : value;
                      _selectedItem = null;
                    });
                  },
                ),
                _dropdown<int>(
                  width: 220,
                  label: 'Product',
                  value: _selectedProductId ?? -1,
                  items: [-1, ..._products.map((p) => p.id)],
                  itemLabel: (id) =>
                      id == -1 ? 'All Products' : _productName(id),
                  onChanged: (value) {
                    setState(() {
                      _selectedProductId = value == -1 ? null : value;
                      _selectedItem = null;
                    });
                  },
                ),
                if (_selectedReport == 'Aging Report')
                  _dropdown<String>(
                    width: 150,
                    label: 'Aging',
                    value: _agingBucketFilter,
                    items: _agingBuckets,
                    onChanged: (value) {
                      setState(() {
                        _agingBucketFilter = value ?? 'All';
                        _selectedItem = null;
                      });
                    },
                  ),
                FilledButton.icon(
                  onPressed: _exportReport,
                  icon: const Icon(Icons.download, size: AppIconSizes.button),
                  label: const Text('Export'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateButton({
    required String label,
    required DateTime date,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.calendar_today, size: AppIconSizes.button),
      label: Text('$label ${_displayDateFormat.format(date)}'),
    );
  }

  Widget _dropdown<T>({
    required double width,
    required String label,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    String Function(T value)? itemLabel,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel == null ? item.toString() : itemLabel(item),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildReportSelector(bool isSmall) {
    return Container(
      padding: EdgeInsets.fromLTRB(isSmall ? 12 : 16, 8, isSmall ? 12 : 16, 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _reportTypes.map((report) {
            final isSelected = _selectedReport == report;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(report),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedReport = report;
                    _selectedItem = null;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEnhancedLayout() {
    if (_selectedReport == 'Aging Report') {
      return Column(
        children: [
          _buildKpiBar(),
          const Divider(height: 1),
          Expanded(child: _buildAgingTable()),
        ],
      );
    }

    return Column(
      children: [
        _buildKpiBar(),
        const Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              SizedBox(width: 370, child: _buildReportListPanel()),
              const VerticalDivider(width: 1),
              Expanded(child: _buildReportDetailPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpiBar() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCurrentReportData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 96);

        final data = snapshot.data!;
        final total = data.fold(0.0, (sum, row) => sum + _reportValue(row));
        final topLabel = data.isEmpty ? '-' : _displayName(data.first);

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          color: Colors.white,
          child: Row(
            children: [
              _kpiCard(
                'Total Value',
                '£${total.toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                Colors.blue,
              ),
              _kpiCard(
                'Records',
                '${data.length}',
                Icons.list_alt,
                Colors.orange,
              ),
              _kpiCard(
                'Period',
                '${_displayDateFormat.format(_startDate)} - ${_displayDateFormat.format(_endDate)}',
                Icons.date_range,
                Colors.teal,
              ),
              _kpiCard('Top Row', topLabel, Icons.star, Colors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _kpiCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportListPanel() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getCurrentReportData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        if (data.isEmpty) {
          return const Center(child: Text('No rows for this period'));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final isSelected = _selectedItem == item;
            return ListTile(
              selected: isSelected,
              selectedTileColor: Colors.blue.shade50,
              title: Text(
                _displayName(item),
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle:
                  Text(_rowSubtitle(item), overflow: TextOverflow.ellipsis),
              trailing: Text(
                '£${_reportValue(item).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => setState(() => _selectedItem = item),
            );
          },
        );
      },
    );
  }

  Widget _buildReportDetailPanel() {
    if (_selectedItem == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined,
                size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('Select a row to view report details'),
          ],
        ),
      );
    }

    final entries = _selectedItem!.entries
        .where((entry) =>
            !{'customerId', 'productId', 'saleId'}.contains(entry.key))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _displayName(_selectedItem!),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: entries.map((entry) {
                  return Container(
                    width: 210,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleCase(entry.key),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _formatValue(entry.value),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(bool isSmall) {
    switch (_selectedReport) {
      case 'Sales by Customer':
        return _reportList(_getSalesByCustomer(), isSmall);
      case 'Sales by Product':
        return _reportList(_getSalesByProduct(), isSmall);
      case 'Invoice Totals':
        return _reportList(_getInvoiceTotals(), isSmall);
      case 'Cashflow':
        return _reportList(_getCashflow(), isSmall);
      case 'Aging Report':
        return _buildAgingReport(isSmall);
      case 'Customer Balances':
        return _reportList(_getCustomerBalances(), isSmall);
      case 'Product Performance':
        return _reportList(_getProductPerformance(), isSmall);
      default:
        return const Center(child: Text('Select a report'));
    }
  }

  Widget _reportList(Future<List<Map<String, dynamic>>> future, bool isSmall) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        if (data.isEmpty) {
          return const Center(child: Text('No rows for this period'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  _displayName(item),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_rowSubtitle(item)),
                trailing: Text(
                  '£${_reportValue(item).toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAgingReport(bool isSmall) {
    if (!isSmall) return _buildAgingTable();

    return FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
      future: _getAgingReport(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final hasRows = data.values.any((items) => items.isNotEmpty);
        if (!hasRows) {
          return const Center(
              child: Text('No outstanding invoices for this period'));
        }

        return ListView(
          padding: EdgeInsets.all(isSmall ? 12 : 16),
          children: [
            _buildAgingSection('Not Due', data['notDue']!, Colors.blueGrey),
            _buildAgingSection(
                '0-30 Days Overdue', data['30days']!, Colors.orange),
            _buildAgingSection(
                '31-60 Days Overdue', data['60days']!, Colors.amber),
            _buildAgingSection(
                '61-90 Days Overdue', data['90days']!, Colors.deepOrange),
            _buildAgingSection(
                '90+ Days Overdue', data['overdue']!, Colors.red),
          ].where((widget) => widget is! SizedBox).toList(),
        );
      },
    );
  }

  Widget _buildAgingTable() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getAgingRows(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final rows = snapshot.data!;
        if (rows.isEmpty) {
          return const Center(
              child: Text('No outstanding invoices for this period'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStatePropertyAll(Colors.blueGrey.shade50),
              columns: const [
                DataColumn(label: Text('Sale ID')),
                DataColumn(label: Text('Customer')),
                DataColumn(label: Text('Invoice')),
                DataColumn(label: Text('Invoice Date')),
                DataColumn(label: Text('Due Date')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Days Overdue')),
                DataColumn(label: Text('Basis')),
              ],
              rows: rows.map((row) {
                return DataRow(
                  cells: [
                    DataCell(Text(row['saleId'].toString())),
                    DataCell(Text(row['customerName'] as String)),
                    DataCell(Text(row['invoiceNumber'].toString())),
                    DataCell(Text(row['invoiceDate'] as String)),
                    DataCell(Text(row['dueDate'] as String)),
                    DataCell(Text(
                        '£${(row['amount'] as double).toStringAsFixed(2)}')),
                    DataCell(Text(row['daysOverdue'].toString())),
                    DataCell(Text(row['basis'] as String)),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAgingSection(
    String title,
    List<Map<String, dynamic>> items,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '£${items.fold(0.0, (sum, item) => sum + (item['amount'] as double)).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ...items.map(
            (item) => ListTile(
              title: Text(item['customerName'] as String),
              subtitle: Text(
                'Invoice #${item['invoiceNumber']} | ${item['daysOverdue']} days overdue',
              ),
              trailing: Text(
                '£${(item['amount'] as double).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getCurrentReportData() async {
    switch (_selectedReport) {
      case 'Sales by Customer':
        return _getSalesByCustomer();
      case 'Sales by Product':
        return _getSalesByProduct();
      case 'Invoice Totals':
        return _getInvoiceTotals();
      case 'Cashflow':
        return _getCashflow();
      case 'Customer Balances':
        return _getCustomerBalances();
      case 'Aging Report':
        return _getAgingRows();
      case 'Product Performance':
        return _getProductPerformance();
      default:
        return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getAgingRows() async {
    final aging = await _getAgingReport();
    return [
      ...aging['notDue']!,
      ...aging['30days']!,
      ...aging['60days']!,
      ...aging['90days']!,
      ...aging['overdue']!,
    ];
  }

  Future<List<Map<String, dynamic>>> _getSalesByCustomer() async {
    final people = await _peopleById();
    final sales = await _filteredSalesByInvoiceDate();
    final saleItems = await _db.getAllSaleItems();
    final customerSales = <int, Map<String, dynamic>>{};
    final invoiceIdsByCustomer = <int, Set<int>>{};
    final cashInvoiceIdsByCustomer = <int, Set<int>>{};
    final creditInvoiceIdsByCustomer = <int, Set<int>>{};
    double totalSales = 0;

    if (_selectedProductId != null) {
      final salesById = {for (final sale in sales) sale.id: sale};
      for (final item in saleItems.where((item) =>
          item.productId == _selectedProductId &&
          salesById.containsKey(item.saleId))) {
        final sale = salesById[item.saleId]!;
        final row = customerSales.putIfAbsent(
          sale.personId,
          () => {
            'customerId': sale.personId,
            'customerName': people[sale.personId]?.name ?? 'Unknown',
            'cashSales': 0.0,
            'creditSales': 0.0,
            'totalSales': 0.0,
            'cashInvoiceCount': 0,
            'creditInvoiceCount': 0,
            'invoiceCount': 0,
          },
        );
        final saleType = sale.saleType.toUpperCase();
        final splitKey = saleType == 'CASH' ? 'cashSales' : 'creditSales';
        row[splitKey] = (row[splitKey] as double) + item.total;
        row['totalSales'] = (row['totalSales'] as double) + item.total;
        invoiceIdsByCustomer
            .putIfAbsent(sale.personId, () => <int>{})
            .add(sale.id);
        if (saleType == 'CASH') {
          cashInvoiceIdsByCustomer
              .putIfAbsent(sale.personId, () => <int>{})
              .add(sale.id);
        } else {
          creditInvoiceIdsByCustomer
              .putIfAbsent(sale.personId, () => <int>{})
              .add(sale.id);
        }
        totalSales += item.total;
      }
    } else {
      for (final sale in sales) {
        final row = customerSales.putIfAbsent(
          sale.personId,
          () => {
            'customerId': sale.personId,
            'customerName': people[sale.personId]?.name ?? 'Unknown',
            'cashSales': 0.0,
            'creditSales': 0.0,
            'totalSales': 0.0,
            'cashInvoiceCount': 0,
            'creditInvoiceCount': 0,
            'invoiceCount': 0,
          },
        );
        final saleType = sale.saleType.toUpperCase();
        final splitKey = saleType == 'CASH' ? 'cashSales' : 'creditSales';
        final splitCountKey =
            saleType == 'CASH' ? 'cashInvoiceCount' : 'creditInvoiceCount';
        row[splitKey] = (row[splitKey] as double) + sale.total;
        row['totalSales'] = (row['totalSales'] as double) + sale.total;
        row[splitCountKey] = (row[splitCountKey] as int) + 1;
        row['invoiceCount'] = (row['invoiceCount'] as int) + 1;
        totalSales += sale.total;
      }
    }

    for (final entry in invoiceIdsByCustomer.entries) {
      customerSales[entry.key]!['invoiceCount'] = entry.value.length;
    }
    for (final entry in cashInvoiceIdsByCustomer.entries) {
      customerSales[entry.key]!['cashInvoiceCount'] = entry.value.length;
    }
    for (final entry in creditInvoiceIdsByCustomer.entries) {
      customerSales[entry.key]!['creditInvoiceCount'] = entry.value.length;
    }

    final result = customerSales.values.toList();
    for (final item in result) {
      item['percentage'] = totalSales > 0
          ? ((item['totalSales'] as double) / totalSales) * 100
          : 0.0;
      item['basis'] = 'Invoice date';
      item['saleType'] = _saleFilterLabel();
    }
    result.sort((a, b) =>
        (b['totalSales'] as double).compareTo(a['totalSales'] as double));
    return result;
  }

  Future<List<Map<String, dynamic>>> _getSalesByProduct() async {
    final products = {
      for (final product in await _db.getAllProducts())
        product.id: product as Product
    };
    final sales = await _filteredSalesByInvoiceDate();
    final salesById = {for (final sale in sales) sale.id: sale};
    final saleItems = await _db.getAllSaleItems();
    final productSales = <int, Map<String, dynamic>>{};

    for (final item in saleItems.where((item) =>
        salesById.containsKey(item.saleId) &&
        (_selectedProductId == null || item.productId == _selectedProductId))) {
      final sale = salesById[item.saleId]!;
      final product = products[item.productId];
      final row = productSales.putIfAbsent(
        item.productId,
        () => {
          'productId': item.productId,
          'productName': product?.name ?? 'Unknown',
          'cashRevenue': 0.0,
          'creditRevenue': 0.0,
          'totalRevenue': 0.0,
          'cashQuantity': 0.0,
          'creditQuantity': 0.0,
          'totalQuantity': 0.0,
          'costOfGoods': 0.0,
          'grossMargin': 0.0,
          'cashLineCount': 0,
          'creditLineCount': 0,
          'lineCount': 0,
        },
      );

      final saleType = sale.saleType.toUpperCase();
      final revenueKey = saleType == 'CASH' ? 'cashRevenue' : 'creditRevenue';
      final quantityKey =
          saleType == 'CASH' ? 'cashQuantity' : 'creditQuantity';
      final lineCountKey =
          saleType == 'CASH' ? 'cashLineCount' : 'creditLineCount';

      row[revenueKey] = (row[revenueKey] as double) + item.total;
      row['totalRevenue'] = (row['totalRevenue'] as double) + item.total;
      row[quantityKey] = (row[quantityKey] as double) + item.quantity;
      row['totalQuantity'] = (row['totalQuantity'] as double) + item.quantity;
      row['costOfGoods'] = (row['costOfGoods'] as double) + item.costOfGoods;
      row[lineCountKey] = (row[lineCountKey] as int) + 1;
      row['lineCount'] = (row['lineCount'] as int) + 1;
    }

    final result = productSales.values.toList();
    for (final item in result) {
      final revenue = item['totalRevenue'] as double;
      final quantity = item['totalQuantity'] as double;
      final cost = item['costOfGoods'] as double;
      item['avgPrice'] = quantity == 0 ? 0.0 : revenue / quantity;
      item['grossMargin'] = revenue - cost;
      item['basis'] = 'Invoice date';
      item['saleType'] = _saleFilterLabel();
    }
    result.sort((a, b) =>
        (b['totalRevenue'] as double).compareTo(a['totalRevenue'] as double));
    return result;
  }

  Future<List<Map<String, dynamic>>> _getProductPerformance() async {
    final rows = await _getSalesByProduct();
    for (final row in rows) {
      final revenue = row['totalRevenue'] as double;
      final margin = row['grossMargin'] as double;
      row['marginPercent'] = revenue == 0 ? 0.0 : (margin / revenue) * 100;
    }
    return rows;
  }

  Future<List<Map<String, dynamic>>> _getInvoiceTotals() async {
    final people = await _peopleById();
    final allocatedBySale = await _allocatedBySale();
    final sales = await _filteredSalesByInvoiceDate();

    final rows = sales.map((sale) {
      final paid = allocatedBySale[sale.id] ?? 0.0;
      final outstanding = (sale.total - paid).clamp(0.0, double.infinity);
      return {
        'saleId': sale.id,
        'invoiceNumber': sale.invoiceNumber,
        'customerName': people[sale.personId]?.name ?? 'Unknown',
        'invoiceDate': _formatDateString(sale.date),
        'dueDate': sale.dueDate == null ? '' : _formatDateString(sale.dueDate!),
        'total': sale.total,
        'paid': paid,
        'outstanding': outstanding,
        'saleType': sale.saleType,
        'basis': 'Invoice date',
      };
    }).toList();

    rows.sort((a, b) =>
        (b['invoiceDate'] as String).compareTo(a['invoiceDate'] as String));
    return rows;
  }

  Future<List<Map<String, dynamic>>> _getCashflow() async {
    final people = await _peopleById();
    final payments = (await _db.getAllPayments()).cast<Payment>();
    final rows = <Map<String, dynamic>>[];

    for (final payment in payments.where((p) => p.isDeleted == 0)) {
      if (!_dateStringInRange(payment.date)) continue;
      if (_selectedCustomerId != null &&
          payment.personId != _selectedCustomerId) {
        continue;
      }

      final receiptType = payment.receiptType.toUpperCase();
      if (_saleSettlementFilter == 'Cash Sales' && receiptType != 'CASH_SALE') {
        continue;
      }
      if (_saleSettlementFilter == 'Credit Sales' &&
          receiptType != 'CREDIT_RECEIPT') {
        continue;
      }

      rows.add({
        'paymentId': payment.id,
        'customerName': people[payment.personId]?.name ?? 'Unknown',
        'receiptDate': _formatDateString(payment.date),
        'amount': payment.amount,
        'receiptType': payment.receiptType,
        'reference': payment.reference ?? '',
        'basis': 'Receipt date',
      });
    }

    rows.sort((a, b) =>
        (b['receiptDate'] as String).compareTo(a['receiptDate'] as String));
    return rows;
  }

  Future<Map<String, List<Map<String, dynamic>>>> _getAgingReport() async {
    final people = await _peopleById();
    final allocatedBySale = await _allocatedBySale();
    final sales = await _filteredSalesByInvoiceDate();
    final today = _dateOnly(DateTime.now());
    final result = {
      'notDue': <Map<String, dynamic>>[],
      '30days': <Map<String, dynamic>>[],
      '60days': <Map<String, dynamic>>[],
      '90days': <Map<String, dynamic>>[],
      'overdue': <Map<String, dynamic>>[],
    };

    for (final sale in sales.where((s) => s.status == 'NORMAL')) {
      final paid = allocatedBySale[sale.id] ?? 0.0;
      final remaining = sale.total - paid;
      if (remaining <= 0.01) continue;

      final dueDate = _parseDate(sale.dueDate ?? sale.date) ?? today;
      final daysOverdue = today.difference(_dateOnly(dueDate)).inDays;
      final bucket = _agingBucket(daysOverdue);
      if (!_matchesAgingFilter(bucket)) continue;

      result[bucket]!.add({
        'saleId': sale.id,
        'customerName': people[sale.personId]?.name ?? 'Unknown',
        'invoiceNumber': sale.invoiceNumber,
        'invoiceDate': _formatDateString(sale.date),
        'dueDate': sale.dueDate == null ? '' : _formatDateString(sale.dueDate!),
        'amount': remaining,
        'daysOverdue': daysOverdue < 0 ? 0 : daysOverdue,
        'basis': 'Outstanding aging',
      });
    }

    for (final rows in result.values) {
      rows.sort((a, b) =>
          (b['daysOverdue'] as int).compareTo(a['daysOverdue'] as int));
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> _getCustomerBalances() async {
    final people = (await _db.getAllPeople()).cast<PeopleData>();
    final sales =
        await _filteredSalesByInvoiceDate(applySettlementFilter: false);
    final payments = (await _db.getAllPayments()).cast<Payment>();
    final rows = <Map<String, dynamic>>[];

    for (final person in people.where((p) =>
        p.type == 'CUSTOMER' &&
        p.isDeleted == 0 &&
        (_selectedCustomerId == null || p.id == _selectedCustomerId))) {
      double invoiced = 0;
      double paid = 0;

      if (person.startBalance > 0 &&
          person.startDate != null &&
          _dateStringInRange(person.startDate!)) {
        invoiced += person.startBalance;
      }

      for (final sale in sales.where((s) => s.personId == person.id)) {
        invoiced += sale.total;
      }

      for (final payment in payments.where((p) =>
          p.personId == person.id &&
          p.isDeleted == 0 &&
          _dateStringInRange(p.date))) {
        paid += payment.amount;
      }

      if (invoiced > 0 || paid > 0) {
        rows.add({
          'customerId': person.id,
          'customerName': person.name,
          'invoiced': invoiced,
          'paid': paid,
          'balance': invoiced - paid,
          'basis': 'Invoice and receipt dates',
        });
      }
    }

    rows.sort(
        (a, b) => (b['balance'] as double).compareTo(a['balance'] as double));
    return rows;
  }

  Future<List<Sale>> _filteredSalesByInvoiceDate({
    bool applySettlementFilter = true,
  }) async {
    final sales = (await _db.getAllSales()).cast<Sale>();
    final productSaleIds = await _saleIdsForProductFilter();

    return sales.where((sale) {
      if (sale.isDeleted != 0 || sale.status == 'VOID') return false;
      if (!_dateStringInRange(sale.date)) return false;
      if (_selectedCustomerId != null && sale.personId != _selectedCustomerId) {
        return false;
      }
      if (productSaleIds != null && !productSaleIds.contains(sale.id)) {
        return false;
      }
      if (applySettlementFilter && !_matchesSaleSettlement(sale)) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<Set<int>?> _saleIdsForProductFilter() async {
    final productId = _selectedProductId;
    if (productId == null) return null;

    final saleItems = await _db.getAllSaleItems();
    return saleItems
        .where((item) => item.productId == productId)
        .map((item) => item.saleId)
        .toSet();
  }

  Future<Map<int, double>> _allocatedBySale() async {
    final allocations = await _db.getAllAllocations();
    final result = <int, double>{};
    for (final allocation
        in allocations.where((a) => a.isActive == 1 && a.allocatedItemType == 'SALE' && a.allocatedItemId > 0)) {
      result[allocation.allocatedItemId] =
          (result[allocation.allocatedItemId] ?? 0.0) + allocation.amount;
    }
    return result;
  }

  Future<Map<int, PeopleData>> _peopleById() async {
    final people = (await _db.getAllPeople()).cast<PeopleData>();
    return {for (final person in people) person.id: person};
  }

  bool _matchesSaleSettlement(Sale sale) {
    if (_saleSettlementFilter == 'All') return true;

    return switch (_saleSettlementFilter) {
      'Cash Sales' => sale.saleType.toUpperCase() == 'CASH',
      'Credit Sales' => sale.saleType.toUpperCase() == 'CREDIT',
      _ => true,
    };
  }

  bool _matchesAgingFilter(String bucket) {
    return switch (_agingBucketFilter) {
      'All' => true,
      'Not Due' => bucket == 'notDue',
      '0-30' => bucket == '30days',
      '31-60' => bucket == '60days',
      '61-90' => bucket == '90days',
      '90+' => bucket == 'overdue',
      _ => true,
    };
  }

  String _agingBucket(int daysOverdue) {
    if (daysOverdue <= 0) return 'notDue';
    if (daysOverdue <= 30) return '30days';
    if (daysOverdue <= 60) return '60days';
    if (daysOverdue <= 90) return '90days';
    return 'overdue';
  }

  void _setPreset(String preset, {bool notify = true}) {
    final now = _dateOnly(DateTime.now());
    late DateTime start;
    late DateTime end;

    switch (preset) {
      case 'Today':
        start = now;
        end = now;
        break;
      case 'This Week':
        start = now.subtract(Duration(days: now.weekday - DateTime.monday));
        end = start.add(const Duration(days: 6));
        break;
      case 'This Quarter':
        final quarterStartMonth = (((now.month - 1) ~/ 3) * 3) + 1;
        start = DateTime(now.year, quarterStartMonth, 1);
        end = DateTime(now.year, quarterStartMonth + 3, 0);
        break;
      case 'This Year':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31);
        break;
      case 'Custom':
        start = _startDate;
        end = _endDate;
        break;
      case 'This Month':
      default:
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0);
        break;
    }

    void update() {
      _selectedPreset = preset;
      _startDate = _dateOnly(start);
      _endDate = _dateOnly(end);
      _selectedItem = null;
    }

    if (notify) {
      setState(update);
    } else {
      update();
    }
  }

  Future<void> _pickDate({required bool isStartDate}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;

    setState(() {
      _selectedPreset = 'Custom';
      if (isStartDate) {
        _startDate = _dateOnly(picked);
        if (_startDate.isAfter(_endDate)) _endDate = _startDate;
      } else {
        _endDate = _dateOnly(picked);
        if (_endDate.isBefore(_startDate)) _startDate = _endDate;
      }
      _selectedItem = null;
    });
  }

  bool _dateStringInRange(String value) {
    final date = _parseDate(value);
    if (date == null) return false;

    final day = _dateOnly(date);
    return !day.isBefore(_startDate) && !day.isAfter(_endDate);
  }

  DateTime? _parseDate(String value) => DateTime.tryParse(value.trim());

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  String _formatDateString(String value) {
    final date = _parseDate(value);
    if (date == null) return value;
    return _displayDateFormat.format(date);
  }

  String _customerName(int id) {
    return _customers
        .firstWhere(
          (customer) => customer.id == id,
          orElse: () => PeopleData(
            id: id,
            name: 'Unknown',
            type: 'CUSTOMER',
            startBalance: 0,
            creditLimit: 0,
            paymentTermsDays: 0,
            isDeleted: 0,
          ),
        )
        .name;
  }

  String _productName(int id) {
    return _products
        .firstWhere(
          (product) => product.id == id,
          orElse: () => Product(
            id: id,
            name: 'Unknown',
            price: 0,
            trackStock: false,
            currentStock: 0,
            avgCost: 0,
            reorderLevel: 0,
            bundle1Qty: 0,
            bundle1Price: 0,
            bundle2Qty: 0,
            bundle2Price: 0,
            bundle3Qty: 0,
            bundle3Price: 0,
            bundle4Qty: 0,
            bundle4Price: 0,
            bundle5Qty: 0,
            bundle5Price: 0,
            isDeleted: 0,
          ),
        )
        .name;
  }

  String _displayName(Map<String, dynamic> item) {
    if (item['customerName'] != null && item['invoiceNumber'] == null) {
      return item['customerName'] as String;
    }
    if (item['productName'] != null) return item['productName'] as String;
    if (item['invoiceNumber'] != null) {
      return 'Invoice #${item['invoiceNumber']}';
    }
    if (item['reference'] != null && (item['reference'] as String).isNotEmpty) {
      return item['reference'] as String;
    }
    return item['customerName'] as String? ?? 'Report row';
  }

  String _rowSubtitle(Map<String, dynamic> item) {
    if (item['cashSales'] != null && item['creditSales'] != null) {
      return 'Cash £${(item['cashSales'] as double).toStringAsFixed(2)} | '
          'Credit £${(item['creditSales'] as double).toStringAsFixed(2)} | '
          '${item['invoiceCount']} invoices';
    }
    if (item['cashRevenue'] != null && item['creditRevenue'] != null) {
      return 'Cash £${(item['cashRevenue'] as double).toStringAsFixed(2)} | '
          'Credit £${(item['creditRevenue'] as double).toStringAsFixed(2)} | '
          'Qty ${(item['totalQuantity'] as double).toStringAsFixed(2)}';
    }
    if (item['basis'] != null) return item['basis'] as String;
    if (item['invoiceCount'] != null) return '${item['invoiceCount']} invoices';
    if (item['receiptType'] != null) {
      return _receiptTypeLabel(item['receiptType'] as String);
    }
    return _selectedReport;
  }

  String _saleFilterLabel() {
    return switch (_saleSettlementFilter) {
      'Cash Sales' => 'Cash Sales',
      'Credit Sales' => 'Credit Sales',
      _ => 'All sale types',
    };
  }

  String _receiptTypeLabel(String type) {
    return switch (type.toUpperCase()) {
      'CASH_SALE' => 'Cash Sale Receipt',
      'CREDIT_RECEIPT' => 'Credit Receipt',
      'FINANCE_SETTLEMENT' => 'Ledger Settlement',
      _ => type,
    };
  }

  double _reportValue(Map<String, dynamic> item) {
    final value = item['totalSales'] ??
        item['totalRevenue'] ??
        item['total'] ??
        item['amount'] ??
        item['balance'] ??
        item['grossMargin'] ??
        0.0;
    return value is num ? value.toDouble() : 0.0;
  }

  String _formatValue(Object? value) {
    if (value is double) return value.toStringAsFixed(2);
    if (value is num) return value.toString();
    return value?.toString() ?? '';
  }

  String _titleCase(String value) {
    final spaced = value
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .replaceAll('_', ' ');
    return spaced
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  Future<void> _exportReport() async {
    try {
      final rows = await _getCurrentReportData();
      if (rows.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No report rows to export')),
          );
        }
        return;
      }

      final headers = <String>[];
      for (final row in rows) {
        for (final key in row.keys) {
          if (!headers.contains(key)) headers.add(key);
        }
      }

      final csvRows = [
        headers,
        ...rows
            .map((row) => headers.map((header) => row[header] ?? '').toList()),
      ];
      final csv = const ListToCsvConverter().convert(csvRows);
      final filename =
          'arcanus_ledger_${_safeFileName(_selectedReport)}_${_fileDateFormat.format(_startDate)}_${_fileDateFormat.format(_endDate)}.csv';

      await CsvPlatform.downloadFile(filename, csv);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported $filename')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $error')),
        );
      }
    }
  }

  String _safeFileName(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(
          RegExp(r'^_|_$'),
          '',
        );
  }
}
