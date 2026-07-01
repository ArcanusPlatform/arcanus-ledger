import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../database/database.dart';

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _accountCodeController = TextEditingController(text: '2100');
  final _expenseCategoryController = TextEditingController();
  final _creditLimitController = TextEditingController(text: '0');
  final _paymentTermsController = TextEditingController(text: '30');
  final _openingBalanceController = TextEditingController(text: '0');
  final _termsController = TextEditingController();

  List<Supplier> _suppliers = [];
  Supplier? _selectedSupplier;
  List<Map<String, dynamic>> _transactions = []; // Adapted for Arcanus Ledger
  double _selectedSupplierBalance = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _accountCodeController.dispose();
    _expenseCategoryController.dispose();
    _creditLimitController.dispose();
    _paymentTermsController.dispose();
    _openingBalanceController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    setState(() => _isLoading = true);
    final suppliers = await AppDatabase.instance.getActiveSuppliers();
    setState(() {
      _suppliers = suppliers;
      // Handle empty list case gracefully
      if (suppliers.isNotEmpty) {
        _selectedSupplier = suppliers.first;
      } else {
        _selectedSupplier = null;
      }
    });
    await _loadTransactions();
    setState(() => _isLoading = false);
  }

  Future<void> _loadTransactions() async {
    if (_selectedSupplier == null) {
      setState(() => _transactions = []);
      return;
    }
    // Using getSupplierAccountSummary for Arcanus Ledger's model
    final summary = await AppDatabase.instance.getSupplierAccountSummary(_selectedSupplier!.id);
    setState(() {
      _transactions = summary['ledger'];
      _selectedSupplierBalance = summary['balance'];
    });
  }

  Future<void> _showAddSupplierDialog() async {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();
    _notesController.clear();
    _expenseCategoryController.clear();
    _accountCodeController.text = '2100';
    _creditLimitController.text = '0';
    _paymentTermsController.text = '30';
    _openingBalanceController.text = '0';
    _termsController.clear();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
                TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
                TextField(controller: _expenseCategoryController, decoration: const InputDecoration(labelText: 'P&L Expense Category', hintText: 'e.g. Utilities, Rent')),
                TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address')),
                TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes')),
                TextField(controller: _accountCodeController, decoration: const InputDecoration(labelText: 'Account code')),
                TextField(
                  controller: _creditLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Credit limit'),
                ),
                TextField(
                  controller: _paymentTermsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Payment terms (days)'),
                ),
                TextField(controller: _termsController, decoration: const InputDecoration(labelText: 'Terms')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            FilledButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                if (name.isEmpty) return;
                Navigator.of(context).pop();
                await AppDatabase.instance.addSupplier(SuppliersCompanion(
                  name: Value(name),
                  email: Value(_emailController.text.isEmpty ? null : _emailController.text),
                  phone: Value(_phoneController.text.isEmpty ? null : _phoneController.text),
                  address: Value(_addressController.text.isEmpty ? null : _addressController.text),
                  expenseCategory: Value(_expenseCategoryController.text.isEmpty ? null : _expenseCategoryController.text),
                  notes: Value(_notesController.text.isEmpty ? null : _notesController.text),
                  accountCode: Value(_accountCodeController.text),
                  creditLimit: Value(double.tryParse(_creditLimitController.text) ?? 0.0),
                  openingBalance: Value(double.tryParse(_openingBalanceController.text) ?? 0.0),
                  terms: Value(_termsController.text.isEmpty ? null : _termsController.text),
                  createdAt: Value(DateTime.now().toIso8601String()),
                ));
                if (!mounted) return;
                await _loadSuppliers();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(onPressed: _showAddSupplierDialog, icon: const Icon(Icons.add)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Card(
                      child: ListView.separated(
                        itemCount: _suppliers.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final supplier = _suppliers[index];
                          return ListTile(
                            selected: _selectedSupplier?.id == supplier.id,
                            title: Text(supplier.name),
                            subtitle: Text(supplier.expenseCategory ?? 'No category'),
                            onTap: () {
                              setState(() => _selectedSupplier = supplier);
                              _loadTransactions();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 5,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: _selectedSupplier == null
                            ? const Center(child: Text('Select a supplier'))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_selectedSupplier!.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  _infoRow('P&L Category', _selectedSupplier!.expenseCategory ?? 'Not set', isHighlight: true),
                                  _infoRow('Email', _selectedSupplier!.email ?? 'N/A'),
                                  _infoRow('Account', _selectedSupplier!.accountCode),
                                  _infoRow('Opening Balance', '£${_selectedSupplier!.openingBalance.toStringAsFixed(2)}'),
                                  _infoRow('Credit Limit', '£${_selectedSupplier!.creditLimit.toStringAsFixed(2)}'),
                                  _infoRow('Payment Terms', '${_selectedSupplier!.paymentTermsDays} days'),
                                  _infoRow('Balance', '£${_selectedSupplierBalance.toStringAsFixed(2)}'),
                                  const Divider(height: 32),
                                  const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Expanded(
                                    child: _transactions.isEmpty
                                        ? const Center(child: Text('No transactions'))
                                        : ListView.builder(
                                            itemCount: _transactions.length,
                                            itemBuilder: (context, index) {
                                              final tx = _transactions[index];
                                              return ListTile(
                                                title: Text(tx['reference'] ?? 'Transaction'),
                                                trailing: Text('£${(tx['credit'] ?? tx['debit']).toStringAsFixed(2)}'),
                                                subtitle: Text(tx['date']),
                                              );
                                            },
                                          ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text('$label:', style: TextStyle(color: Colors.grey[600]))),
          Text(value, style: TextStyle(fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal, color: isHighlight ? const Color(0xFF1F7A5B) : null)),
        ],
      ),
    );
  }
}
