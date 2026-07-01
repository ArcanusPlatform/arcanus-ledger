import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../database/database.dart';
import '../features/customers/widgets/new_sale_card.dart';
import '../features/customers/widgets/receipt_card.dart';
import '../models/workspace_models.dart';
import '../utils/app_settings_store.dart';
import '../utils/storage_paths.dart';
import '../widgets/workspace/workspace_pane.dart';

class ArcanusLedgerLiteApp extends StatelessWidget {
  const ArcanusLedgerLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcanus Ledger Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      ),
      home: const LiteLoginScreen(),
    );
  }
}

class LiteLoginScreen extends StatefulWidget {
  const LiteLoginScreen({super.key});

  @override
  State<LiteLoginScreen> createState() => _LiteLoginScreenState();
}

class _LiteLoginScreenState extends State<LiteLoginScreen> {
  final _pinController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final storedPin = await AppSettingsStore.readPin();
    if (!mounted) return;

    if (_pinController.text == storedPin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LiteCustomerShell()),
      );
      return;
    }

    setState(() {
      _isLoading = false;
      _error = 'Incorrect PIN';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 112,
                      height: 112,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Arcanus Ledger Lite',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _pinController,
                    obscureText: true,
                    maxLength: 6,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: 'PIN',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.10),
                      errorText: _error,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _login,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.lock_open),
                      label: Text(_isLoading ? 'Opening...' : 'Open'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LiteCustomerShell extends StatefulWidget {
  const LiteCustomerShell({super.key});

  @override
  State<LiteCustomerShell> createState() => _LiteCustomerShellState();
}

class _LiteCustomerShellState extends State<LiteCustomerShell> {
  final AppDatabase _db = AppDatabase.instance;
  int _selectedIndex = 0;
  int _refreshSerial = 0;

  Future<void> _refreshAll() async {
    setState(() => _refreshSerial++);
  }

  Future<void> _openNewSaleSheet({int? customerId}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: NewSaleCard(
                selectedCustomerId: customerId,
                queueLiteSync: true,
                onSaved: () async {
                  await _refreshAll();
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openReceiptSheet({int? customerId}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: ReceiptCard(
                selectedCustomerId: customerId,
                queueLiteSync: true,
                onSaved: () async {
                  await _refreshAll();
                  if (sheetContext.mounted) {
                    Navigator.of(sheetContext).pop();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget? _buildFab() {
    if (_selectedIndex == 1) {
      return FloatingActionButton.extended(
        onPressed: () => _openNewSaleSheet(),
        icon: const Icon(Icons.receipt_long),
        label: const Text('Sale'),
      );
    }
    if (_selectedIndex == 2) {
      return FloatingActionButton.extended(
        onPressed: () => _openReceiptSheet(),
        icon: const Icon(Icons.payment),
        label: const Text('Receipt'),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      LiteCustomersTab(
        refreshSerial: _refreshSerial,
        onNewSale: (id) => _openNewSaleSheet(customerId: id),
        onReceipt: (id) => _openReceiptSheet(customerId: id),
      ),
      LiteSalesTab(
        db: _db,
        refreshSerial: _refreshSerial,
      ),
      LiteReceiptsTab(
        db: _db,
        refreshSerial: _refreshSerial,
      ),
      LiteSyncTab(
        db: _db,
        refreshSerial: _refreshSerial,
        onChanged: _refreshAll,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Arcanus Ledger Lite'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAll,
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      floatingActionButton: _buildFab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Customers',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            selectedIcon: Icon(Icons.point_of_sale),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.payment_outlined),
            selectedIcon: Icon(Icons.payment),
            label: 'Receipts',
          ),
          NavigationDestination(
            icon: Icon(Icons.sync_outlined),
            selectedIcon: Icon(Icons.sync),
            label: 'Sync',
          ),
        ],
      ),
    );
  }
}

class LiteCustomersTab extends StatefulWidget {
  const LiteCustomersTab({
    super.key,
    required this.refreshSerial,
    required this.onNewSale,
    required this.onReceipt,
  });

  final int refreshSerial;
  final ValueChanged<int> onNewSale;
  final ValueChanged<int> onReceipt;

  @override
  State<LiteCustomersTab> createState() => _LiteCustomersTabState();
}

class _LiteCustomersTabState extends State<LiteCustomersTab> {
  final AppDatabase _db = AppDatabase.instance;
  late final CustomerWorkspaceDataSource _dataSource;
  late Future<List<_LiteCustomerRow>> _future;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _dataSource = CustomerWorkspaceDataSource(_db);
    _future = _loadRows();
  }

  @override
  void didUpdateWidget(covariant LiteCustomersTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshSerial != oldWidget.refreshSerial) {
      _future = _loadRows();
    }
  }

  Future<List<_LiteCustomerRow>> _loadRows() async {
    final people = await _db.getAllPeople();
    final customers = {
      for (final person in people.cast<PeopleData>())
        if (person.type == 'CUSTOMER' && person.isDeleted == 0)
          person.id.toString(): person,
    };
    final items = await _dataSource.loadNavigatorItems();
    return [
      for (final item in items)
        if (customers[item.id] != null)
          _LiteCustomerRow(item: item, customer: customers[item.id]!)
    ];
  }

  Future<void> _refresh() async {
    setState(() => _future = _loadRows());
    await _future;
  }

  void _showCustomer(PeopleData customer) {
    final contentFuture =
        _dataSource.loadWorkspaceContent(customer.id.toString());

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.55,
          maxChildSize: 0.96,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        child: Text(_initials(customer.name)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            if ((customer.phone ?? '').isNotEmpty)
                              Text(customer.phone!),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close',
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(sheetContext).pop(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            widget.onNewSale(customer.id);
                          },
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Sale'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () {
                            Navigator.of(sheetContext).pop();
                            widget.onReceipt(customer.id);
                          },
                          icon: const Icon(Icons.payment),
                          label: const Text('Receipt'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: FutureBuilder<WorkspaceContent>(
                    future: contentFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      }
                      return WorkspacePane(content: snapshot.data);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<_LiteCustomerRow>>(
        future: _future,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <_LiteCustomerRow>[];
          final filtered = rows.where((row) {
            final q = _search.trim().toLowerCase();
            if (q.isEmpty) return true;
            return row.customer.name.toLowerCase().contains(q) ||
                (row.customer.phone?.toLowerCase().contains(q) ?? false) ||
                (row.customer.email?.toLowerCase().contains(q) ?? false);
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search customers',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filtered.isEmpty)
                const _LiteEmptyState(
                  icon: Icons.people_outline,
                  title: 'No customers',
                )
              else
                ...filtered.map((row) {
                  final item = row.item;
                  final customer = row.customer;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () => _showCustomer(customer),
                      leading: CircleAvatar(
                        backgroundColor: item.riskColor,
                        foregroundColor: Colors.white,
                        child: Text(_initials(customer.name)),
                      ),
                      title: Text(
                        customer.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(customer.phone ?? customer.email ?? ''),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _money(item.balance),
                            style: TextStyle(
                              color: item.balance > 0.01
                                  ? Colors.red.shade700
                                  : Colors.green.shade700,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            item.dueDate == null
                                ? '-'
                                : _date(item.dueDate!.toIso8601String()),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class LiteSalesTab extends StatefulWidget {
  const LiteSalesTab({
    super.key,
    required this.db,
    required this.refreshSerial,
  });

  final AppDatabase db;
  final int refreshSerial;

  @override
  State<LiteSalesTab> createState() => _LiteSalesTabState();
}

class _LiteSalesTabState extends State<LiteSalesTab> {
  late Future<List<_LiteSaleRow>> _future;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _future = _loadRows();
  }

  @override
  void didUpdateWidget(covariant LiteSalesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshSerial != oldWidget.refreshSerial) {
      _future = _loadRows();
    }
  }

  Future<List<_LiteSaleRow>> _loadRows() async {
    final sales = (await widget.db.getAllSales()).cast<Sale>().toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final rows = <_LiteSaleRow>[];
    for (final sale in sales) {
      final person =
          (await widget.db.getPersonById(sale.personId)) as PeopleData?;
      if (person?.type != 'CUSTOMER') continue;
      rows.add(
        _LiteSaleRow(sale: sale, customerName: person?.name ?? 'Unknown'),
      );
    }
    return rows;
  }

  Future<void> _refresh() async {
    setState(() => _future = _loadRows());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<_LiteSaleRow>>(
        future: _future,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <_LiteSaleRow>[];
          final filtered = rows.where((row) {
            final q = _search.trim().toLowerCase();
            if (q.isEmpty) return true;
            return row.customerName.toLowerCase().contains(q) ||
                row.sale.invoiceNumber.toLowerCase().contains(q);
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search sales',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filtered.isEmpty)
                const _LiteEmptyState(
                  icon: Icons.point_of_sale_outlined,
                  title: 'No sales',
                )
              else
                ...filtered.map((row) {
                  final sale = row.sale;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: sale.saleType == 'CASH'
                            ? Colors.green.shade700
                            : Colors.blueGrey.shade700,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.receipt_long),
                      ),
                      title: Text(
                        'INV-${sale.invoiceNumber}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle:
                          Text('${row.customerName}  ${_date(sale.date)}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _money(sale.total),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            sale.saleType,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class LiteReceiptsTab extends StatefulWidget {
  const LiteReceiptsTab({
    super.key,
    required this.db,
    required this.refreshSerial,
  });

  final AppDatabase db;
  final int refreshSerial;

  @override
  State<LiteReceiptsTab> createState() => _LiteReceiptsTabState();
}

class _LiteReceiptsTabState extends State<LiteReceiptsTab> {
  late Future<List<Map<String, dynamic>>> _future;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _future = _loadRows();
  }

  @override
  void didUpdateWidget(covariant LiteReceiptsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshSerial != oldWidget.refreshSerial) {
      _future = _loadRows();
    }
  }

  Future<List<Map<String, dynamic>>> _loadRows() async {
    return widget.db.getPaymentsWithCustomers();
  }

  Future<void> _refresh() async {
    setState(() => _future = _loadRows());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          final filtered = rows.where((row) {
            final q = _search.trim().toLowerCase();
            if (q.isEmpty) return true;
            return (row['customerName'] as String).toLowerCase().contains(q) ||
                (row['reference'] as String).toLowerCase().contains(q);
          }).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search receipts',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filtered.isEmpty)
                const _LiteEmptyState(
                  icon: Icons.payment_outlined,
                  title: 'No receipts',
                )
              else
                ...filtered.map((row) {
                  final amount = row['amount'] as double;
                  final type = row['receiptType'] as String;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: type == 'CASH_SALE'
                            ? Colors.green.shade700
                            : Colors.indigo.shade700,
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.payment),
                      ),
                      title: Text(
                        row['customerName'] as String,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(
                        '${_date(row['date'] as String)}  ${row['reference'] as String}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _money(amount),
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(
                            type == 'CASH_SALE' ? 'Cash' : 'Credit',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class LiteSyncTab extends StatefulWidget {
  const LiteSyncTab({
    super.key,
    required this.db,
    required this.refreshSerial,
    required this.onChanged,
  });

  final AppDatabase db;
  final int refreshSerial;
  final Future<void> Function() onChanged;

  @override
  State<LiteSyncTab> createState() => _LiteSyncTabState();
}

class _LiteSyncTabState extends State<LiteSyncTab> {
  late Future<_LiteSyncView> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  @override
  void didUpdateWidget(covariant LiteSyncTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refreshSerial != oldWidget.refreshSerial) {
      _future = _load();
    }
  }

  Future<_LiteSyncView> _load() async {
    final counts = await widget.db.getLiteSyncCounts();
    final events = await widget.db.getLiteSyncEvents();
    return _LiteSyncView(counts: counts, events: events);
  }

  Future<void> _checkpoint() async {
    await widget.db.flushAndCheckpoint();
    await widget.onChanged();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Database checkpoint complete')),
    );
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<_LiteSyncView>(
        future: _future,
        builder: (context, snapshot) {
          final data = snapshot.data ??
              const _LiteSyncView(
                counts: {'PENDING': 0, 'SYNCED': 0, 'FAILED': 0},
                events: [],
              );

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SyncMetric(
                      label: 'Pending',
                      value: data.counts['PENDING'] ?? 0,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SyncMetric(
                      label: 'Synced',
                      value: data.counts['SYNCED'] ?? 0,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _SyncMetric(
                      label: 'Failed',
                      value: data.counts['FAILED'] ?? 0,
                      color: Colors.red.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Local Database',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        StoragePaths.databaseFile('recordkeep_db.sqlite'),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _checkpoint,
                        icon: const Icon(Icons.save),
                        label: const Text('Checkpoint'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (data.events.isEmpty)
                const _LiteEmptyState(
                  icon: Icons.sync,
                  title: 'No queued changes',
                )
              else
                ...data.events.map((event) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _syncStatusColor(event.status),
                        foregroundColor: Colors.white,
                        child: Icon(_syncEntityIcon(event.entityType)),
                      ),
                      title: Text(
                        '${event.operation} ${event.entityType}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(_date(event.createdAt)),
                      trailing: Text(
                        event.status,
                        style: TextStyle(
                          color: _syncStatusColor(event.status),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _SyncMetric extends StatelessWidget {
  const _SyncMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _LiteEmptyState extends StatelessWidget {
  const _LiteEmptyState({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade500),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _LiteCustomerRow {
  const _LiteCustomerRow({
    required this.item,
    required this.customer,
  });

  final NavigatorItem item;
  final PeopleData customer;
}

class _LiteSaleRow {
  const _LiteSaleRow({
    required this.sale,
    required this.customerName,
  });

  final Sale sale;
  final String customerName;
}

class _LiteSyncView {
  const _LiteSyncView({
    required this.counts,
    required this.events,
  });

  final Map<String, int> counts;
  final List<LiteSyncEvent> events;
}

String _money(double value) => '£${value.toStringAsFixed(2)}';

String _date(String? value) {
  if (value == null || value.trim().isEmpty) return '-';
  final parsed = DateTime.tryParse(value);
  if (parsed == null) return value;
  return DateFormat('dd/MM/yyyy').format(parsed);
}

String _initials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

Color _syncStatusColor(String status) {
  switch (status) {
    case 'SYNCED':
      return Colors.green.shade700;
    case 'FAILED':
      return Colors.red.shade700;
    default:
      return Colors.orange.shade800;
  }
}

IconData _syncEntityIcon(String entityType) {
  switch (entityType) {
    case 'SALE':
      return Icons.receipt_long;
    case 'PAYMENT':
      return Icons.payment;
    default:
      return Icons.sync;
  }
}
