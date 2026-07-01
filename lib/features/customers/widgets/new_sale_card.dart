import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../database/database.dart';
import '../../../widgets/sale_form_dialog.dart';
import 'workbench_card.dart';

/// Workbench panel for creating a new sale without leaving the board.
class NewSaleCard extends StatefulWidget {
  final Future<void> Function() onSaved;
  final int? selectedCustomerId;
  final bool queueLiteSync;

  const NewSaleCard({
    super.key,
    required this.onSaved,
    this.selectedCustomerId,
    this.queueLiteSync = false,
  });

  @override
  State<NewSaleCard> createState() => _NewSaleCardState();
}

class _NewSaleCardState extends State<NewSaleCard> {
  final AppDatabase _db = AppDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumberController = TextEditingController();
  final _dateController = TextEditingController();
  final _dueDateController = TextEditingController();

  List<PeopleData> _customers = [];
  List<Product> _products = [];
  final List<SaleLineItem> _lineItems = [];
  int? _selectedCustomerId;
  double _customerOutstandingBalance = 0.0;
  bool _paidInCash = false;
  bool _dueDateManuallyChanged = false;
  bool _isLoading = true;
  bool _isLoadingCustomerBalance = false;
  bool _isSaving = false;

  double get _totalAmount =>
      _lineItems.fold(0.0, (sum, item) => sum + item.total);

  PeopleData? get _selectedCustomer {
    final id = _selectedCustomerId;
    if (id == null) return null;
    for (final c in _customers) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _isoDate(DateTime.now());
    _loadData();
  }

  @override
  void didUpdateWidget(covariant NewSaleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isLoading &&
        widget.selectedCustomerId != oldWidget.selectedCustomerId) {
      _selectCustomer(widget.selectedCustomerId);
    }
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _dateController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final people = await _db.getAllPeople();
      final products = await _db.getAllProducts();
      final sales = await _db.getAllSales();
      if (!mounted) return;
      setState(() {
        _customers = people
            .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
            .cast<PeopleData>()
            .toList()
          ..sort(_byName);
        _products =
            products.where((p) => p.isDeleted == 0).cast<Product>().toList();
        _invoiceNumberController.text = (sales.length + 1).toString();
        _isLoading = false;
      });
      _selectCustomer(widget.selectedCustomerId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('Failed to load sale data: $e', isError: true);
    }
  }

  bool _hasCustomer(int? customerId) =>
      customerId != null && _customers.any((c) => c.id == customerId);

  void _selectCustomer(int? customerId) {
    final normalizedCustomerId = _hasCustomer(customerId) ? customerId : null;
    if (_selectedCustomerId == normalizedCustomerId) return;

    setState(() {
      _selectedCustomerId = normalizedCustomerId;
      _customerOutstandingBalance = 0.0;
      _isLoadingCustomerBalance = normalizedCustomerId != null;
      _dueDateManuallyChanged = false;
      if (normalizedCustomerId == null) {
        _dueDateController.clear();
      }
    });

    if (normalizedCustomerId != null) {
      _syncDueDate(force: true);
      _loadCustomerBalance(normalizedCustomerId);
    }
  }

  Future<void> _refreshInvoiceNumber() async {
    final sales = await _db.getAllSales();
    if (mounted) {
      setState(
          () => _invoiceNumberController.text = (sales.length + 1).toString());
    }
  }

  Future<void> _loadCustomerBalance(int customerId) async {
    setState(() {
      _customerOutstandingBalance = 0.0;
      _isLoadingCustomerBalance = true;
    });
    try {
      final items = await _db.getOutstandingItemsForCustomer(customerId);
      final balance =
          items.fold(0.0, (sum, item) => sum + item.outstandingAmount);
      if (!mounted || _selectedCustomerId != customerId) return;
      setState(() {
        _customerOutstandingBalance = balance;
        _isLoadingCustomerBalance = false;
      });
    } catch (e) {
      if (!mounted || _selectedCustomerId != customerId) return;
      setState(() => _isLoadingCustomerBalance = false);
      _showMessage('Failed to load customer balance: $e', isError: true);
    }
  }

  DateTime? _parseIsoDate(String value) => DateTime.tryParse(value.trim());
  DateTime _invoiceDateOrToday() =>
      _parseIsoDate(_dateController.text) ?? DateTime.now();
  String _isoDate(DateTime date) => date.toIso8601String().split('T')[0];

  void _syncDueDate({bool force = false}) {
    final customer = _selectedCustomer;
    if (customer == null) return;
    if (_dueDateManuallyChanged && !force) return;
    final dueDate =
        _invoiceDateOrToday().add(Duration(days: customer.paymentTermsDays));
    _dueDateController.text = _isoDate(dueDate);
  }

  Future<void> _pickInvoiceDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _invoiceDateOrToday(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null) return;
    setState(() {
      _dateController.text = _isoDate(selected);
      _syncDueDate();
    });
  }

  Future<void> _pickDueDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _parseIsoDate(_dueDateController.text) ??
          _invoiceDateOrToday()
              .add(Duration(days: _selectedCustomer?.paymentTermsDays ?? 0)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null) return;
    setState(() {
      _dueDateManuallyChanged = true;
      _dueDateController.text = _isoDate(selected);
    });
  }

  void _addLineItem() {
    showDialog(
      context: context,
      builder: (context) => SaleLineItemDialog(
        products: _products,
        onAdd: (item) => setState(() => _lineItems.add(item)),
      ),
    );
  }

  void _editLineItem(int index) {
    showDialog(
      context: context,
      builder: (context) => SaleLineItemDialog(
        products: _products,
        existingItem: _lineItems[index],
        onAdd: (item) => setState(() => _lineItems[index] = item),
      ),
    );
  }

  Future<void> _saveSale() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null) {
      _showMessage('Please select a customer');
      return;
    }
    if (_lineItems.isEmpty) {
      _showMessage('Please add at least one item');
      return;
    }

    final customer = _customers.firstWhere((c) => c.id == _selectedCustomerId);
    setState(() => _isSaving = true);
    try {
      final wasPaidInCash = _paidInCash;
      final itemPayload = _lineItems
          .map((item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'quantity': item.quantity,
                'pricePerUnit': item.pricePerUnit,
                'total': item.total,
              })
          .toList();
      final saleId = await _db.createSaleWithItems(
        SalesCompanion(
          personId: Value(customer.id),
          invoiceNumber: Value(_invoiceNumberController.text.trim()),
          date: Value(_dateController.text.trim()),
          dueDate: Value(_dueDateController.text.trim()),
          saleType: Value(_paidInCash ? 'CASH' : 'CREDIT'),
          total: Value(_totalAmount),
          status: Value(_paidInCash ? 'PAID' : 'NORMAL'),
          notes: const Value<String?>(null),
        ),
        _lineItems
            .map((item) => {
                  'product': item.product,
                  'quantity': item.quantity,
                  'pricePerUnit': item.pricePerUnit,
                  'total': item.total,
                })
            .toList(),
        receipt: _paidInCash
            ? PaymentsCompanion(
                personId: Value(customer.id),
                date: Value(_dateController.text.trim()),
                amount: Value(_totalAmount),
                receiptType: const Value('CASH_SALE'),
                paymentMethod: const Value('CASH_SALE'),
                reference: Value(
                    'Payment for INV-${_invoiceNumberController.text.trim()}'),
                isDeleted: const Value(0),
              )
            : null,
      );

      if (widget.queueLiteSync) {
        await _db.recordLiteSyncEvent(
          entityType: 'SALE',
          entityId: saleId,
          operation: 'CREATE',
          payloadJson: jsonEncode({
            'saleId': saleId,
            'personId': customer.id,
            'invoiceNumber': _invoiceNumberController.text.trim(),
            'date': _dateController.text.trim(),
            'dueDate': _dueDateController.text.trim(),
            'saleType': wasPaidInCash ? 'CASH' : 'CREDIT',
            'total': _totalAmount,
            'status': wasPaidInCash ? 'PAID' : 'NORMAL',
            'items': itemPayload,
            if (wasPaidInCash)
              'receipt': {
                'date': _dateController.text.trim(),
                'amount': _totalAmount,
                'receiptType': 'CASH_SALE',
                'paymentMethod': 'CASH_SALE',
                'reference':
                    'Payment for INV-${_invoiceNumberController.text.trim()}',
              },
          }),
        );
      }

      await widget.onSaved();
      if (!mounted) return;
      setState(() {
        _lineItems.clear();
        _customerOutstandingBalance = 0.0;
        _isLoadingCustomerBalance = false;
        _dateController.text = _isoDate(DateTime.now());
        _dueDateController.clear();
        _dueDateManuallyChanged = false;
        _paidInCash = false;
      });
      _syncDueDate(force: true);
      final selectedCustomerId = _selectedCustomerId;
      if (selectedCustomerId != null) {
        _loadCustomerBalance(selectedCustomerId);
      }
      await _refreshInvoiceNumber();
      _showMessage(
          wasPaidInCash ? 'Sale created and marked as paid' : 'Sale created');
    } catch (e) {
      if (mounted) {
        _showMessage(e.toString().replaceFirst('Exception: ', ''),
            isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : null,
    ));
  }

  static int _byName(PeopleData a, PeopleData b) =>
      a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase());

  @override
  Widget build(BuildContext context) {
    return WorkbenchCard(
      icon: Icons.receipt_long,
      title: 'New Sale',
      subtitle: 'Create an invoice without leaving the board',
      accentColor: Colors.green.shade800,
      bodyColor: const Color(0xFFF8FCF8),
      borderColor: Colors.green.shade200,
      child: _isLoading
          ? const SizedBox(
              height: 160, child: Center(child: CircularProgressIndicator()))
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(children: [
                    Expanded(
                      child: TextFormField(
                        controller: _invoiceNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Invoice No. *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Date *',
                          border: const OutlineInputBorder(),
                          isDense: true,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _pickInvoiceDate,
                            tooltip: 'Pick invoice date',
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (_parseIsoDate(v) == null) return 'Use YYYY-MM-DD';
                          return null;
                        },
                        onChanged: (_) => _syncDueDate(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<int>(
                    key: ValueKey(_selectedCustomerId),
                    initialValue: _selectedCustomerId,
                    decoration: const InputDecoration(
                      labelText: 'Customer *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: _customers
                        .map((c) => DropdownMenuItem<int>(
                            value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: _selectCustomer,
                    validator: (v) =>
                        v == null ? 'Please select a customer' : null,
                  ),
                  const SizedBox(height: 6),
                  if (_selectedCustomerId != null) ...[
                    TextFormField(
                      controller: _dueDateController,
                      decoration: InputDecoration(
                        labelText: 'Payment Due *',
                        border: const OutlineInputBorder(),
                        isDense: true,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: _pickDueDate,
                          tooltip: 'Pick due date',
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (_parseIsoDate(v) == null) return 'Use YYYY-MM-DD';
                        return null;
                      },
                      onChanged: (_) => _dueDateManuallyChanged = true,
                    ),
                    const SizedBox(height: 6),
                    _buildBalanceWarning(),
                    const SizedBox(height: 6),
                  ],
                  _buildCashToggle(),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Expanded(
                      child: Text('Items',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w800)),
                    ),
                    OutlinedButton.icon(
                      onPressed: _products.isEmpty ? null : _addLineItem,
                      icon: const Icon(Icons.add, size: 14),
                      label: const Text('Add Item',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  _buildLineItems(),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _saveSale,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check),
                    label: Text(_isSaving
                        ? 'Creating...'
                        : 'Create Sale  £${_totalAmount.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCashToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: _paidInCash ? Colors.green : Colors.grey.shade300),
      ),
      child: SwitchListTile(
        dense: true,
        title: const Text('Cash Sale',
            style: TextStyle(fontWeight: FontWeight.w700)),
        subtitle: const Text('Paid now — creates matching receipt'),
        value: _paidInCash,
        onChanged: (v) => setState(() => _paidInCash = v),
      ),
    );
  }

  Widget _buildBalanceWarning() {
    final customer = _selectedCustomer;
    if (customer == null) return const SizedBox.shrink();

    if (_isLoadingCustomerBalance) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Row(children: [
          SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2)),
          SizedBox(width: 8),
          Expanded(
              child: Text('Loading customer balance...',
                  style: TextStyle(fontWeight: FontWeight.w800))),
        ]),
      );
    }

    final projected = _paidInCash
        ? _customerOutstandingBalance
        : _customerOutstandingBalance + _totalAmount;
    final hasBalance = _customerOutstandingBalance > 0.01;
    final isOverLimit =
        customer.creditLimit > 0 && projected > customer.creditLimit;

    final bg = isOverLimit
        ? Colors.red[50]!
        : hasBalance
            ? Colors.orange[50]!
            : Colors.green[50]!;
    final border = isOverLimit
        ? Colors.red[200]!
        : hasBalance
            ? Colors.orange[200]!
            : Colors.green[200]!;
    final fg = isOverLimit
        ? Colors.red[800]!
        : hasBalance
            ? Colors.orange[800]!
            : Colors.green[800]!;
    final icon = isOverLimit
        ? Icons.error_outline
        : hasBalance
            ? Icons.warning_amber
            : Icons.check_circle_outline;
    final title = isOverLimit
        ? 'Balance warning'
        : hasBalance
            ? 'Customer balance'
            : 'No outstanding balance';
    final projectedText = _totalAmount > 0
        ? _paidInCash
            ? 'Cash sale will not add to balance'
            : 'After this sale: £${projected.toStringAsFixed(2)}'
        : null;
    final limitText = customer.creditLimit > 0
        ? 'Credit limit: £${customer.creditLimit.toStringAsFixed(2)}'
        : 'No credit limit set';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title: £${_customerOutstandingBalance.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  [if (projectedText != null) projectedText, limitText]
                      .join(' | '),
                  style: TextStyle(color: fg, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineItems() {
    if (_lineItems.isEmpty) {
      return Container(
        height: 74,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            Text('No items added', style: TextStyle(color: Colors.grey[600])),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ...List.generate(_lineItems.length, (index) {
            final item = _lineItems[index];
            return ListTile(
              dense: true,
              title: Text(item.product.name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                  '${item.quantity.toStringAsFixed(0)} x £${item.pricePerUnit.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('£${item.total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _editLineItem(index),
                    tooltip: 'Edit item',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                    onPressed: () => setState(() => _lineItems.removeAt(index)),
                    tooltip: 'Remove item',
                  ),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Row(
              children: [
                const Expanded(
                    child: Text('Total',
                        style: TextStyle(fontWeight: FontWeight.w800))),
                Text(
                  '£${_totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
