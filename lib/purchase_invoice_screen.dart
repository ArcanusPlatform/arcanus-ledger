import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';

enum _LineType { product, expense }

class _LineItem {
  _LineType type;
  Product? product;
  String? expenseCategoryName;
  String description;
  double quantity;
  double unitCost;

  _LineItem({
    required this.type,
    this.product,
    this.expenseCategoryName,
    required this.description,
    this.quantity = 1.0,
    this.unitCost = 0.0,
  });

  double get total => quantity * unitCost;
}

class PurchaseInvoiceScreen extends StatefulWidget {
  final PeopleData? initialSupplier;
  const PurchaseInvoiceScreen({super.key, this.initialSupplier});

  @override
  State<PurchaseInvoiceScreen> createState() => _PurchaseInvoiceScreenState();
}

class _PurchaseInvoiceScreenState extends State<PurchaseInvoiceScreen> {
  final _db = AppDatabase.instance;
  final _fmt = DateFormat('yyyy-MM-dd');
  final _invNumCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _paymentRefCtrl = TextEditingController();

  List<PeopleData> _suppliers = [];
  PeopleData? _selectedSupplier;
  DateTime _invoiceDate = DateTime.now();
  DateTime _paymentDate = DateTime.now();
  DateTime? _dueDate;
  bool _paidNow = false;
  String _paymentMethod = 'Bank Transfer';
  final List<_LineItem> _lines = [];
  bool _saving = false;

  static const _paymentMethods = [
    'Bank Transfer',
    'Card',
    'Cash',
    'Direct Debit',
    'Cheque',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedSupplier = widget.initialSupplier;
    _loadSuppliers();
  }

  @override
  void dispose() {
    _invNumCtrl.dispose();
    _notesCtrl.dispose();
    _paymentRefCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    final people = await _db.getAllPeople();
    final list = people
        .where((p) => p.type == 'SUPPLIER' && p.isDeleted == 0)
        .cast<PeopleData>()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _suppliers = list;
      _selectedSupplier ??= list.isNotEmpty ? list.first : null;
      _dueDate ??= _selectedSupplier == null
          ? null
          : _invoiceDate.add(
              Duration(days: _selectedSupplier!.paymentTermsDays),
            );
    });
  }

  Future<void> _pickDate(bool isDue) async {
    final initial = isDue
        ? (_dueDate ?? _invoiceDate.add(const Duration(days: 30)))
        : _invoiceDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isDue) {
        _dueDate = picked;
      } else {
        _invoiceDate = picked;
      }
    });
  }

  Future<void> _addProductLine() async {
    final products = (await _db.getAllProducts()).cast<Product>();
    if (!mounted) return;
    Product? sel;
    final qtyCtrl = TextEditingController(text: '1');
    final costCtrl = TextEditingController(text: '0.00');

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
          builder: (ctx, ss) => AlertDialog(
                title: const Text('Add Product Line'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  DropdownButtonFormField<Product>(
                    decoration: const InputDecoration(
                        labelText: 'Product', border: OutlineInputBorder()),
                    items: products
                        .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p.name)))
                        .toList(),
                    onChanged: (p) {
                      sel = p;
                      if (p != null) {
                        costCtrl.text = p.avgCost.toStringAsFixed(2);
                      }
                      ss(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                      controller: qtyCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Quantity', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  TextField(
                      controller: costCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Unit Cost',
                          prefixText: '£',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number),
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {
                        if (sel == null) return;
                        final qty = double.tryParse(qtyCtrl.text) ?? 0;
                        final cost = double.tryParse(costCtrl.text) ?? 0;
                        if (qty <= 0 || cost <= 0) return;
                        setState(() => _lines.add(_LineItem(
                            type: _LineType.product,
                            product: sel,
                            description: sel!.name,
                            quantity: qty,
                            unitCost: cost)));
                        Navigator.pop(ctx);
                      },
                      child: const Text('Add')),
                ],
              )),
    );
  }

  Future<void> _addExpenseLine() async {
    await _db.ensureDefaultExpenseCategories();
    final cats = (await _db.getAllExpenseCategories())
        .cast<ExpenseCategory>()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    if (!mounted) return;
    ExpenseCategory? sel = cats.isNotEmpty ? cats.first : null;
    final descCtrl = TextEditingController();
    final amtCtrl = TextEditingController(text: '0.00');

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
          builder: (ctx, ss) => AlertDialog(
                title: const Text('Add Expense Line'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  DropdownButtonFormField<ExpenseCategory>(
                    initialValue: sel,
                    decoration: const InputDecoration(
                        labelText: 'Category', border: OutlineInputBorder()),
                    items: cats
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c.name)))
                        .toList(),
                    onChanged: (c) => ss(() => sel = c),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(
                      controller: amtCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Amount',
                          prefixText: '£',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number),
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () {
                        if (sel == null) return;
                        final amt = double.tryParse(amtCtrl.text) ?? 0;
                        if (amt <= 0) return;
                        setState(() => _lines.add(_LineItem(
                            type: _LineType.expense,
                            expenseCategoryName: sel!.name,
                            description: descCtrl.text.trim().isEmpty
                                ? sel!.name
                                : descCtrl.text.trim(),
                            quantity: 1,
                            unitCost: amt)));
                        Navigator.pop(ctx);
                      },
                      child: const Text('Add')),
                ],
              )),
    );
  }

  Future<void> _post() async {
    if (_selectedSupplier == null) {
      _snack('Select a supplier');
      return;
    }
    if (_invNumCtrl.text.trim().isEmpty) {
      _snack('Enter an invoice number');
      return;
    }
    if (_lines.isEmpty) {
      _snack('Add at least one line item');
      return;
    }

    setState(() => _saving = true);
    try {
      final total = _lines.fold(0.0, (s, l) => s + l.total);
      final items = _lines
          .map((l) => {
                'description': l.description,
                'category': l.type == _LineType.expense
                    ? l.expenseCategoryName
                    : 'PRODUCT',
                'productId': l.product?.id,
                'quantity': l.quantity,
                'unitCost': l.unitCost,
                'total': l.total,
              })
          .toList();

      final invoiceId = await _db.createSupplierInvoiceWithItems(
        SupplierInvoicesCompanion(
          supplierId: Value(_selectedSupplier!.id),
          invoiceNumber: Value(_invNumCtrl.text.trim()),
          date: Value(_fmt.format(_invoiceDate)),
          dueDate: Value(_dueDate != null ? _fmt.format(_dueDate!) : null),
          total: Value(total),
          status: const Value('UNPAID'),
          notes: Value(
              _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim()),
        ),
        items,
      );

      if (_paidNow) {
        await _db.recordSupplierPayment(
          supplierId: _selectedSupplier!.id,
          date: _fmt.format(_paymentDate),
          amount: total,
          paymentMethod: _paymentMethod,
          reference: _paymentRefCtrl.text.trim().isEmpty
              ? 'Payment for supplier invoice ${_invNumCtrl.text.trim()}'
              : _paymentRefCtrl.text.trim(),
          allocations: [
            {'invoiceId': invoiceId, 'amount': total},
          ],
        );
      }

      if (!mounted) return;
      _snack('Invoice posted');
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _snack('Error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _pickPaymentDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _paymentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() => _paymentDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final total = _lines.fold(0.0, (s, l) => s + l.total);

    return Scaffold(
      appBar: AppBar(title: const Text('New Purchase Invoice')),
      body: _suppliers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(children: [
                      Expanded(
                        child: DropdownButtonFormField<PeopleData>(
                          initialValue: _selectedSupplier,
                          decoration: const InputDecoration(
                              labelText: 'Supplier',
                              border: OutlineInputBorder()),
                          items: _suppliers
                              .map((s) => DropdownMenuItem(
                                  value: s, child: Text(s.name)))
                              .toList(),
                          onChanged: (s) => setState(() {
                            _selectedSupplier = s;
                            if (s != null) {
                              _dueDate = _invoiceDate.add(
                                Duration(days: s.paymentTermsDays),
                              );
                            }
                          }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _invNumCtrl,
                          decoration: const InputDecoration(
                              labelText: 'Invoice Number',
                              border: OutlineInputBorder()),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(
                          child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text('Date: ${_fmt.format(_invoiceDate)}'),
                        onPressed: () => _pickDate(false),
                      )),
                      const SizedBox(width: 12),
                      Expanded(
                          child: OutlinedButton.icon(
                        icon: const Icon(Icons.event, size: 16),
                        label: Text(_dueDate != null
                            ? 'Due: ${_fmt.format(_dueDate!)}'
                            : 'Set Due Date'),
                        onPressed: () => _pickDate(true),
                      )),
                    ]),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Notes (optional)',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mark invoice as paid'),
                      subtitle: const Text(
                          'Creates a supplier payment and records when it was paid'),
                      value: _paidNow,
                      onChanged: (value) => setState(() => _paidNow = value),
                    ),
                    if (_paidNow) ...[
                      const SizedBox(height: 8),
                      Row(children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _paymentMethod,
                            decoration: const InputDecoration(
                              labelText: 'Payment Method',
                              border: OutlineInputBorder(),
                            ),
                            items: _paymentMethods
                                .map((method) => DropdownMenuItem(
                                      value: method,
                                      child: Text(method),
                                    ))
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
                            label: Text('Paid: ${_fmt.format(_paymentDate)}'),
                            onPressed: _pickPaymentDate,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _paymentRefCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Payment Reference (optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(children: [
                      const Text('Line Items',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton.icon(
                          onPressed: _addProductLine,
                          icon: const Icon(Icons.inventory_2, size: 16),
                          label: const Text('Product')),
                      TextButton.icon(
                          onPressed: _addExpenseLine,
                          icon: const Icon(Icons.receipt_long, size: 16),
                          label: const Text('Expense')),
                    ]),
                    Expanded(
                      child: _lines.isEmpty
                          ? Center(
                              child: Text('No lines added yet',
                                  style: TextStyle(color: Colors.grey[500])))
                          : ListView.builder(
                              itemCount: _lines.length,
                              itemBuilder: (_, i) {
                                final l = _lines[i];
                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                      l.type == _LineType.product
                                          ? Icons.inventory_2
                                          : Icons.receipt_long,
                                      size: 20),
                                  title: Text(l.description),
                                  subtitle: Text(l.type == _LineType.product
                                      ? '${l.quantity} × £${l.unitCost.toStringAsFixed(2)}'
                                      : l.expenseCategoryName ?? ''),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('£${l.total.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                                color: Colors.red),
                                            onPressed: () => setState(
                                                () => _lines.removeAt(i))),
                                      ]),
                                );
                              },
                            ),
                    ),
                    const Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('£${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _saving ? null : _post,
                        icon: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.check),
                        label: Text(_saving ? 'Posting...' : 'Post Invoice'),
                      ),
                    ),
                  ]),
            ),
    );
  }
}
