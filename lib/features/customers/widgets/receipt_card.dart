import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:intl/intl.dart';
import '../../../database/database.dart';
import '../../../models/payment_allocation_model.dart';
import 'workbench_card.dart';

/// Workbench panel for recording a customer payment and allocating it.
class ReceiptCard extends StatefulWidget {
  final Future<void> Function() onSaved;
  final int? selectedCustomerId;
  final bool queueLiteSync;

  const ReceiptCard({
    super.key,
    required this.onSaved,
    this.selectedCustomerId,
    this.queueLiteSync = false,
  });

  @override
  State<ReceiptCard> createState() => _ReceiptCardState();
}

class _ReceiptCardState extends State<ReceiptCard> {
  final AppDatabase _db = AppDatabase.instance;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');
  final Map<String, TextEditingController> _allocationControllers = {};

  List<PeopleData> _customers = [];
  List<OutstandingItem> _outstandingItems = [];
  Map<String, double> _allocations = {};
  int? _selectedCustomerId;
  DateTime _selectedDate = DateTime.now();
  double _outstandingBalance = 0.0;
  bool _isLoading = true;
  bool _isLoadingOutstanding = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void didUpdateWidget(covariant ReceiptCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isLoading &&
        widget.selectedCustomerId != oldWidget.selectedCustomerId) {
      _selectCustomer(widget.selectedCustomerId);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    for (final c in _allocationControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() => _isLoading = true);
    try {
      final people = await _db.getAllPeople();
      if (!mounted) return;
      setState(() {
        _customers = people
            .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
            .cast<PeopleData>()
            .toList()
          ..sort(_byName);
        _isLoading = false;
      });
      _selectCustomer(widget.selectedCustomerId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load receipt data: $e')));
    }
  }

  bool _hasCustomer(int? customerId) =>
      customerId != null && _customers.any((c) => c.id == customerId);

  void _selectCustomer(int? customerId) {
    final normalizedCustomerId = _hasCustomer(customerId) ? customerId : null;
    if (_selectedCustomerId == normalizedCustomerId) return;

    setState(() {
      _selectedCustomerId = normalizedCustomerId;
      _outstandingItems = [];
      _outstandingBalance = 0;
      _allocations = {};
      _isLoadingOutstanding = normalizedCustomerId != null;
    });
    _syncAllocationControllers();

    if (normalizedCustomerId != null) {
      _loadOutstandingItems(normalizedCustomerId);
    }
  }

  Future<void> _loadOutstandingItems([int? customerId]) async {
    final effectiveCustomerId = customerId ?? _selectedCustomerId;
    if (effectiveCustomerId == null) return;
    setState(() => _isLoadingOutstanding = true);
    try {
      final items =
          await _db.getOutstandingItemsForCustomer(effectiveCustomerId);
      if (!mounted || _selectedCustomerId != effectiveCustomerId) return;
      setState(() {
        _outstandingItems = items;
        _outstandingBalance =
            items.fold(0.0, (sum, item) => sum + item.outstandingAmount);
        _isLoadingOutstanding = false;
      });
      _calculateAutoAllocation();
    } catch (e) {
      if (!mounted || _selectedCustomerId != effectiveCustomerId) return;
      setState(() => _isLoadingOutstanding = false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load outstanding items: $e')));
    }
  }

  void _calculateAutoAllocation() {
    final paymentAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (paymentAmount <= 0 || _outstandingItems.isEmpty) {
      _setAllocations({});
      return;
    }
    final newAllocations = <String, double>{};
    double remaining = paymentAmount;
    for (final item in _outstandingItems) {
      if (remaining <= 0) break;
      final amount = remaining >= item.outstandingAmount
          ? item.outstandingAmount
          : remaining;
      newAllocations[item.id] = amount;
      remaining -= amount;
    }
    _setAllocations(newAllocations);
  }

  void _setAllocations(Map<String, double> allocations) {
    setState(() => _allocations = allocations);
    _syncAllocationControllers();
  }

  void _syncAllocationControllers() {
    final itemIds = _outstandingItems.map((item) => item.id).toSet();
    for (final id in _allocationControllers.keys.toList()) {
      if (!itemIds.contains(id)) _allocationControllers.remove(id)?.dispose();
    }
    for (final item in _outstandingItems) {
      final controller = _allocationControllers.putIfAbsent(
          item.id, () => TextEditingController());
      final amount = _allocations[item.id] ?? 0.0;
      controller.text = amount > 0 ? amount.toStringAsFixed(2) : '';
    }
  }

  bool _validateAllocations() {
    final paymentAmount = double.tryParse(_amountController.text) ?? 0.0;
    final totalAllocated = _allocations.values.fold(0.0, (sum, a) => sum + a);
    if (totalAllocated > paymentAmount) return false;
    for (final item in _outstandingItems) {
      final allocation = _allocations[item.id] ?? 0.0;
      if (allocation < 0 || allocation > item.outstandingAmount) return false;
    }
    return true;
  }

  bool get _canSave {
    if (_selectedCustomerId == null || _isSaving) return false;
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return false;
    if (!_validateAllocations()) return false;
    // Prevent saving if more is allocated than received (under-payment error)
    final totalAllocated = _allocations.values.fold(0.0, (sum, a) => sum + a);
    if (totalAllocated > amount + 0.001) return false;
    return true;
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate() || !_canSave) return;
    setState(() => _isSaving = true);
    try {
      final paymentAmount = double.parse(_amountController.text);
      final totalAllocated = _allocations.values.fold(0.0, (sum, a) => sum + a);
      final unallocated = paymentAmount - totalAllocated;

      final allocationRecords = [
        for (final item in _outstandingItems)
          if ((_allocations[item.id] ?? 0) > 0)
            AllocationRecord(
              itemId: item.id,
              saleId: item.saleId,
              amount: _allocations[item.id]!,
            ),
        // Store any unallocated credit as saleId=0 (credit on account)
        if (unallocated > 0.001)
          AllocationRecord(
            itemId: 'credit',
            saleId: 0,
            amount: unallocated,
          ),
      ];

      final paymentId = await _db.savePaymentWithAllocations(
        PaymentsCompanion(
          personId: Value(_selectedCustomerId!),
          date: Value(_selectedDate.toIso8601String()),
          amount: Value(paymentAmount),
          receiptType: const Value('CREDIT_RECEIPT'),
          paymentMethod: const Value('CREDIT_RECEIPT'),
          reference: Value(_referenceController.text.trim()),
          isDeleted: const Value(0),
        ),
        allocationRecords,
      );

      if (widget.queueLiteSync) {
        await _db.recordLiteSyncEvent(
          entityType: 'PAYMENT',
          entityId: paymentId,
          operation: 'CREATE',
          payloadJson: jsonEncode({
            'paymentId': paymentId,
            'personId': _selectedCustomerId!,
            'date': _selectedDate.toIso8601String(),
            'amount': paymentAmount,
            'receiptType': 'CREDIT_RECEIPT',
            'paymentMethod': 'CREDIT_RECEIPT',
            'reference': _referenceController.text.trim(),
            'allocations': allocationRecords
                .map((record) => {
                      'itemId': record.itemId,
                      'saleId': record.saleId,
                      'amount': record.amount,
                    })
                .toList(),
          }),
        );
      }

      await widget.onSaved();
      if (!mounted) return;
      _amountController.clear();
      _referenceController.clear();
      await _loadOutstandingItems();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Receipt saved')));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save payment: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null) setState(() => _selectedDate = selected);
  }

  static int _byName(PeopleData a, PeopleData b) =>
      a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase());

  @override
  Widget build(BuildContext context) {
    return WorkbenchCard(
      icon: Icons.payment,
      title: 'Receipt',
      subtitle: 'Record receipt and allocate it to outstanding balances',
      accentColor: Colors.blue.shade800,
      bodyColor: const Color(0xFFF7FAFE),
      borderColor: Colors.blue.shade200,
      child: _isLoading
          ? const SizedBox(
              height: 120, child: Center(child: CircularProgressIndicator()))
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<int>(
                    key: ValueKey(_selectedCustomerId),
                    initialValue: _selectedCustomerId,
                    decoration: const InputDecoration(
                      labelText: 'Customer *',
                      border: OutlineInputBorder(),
                      isDense: true,
                      prefixIcon: Icon(Icons.person),
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
                  if (_selectedCustomerId != null) _buildOutstandingSummary(),
                  if (_selectedCustomerId != null) const SizedBox(height: 6),
                  Row(children: [
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                            isDense: true,
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(_dateFormat.format(_selectedDate)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Amount *',
                          border: OutlineInputBorder(),
                          isDense: true,
                          prefixText: '£',
                        ),
                        validator: (v) {
                          final amount = double.tryParse(v ?? '');
                          if (amount == null || amount <= 0) {
                            return 'Enter amount';
                          }
                          return null;
                        },
                        onChanged: (_) => _calculateAutoAllocation(),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _referenceController,
                    decoration: const InputDecoration(
                      labelText: 'Reference',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  if (_selectedCustomerId != null &&
                      _outstandingItems.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _buildAllocationEditor(),
                  ],
                  if (_isLoadingOutstanding) ...[
                    const SizedBox(height: 8),
                    const Center(child: CircularProgressIndicator()),
                  ],
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    onPressed: _canSave ? _savePayment : null,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check),
                    label: Text(_isSaving ? 'Saving...' : 'Save Receipt'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOutstandingSummary() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _outstandingBalance > 0 ? Colors.orange[50] : Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _outstandingBalance > 0
              ? Colors.orange[200]!
              : Colors.green[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _outstandingBalance > 0
                ? Icons.warning_amber
                : Icons.check_circle_outline,
            color: _outstandingBalance > 0
                ? Colors.orange[800]
                : Colors.green[800],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Outstanding: £${_outstandingBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationEditor() {
    final totalAllocated = _allocations.values.fold(0.0, (sum, a) => sum + a);
    final paymentAmount = double.tryParse(_amountController.text) ?? 0.0;
    final remaining = paymentAmount - totalAllocated;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Allocate Receipt',
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                ),
                Text(
                  'Remaining: £${remaining.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: remaining < 0 ? Colors.red : Colors.blueGrey[800],
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ..._outstandingItems.map((item) {
            final controller = _allocationControllers[item.id]!;
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.reference,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12)),
                        Text(
                          'O/S £${item.outstandingAmount.toStringAsFixed(2)}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 116,
                    child: TextFormField(
                      controller: controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        prefixText: '£',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        setState(() {
                          _allocations = {..._allocations, item.id: amount};
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
