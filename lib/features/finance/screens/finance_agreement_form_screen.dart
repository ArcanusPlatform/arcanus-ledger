import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../../../database/database.dart';
import '../../../utils/responsive_utils.dart';
import '../../../widgets/custom_app_bar.dart';
import '../models/finance_models.dart';
import '../services/finance_service.dart';
import '../widgets/finance_amount_section.dart';
import '../widgets/finance_customer_section.dart';
import '../widgets/finance_notes_section.dart';
import '../widgets/finance_sales_allocation_section.dart';
import '../widgets/finance_save_bar.dart';
import '../widgets/finance_schedule_section.dart';
import '../widgets/finance_source_section.dart';

class FinanceAgreementFormScreen extends StatefulWidget {
  final FinanceAgreement? existing;

  /// Pre-select a customer when launched from the workspace.
  final int? preselectedPersonId;

  const FinanceAgreementFormScreen({
    super.key,
    this.existing,
    this.preselectedPersonId,
  });

  @override
  State<FinanceAgreementFormScreen> createState() =>
      _FinanceAgreementFormScreenState();
}

class _FinanceAgreementFormScreenState
    extends State<FinanceAgreementFormScreen> {
  final _db = AppDatabase.instance;
  final _formKey = GlobalKey<FormState>();

  FinanceSource _source = FinanceSource.standalone;
  List<PeopleData> _customers = [];
  int? _linkedPersonId;
  List<SelectableSale> _selectableSales = [];
  Set<int> _existingLinkedSaleIds = {};
  Map<int, double> _existingSettlementAmounts = {};

  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _additionalCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _countCtrl = TextEditingController();
  final _purposeCtrl = TextEditingController();
  final _assetCtrl = TextEditingController();

  String _frequency = 'Monthly';
  String _agreementDate = FinanceService.todayIso();
  String _firstPaymentDate = FinanceService.todayIso();

  GeneratedSchedule? _schedule;
  bool _isLoading = true;
  bool _loadingSales = false;
  bool _isSaving = false;

  bool get _isEditing => widget.existing != null;

  bool get _usesSales =>
      _source == FinanceSource.allocated || _source == FinanceSource.hybrid;

  bool get _requiresCustomer => _usesSales;

  double get _selectedSalesTotal => _selectableSales
      .where((sale) => sale.selected)
      .fold(0.0, (sum, sale) => sum + sale.outstanding);

  double get _effectiveLoanAmount {
    switch (_source) {
      case FinanceSource.standalone:
        return _parseAmount(_amountCtrl.text);
      case FinanceSource.allocated:
        return _selectedSalesTotal;
      case FinanceSource.hybrid:
        return _selectedSalesTotal + _parseAmount(_additionalCtrl.text);
    }
  }

  @override
  void initState() {
    super.initState();
    _hydrateFromExisting();
    _amountCtrl.addListener(_invalidateSchedule);
    _additionalCtrl.addListener(_invalidateSchedule);
    _rateCtrl.addListener(_invalidateSchedule);
    _countCtrl.addListener(_invalidateSchedule);
    _loadInitialData();
  }

  @override
  void dispose() {
    _amountCtrl.removeListener(_invalidateSchedule);
    _additionalCtrl.removeListener(_invalidateSchedule);
    _rateCtrl.removeListener(_invalidateSchedule);
    _countCtrl.removeListener(_invalidateSchedule);
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _amountCtrl.dispose();
    _additionalCtrl.dispose();
    _rateCtrl.dispose();
    _countCtrl.dispose();
    _purposeCtrl.dispose();
    _assetCtrl.dispose();
    super.dispose();
  }

  void _hydrateFromExisting() {
    final existing = widget.existing;
    if (existing == null) {
      _rateCtrl.text = '0';
      _countCtrl.text = '12';
      return;
    }

    _source = FinanceSource.fromString(existing.financeSource);
    _linkedPersonId = existing.linkedPersonId;
    _nameCtrl.text = existing.customerName;
    _addressCtrl.text = existing.customerAddress ?? '';
    _amountCtrl.text = _formatInputAmount(existing.loanAmount);
    _additionalCtrl.text = existing.additionalAmount == null
        ? ''
        : _formatInputAmount(existing.additionalAmount!);
    _rateCtrl.text = _formatInputAmount(existing.interestRate);
    _countCtrl.text = existing.paymentCount.toString();
    _purposeCtrl.text = existing.purposeNote ?? '';
    _assetCtrl.text = existing.assetNote ?? '';
    _frequency = existing.paymentFrequency;
    _agreementDate = existing.agreementDate;
    _firstPaymentDate = existing.firstPaymentDate;
    _schedule = FinanceService.generateSchedule(
      loanAmount: existing.loanAmount,
      annualRatePercent: existing.interestRate,
      paymentCount: existing.paymentCount,
      frequency: existing.paymentFrequency,
      firstPaymentDate: existing.firstPaymentDate,
    );
  }

  Future<void> _loadInitialData() async {
    try {
      final people = await _db.getAllPeople();
      final customers = people
          .cast<PeopleData>()
          .where((person) => person.type.toUpperCase() == 'CUSTOMER')
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      final existing = widget.existing;
      final linkedIds = existing == null
          ? <int>[]
          : await _db.getFinanceSaleLinks(existing.id);
      final settlementAmounts = existing == null
          ? <int, double>{}
          : await _db.getFinanceSettlementSaleAmounts(existing.id);

      if (!mounted) return;
      setState(() {
        _customers = customers;
        _existingLinkedSaleIds = linkedIds.toSet();
        _existingSettlementAmounts = settlementAmounts;
        _linkedPersonId ??= widget.preselectedPersonId;
        if (existing == null && _linkedPersonId != null) {
          _copyCustomerDetails(_linkedPersonId);
        }
        _isLoading = false;
      });

      if (_usesSales && _linkedPersonId != null) {
        await _loadSelectableSales();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('Failed to load finance form: $e', isError: true);
    }
  }

  Future<void> _loadSelectableSales() async {
    final personId = _linkedPersonId;
    if (personId == null) {
      setState(() => _selectableSales = []);
      return;
    }

    final selectedIds = _selectableSales
        .where((sale) => sale.selected)
        .map((sale) => sale.saleId)
        .toSet();

    setState(() => _loadingSales = true);
    try {
      final outstanding = await _db.getOutstandingInvoices(personId);
      final financedIds = await _db.getFinancedSaleIdsForCustomer(personId);
      final blockedIds = financedIds.difference(_existingLinkedSaleIds);
      final linkedIds = {...selectedIds, ..._existingLinkedSaleIds};

      final sales = <SelectableSale>[];
      for (final row in outstanding) {
        final saleId = row['id'] as int;
        if (blockedIds.contains(saleId)) continue;
        sales.add(
          SelectableSale(
            saleId: saleId,
            invoiceNumber: 'INV-${row['invoiceNumber']}',
            date: row['date'] as String,
            outstanding: (row['remaining'] as num).toDouble(),
            selected: linkedIds.contains(saleId),
          ),
        );
      }

      await _addMissingLinkedSales(sales, linkedIds);

      if (!mounted) return;
      setState(() {
        _selectableSales = sales;
        _loadingSales = false;
      });
      _invalidateSchedule();
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingSales = false);
      _showMessage('Failed to load outstanding sales: $e', isError: true);
    }
  }

  Future<void> _addMissingLinkedSales(
    List<SelectableSale> sales,
    Set<int> linkedIds,
  ) async {
    final loadedIds = sales.map((sale) => sale.saleId).toSet();
    final missingIds = linkedIds.difference(loadedIds);
    if (missingIds.isEmpty) return;

    for (final saleId in missingIds) {
      final sale = await _db.getSaleById(saleId) as Sale?;
      if (sale == null) continue;
      sales.add(
        SelectableSale(
          saleId: sale.id,
          invoiceNumber: 'INV-${sale.invoiceNumber}',
          date: sale.date,
          outstanding: _existingSettlementAmounts[sale.id] ?? sale.total,
          selected: true,
        ),
      );
    }
    sales.sort((a, b) => a.date.compareTo(b.date));
  }

  void _copyCustomerDetails(int? personId) {
    if (personId == null) return;
    final matches = _customers.where((customer) => customer.id == personId);
    if (matches.isEmpty) return;
    final customer = matches.first;
    _nameCtrl.text = customer.name;
    _addressCtrl.text = customer.address ?? '';
  }

  void _changeSource(FinanceSource source) {
    if (_source == source) return;
    setState(() {
      _source = source;
      _schedule = null;
      if (!_usesSales) {
        _selectableSales = [];
      }
    });
    if (_usesSales && _linkedPersonId != null) {
      _loadSelectableSales();
    }
  }

  void _changeCustomer(int? personId) {
    setState(() {
      _linkedPersonId = personId;
      _selectableSales = [];
      _existingLinkedSaleIds = {};
      _existingSettlementAmounts = {};
      _schedule = null;
      if (personId != null) {
        _copyCustomerDetails(personId);
      }
    });
    if (_usesSales && personId != null) {
      _loadSelectableSales();
    }
  }

  void _toggleSale(SelectableSale sale) {
    setState(() {
      sale.selected = !sale.selected;
      _schedule = null;
    });
  }

  Future<void> _pickAgreementDate() async {
    final picked = await _pickDate(_agreementDate);
    if (picked == null) return;
    setState(() {
      _agreementDate = picked;
      _schedule = null;
    });
  }

  Future<void> _pickFirstPaymentDate() async {
    final picked = await _pickDate(_firstPaymentDate);
    if (picked == null) return;
    setState(() {
      _firstPaymentDate = picked;
      _schedule = null;
    });
  }

  Future<String?> _pickDate(String currentIso) async {
    final initial = DateTime.tryParse(currentIso) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    return picked == null ? null : _toIsoDate(picked);
  }

  void _invalidateSchedule() {
    if (!mounted) return;
    setState(() => _schedule = null);
  }

  bool _validateSalesSelection() {
    if (!_usesSales) return true;
    if (_linkedPersonId == null) {
      _showMessage('Select a customer before saving', isError: true);
      return false;
    }
    if (!_selectableSales.any((sale) => sale.selected)) {
      _showMessage('Select at least one outstanding sale', isError: true);
      return false;
    }
    return true;
  }

  GeneratedSchedule? _generateSchedule({bool showErrors = true}) {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return null;
    if (!_validateSalesSelection()) return null;

    final amount = _effectiveLoanAmount;
    final rate = double.tryParse(_rateCtrl.text.trim());
    final count = int.tryParse(_countCtrl.text.trim());

    if (amount <= 0) {
      if (showErrors) {
        _showMessage('Agreement amount must be greater than zero',
            isError: true);
      }
      return null;
    }
    if (rate == null) {
      if (showErrors) {
        _showMessage('Interest rate must be numeric', isError: true);
      }
      return null;
    }
    if (count == null || count <= 0) {
      if (showErrors) {
        _showMessage('Payment count must be positive', isError: true);
      }
      return null;
    }

    final schedule = FinanceService.generateSchedule(
      loanAmount: amount,
      annualRatePercent: rate,
      paymentCount: count,
      frequency: _frequency,
      firstPaymentDate: _firstPaymentDate,
    );

    setState(() => _schedule = schedule);
    return schedule;
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final schedule = _schedule ?? _generateSchedule();
    if (schedule == null) return;

    setState(() => _isSaving = true);
    try {
      final amount = _effectiveLoanAmount;
      final interestRate = double.parse(_rateCtrl.text.trim());
      final paymentCount = int.parse(_countCtrl.text.trim());
      final existing = widget.existing;

      final agreement = FinanceAgreementsCompanion(
        id: existing == null ? const Value.absent() : Value(existing.id),
        customerName: Value(_nameCtrl.text.trim()),
        customerAddress: Value<String?>(_emptyToNull(_addressCtrl.text)),
        agreementDate: Value(_agreementDate),
        loanAmount: Value(amount),
        interestRate: Value(interestRate),
        paymentFrequency: Value(_frequency),
        paymentCount: Value(paymentCount),
        firstPaymentDate: Value(_firstPaymentDate),
        paymentAmount: Value(schedule.totals.paymentAmount),
        totalInterest: Value(schedule.totals.totalInterest),
        totalRepayable: Value(schedule.totals.totalRepayable),
        status: Value(existing?.status ?? 'ACTIVE'),
        financeSource: Value(_source.name),
        linkedPersonId: Value<int?>(_linkedPersonId),
        sourceSalesAmount:
            Value<double?>(_usesSales ? _selectedSalesTotal : null),
        additionalAmount: Value<double?>(_source == FinanceSource.hybrid
            ? _parseAmount(_additionalCtrl.text)
            : null),
        purposeNote: Value<String?>(_emptyToNull(_purposeCtrl.text)),
        assetNote: Value<String?>(_emptyToNull(_assetCtrl.text)),
        createdAt:
            Value(existing?.createdAt ?? DateTime.now().toIso8601String()),
      );

      final paymentRows = schedule.rows
          .map(
            (row) => FinancePaymentsCompanion(
              agreementId: const Value.absent(),
              paymentNo: Value(row.paymentNo),
              dueDate: Value(row.dueDate),
              openingBalance: Value(row.openingBalance),
              paymentAmount: Value(row.paymentAmount),
              interestAmount: Value(row.interestAmount),
              capitalAmount: Value(row.capitalAmount),
              closingBalance: Value(row.closingBalance),
              paid: const Value(0),
              paidDate: const Value(null),
              rowType: const Value('SCHEDULED'),
            ),
          )
          .toList();

      final linkedSaleIds = _usesSales
          ? _selectableSales
              .where((sale) => sale.selected)
              .map((sale) => sale.saleId)
              .toList()
          : <int>[];

      if (existing == null) {
        await _db.saveFinanceAgreementFull(
          agreement,
          paymentRows,
          linkedSaleIds,
        );
      } else {
        await _db.updateFinanceAgreementFull(
          agreement,
          paymentRows,
          linkedSaleIds,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      _showMessage('Failed to save agreement: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'Edit Agreement' : 'New Agreement';

    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        subtitle: 'Ledger agreement',
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(AppSpacing.getScreenPadding(context)),
                children: [
                  FinanceSourceSection(
                    value: _source,
                    onChanged: _changeSource,
                  ),
                  SizedBox(height: AppSpacing.getCardSpacing(context)),
                  FinanceCustomerSection(
                    customers: _customers,
                    selectedPersonId: _linkedPersonId,
                    customerRequired: _requiresCustomer,
                    isLoading: _isLoading,
                    onPersonChanged: _changeCustomer,
                    nameController: _nameCtrl,
                    addressController: _addressCtrl,
                  ),
                  SizedBox(height: AppSpacing.getCardSpacing(context)),
                  FinanceSalesAllocationSection(
                    source: _source,
                    selectedPersonId: _linkedPersonId,
                    sales: _selectableSales,
                    isLoading: _loadingSales,
                    selectedTotal: _selectedSalesTotal,
                    onToggleSale: _toggleSale,
                    onRefresh: _loadSelectableSales,
                  ),
                  if (_usesSales)
                    SizedBox(height: AppSpacing.getCardSpacing(context)),
                  FinanceAmountSection(
                    source: _source,
                    amountController: _amountCtrl,
                    additionalController: _additionalCtrl,
                    rateController: _rateCtrl,
                    paymentCountController: _countCtrl,
                    frequency: _frequency,
                    agreementDate: _agreementDate,
                    firstPaymentDate: _firstPaymentDate,
                    selectedSalesTotal: _selectedSalesTotal,
                    effectiveLoanAmount: _effectiveLoanAmount,
                    onFrequencyChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _frequency = value;
                        _schedule = null;
                      });
                    },
                    onAgreementDateTap: _pickAgreementDate,
                    onFirstPaymentDateTap: _pickFirstPaymentDate,
                    onGenerateSchedule: () => _generateSchedule(),
                  ),
                  SizedBox(height: AppSpacing.getCardSpacing(context)),
                  FinanceNotesSection(
                    purposeController: _purposeCtrl,
                    assetController: _assetCtrl,
                  ),
                  SizedBox(height: AppSpacing.getCardSpacing(context)),
                  FinanceScheduleSection(schedule: _schedule),
                  const SizedBox(height: 88),
                ],
              ),
            ),
      bottomNavigationBar: _isLoading
          ? null
          : FinanceSaveBar(
              isSaving: _isSaving,
              isEditing: _isEditing,
              loanAmount: _effectiveLoanAmount,
              schedule: _schedule,
              onSave: _save,
            ),
    );
  }

  void _showMessage(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  static double _parseAmount(String value) =>
      double.tryParse(value.replaceAll(',', '').trim()) ?? 0;

  static String _formatInputAmount(double value) {
    final fixed = value.toStringAsFixed(2);
    return fixed.endsWith('.00') ? fixed.substring(0, fixed.length - 3) : fixed;
  }

  static String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _toIsoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
