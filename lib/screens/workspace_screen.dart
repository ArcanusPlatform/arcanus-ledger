import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import '../models/workspace_models.dart';
import '../widgets/workspace/navigator_pane.dart';
import '../widgets/workspace/workspace_pane.dart';
import '../widgets/workspace/action_drawer_group.dart';
import '../widgets/workspace/action_drawer.dart';
import '../features/customers/widgets/new_sale_card.dart';
import '../features/customers/widgets/receipt_card.dart';
import '../utils/responsive_utils.dart';
import '../widgets/custom_app_bar.dart';
import '../services/csv_service.dart';
import '../services/csv_platform.dart';
import '../utils/csv_file_picker.dart';
import '../widgets/responsive_dialog.dart';

/// Main workspace screen with three-zone layout:
/// - Navigator Pane (left): Customer list
/// - Workspace Pane (right): Customer details in tabs
/// - Action Drawers (top of workspace): Quick transaction forms
class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  final AppDatabase _db = AppDatabase.instance;
  late final CustomerWorkspaceDataSource _dataSource;

  List<NavigatorItem> _navigatorItems = [];
  Map<String, PeopleData> _customerDataMap = {};
  String? _selectedItemId;
  WorkspaceContent? _workspaceContent;

  bool _isLoadingNavigator = true;
  bool _isLoadingWorkspace = false;
  String? _navigatorError;
  String? _workspaceError;

  // Keys for action drawers to control their state
  final GlobalKey<ActionDrawerState> _newSaleDrawerKey = GlobalKey();
  final GlobalKey<ActionDrawerState> _receiptDrawerKey = GlobalKey();

  int? get _selectedCustomerId =>
      _selectedItemId == null ? null : int.tryParse(_selectedItemId!);

  @override
  void initState() {
    super.initState();
    _dataSource = CustomerWorkspaceDataSource(
      _db,
      onFinancePaymentUpdated: _refreshWorkspaceData,
    );
    _loadNavigatorItems();
  }

  /// Load customer list for navigator pane
  Future<void> _loadNavigatorItems() async {
    setState(() {
      _isLoadingNavigator = true;
      _navigatorError = null;
    });

    try {
      final items = await _dataSource.loadNavigatorItems();

      // Also load customer data for inline editing
      final people = await _db.getAllPeople();
      final customers = people
          .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
          .cast<PeopleData>()
          .toList();

      final customerMap = <String, PeopleData>{};
      for (var customer in customers) {
        customerMap[customer.id.toString()] = customer;
      }

      if (!mounted) return;

      setState(() {
        _navigatorItems = items;
        _customerDataMap = customerMap;
        _isLoadingNavigator = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _navigatorError = e.toString();
        _isLoadingNavigator = false;
      });
    }
  }

  /// Handle customer selection - load workspace content
  Future<void> _handleSelection(String itemId) async {
    // Collapse any open action drawers when switching customers
    _newSaleDrawerKey.currentState?.collapse();
    _receiptDrawerKey.currentState?.collapse();

    setState(() {
      _selectedItemId = itemId;
      _workspaceContent = null;
      _isLoadingWorkspace = true;
      _workspaceError = null;
    });

    try {
      final content = await _dataSource.loadWorkspaceContent(itemId);
      if (!mounted) return;

      // Validate content matches selection
      if (content.itemId != itemId) {
        throw Exception(
            'Content mismatch: expected $itemId, got ${content.itemId}');
      }

      setState(() {
        _workspaceContent = content;
        _isLoadingWorkspace = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _workspaceError = e.toString();
        _isLoadingWorkspace = false;
      });
    }
  }

  /// Refresh workspace data after transactions
  Future<void> _refreshWorkspaceData({
    bool refreshNavigator = true,
    bool refreshWorkspace = true,
  }) async {
    if (refreshNavigator) {
      await _loadNavigatorItems();
    }

    if (refreshWorkspace && _selectedItemId != null) {
      // Check if selected customer still exists
      final exists = _navigatorItems.any((item) => item.id == _selectedItemId);

      if (exists) {
        await _handleSelection(_selectedItemId!);
      } else {
        // Customer was deleted, clear selection
        setState(() {
          _selectedItemId = null;
          _workspaceContent = null;
        });
      }
    }
  }

  Future<void> _handleNewSaleSaved() async {
    await _refreshWorkspaceData();
    _newSaleDrawerKey.currentState?.collapse();
  }

  Future<void> _handleReceiptSaved() async {
    await _refreshWorkspaceData();
    _receiptDrawerKey.currentState?.collapse();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isDesktop = MediaQuery.of(context).size.width >= 700;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Customer Workspace',
        subtitle: 'Manage customers and transactions',
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(isMobile),
    );
  }

  Widget _buildDesktopLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final navigatorWidth = constraints.maxWidth * 0.40; // 40% of screen

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Navigator Pane (40% width)
            SizedBox(
              width: navigatorWidth,
              child: NavigatorPane(
                items: _navigatorItems,
                selectedItemId: _selectedItemId,
                onItemSelected: _handleSelection,
                onItemDoubleClick: null, // TODO: Open full detail dialog
                isLoading: _isLoadingNavigator,
                errorMessage: _navigatorError,
                onRetry: _loadNavigatorItems,
                onAddCustomer: _showAddCustomerDialog,
                onImportCSV: _importCSV,
                onExportCSV: _exportCSV,
                onEditCustomer: _handleEditCustomer,
                onCreditLimitChanged: _handleCreditLimitChange,
                customerDataMap: _customerDataMap,
              ),
            ),

            // Workspace Pane (remaining space ~55%)
            Expanded(
              child: Column(
                children: [
                  // Action Drawers at top
                  ActionDrawerGroup(
                    allowMultipleExpanded: false,
                    drawers: [
                      ActionDrawer(
                        key: _newSaleDrawerKey,
                        title: 'New Sale',
                        icon: Icons.receipt_long,
                        accentColor: Colors.green.shade800,
                        content: NewSaleCard(
                          selectedCustomerId: _selectedCustomerId,
                          onSaved: _handleNewSaleSaved,
                        ),
                        onSaved: _handleNewSaleSaved,
                      ),
                      ActionDrawer(
                        key: _receiptDrawerKey,
                        title: 'Receipt',
                        icon: Icons.payment,
                        accentColor: Colors.blue.shade800,
                        content: ReceiptCard(
                          selectedCustomerId: _selectedCustomerId,
                          onSaved: _handleReceiptSaved,
                        ),
                        onSaved: _handleReceiptSaved,
                      ),
                    ],
                  ),

                  // Workspace content
                  Expanded(
                    child: WorkspacePane(
                      content: _workspaceContent,
                      onRefresh: () => _refreshWorkspaceData(
                        refreshNavigator: false,
                        refreshWorkspace: true,
                      ),
                      isLoading: _isLoadingWorkspace,
                      errorMessage: _workspaceError,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    // Mobile: single pane view with bottom sheets for details
    return Column(
      children: [
        Expanded(
          child: NavigatorPane(
            items: _navigatorItems,
            selectedItemId: _selectedItemId,
            onItemSelected: (itemId) {
              // On mobile, show bottom sheet instead of persistent pane
              _showMobileDetailSheet(itemId);
            },
            onItemDoubleClick: null,
            isLoading: _isLoadingNavigator,
            errorMessage: _navigatorError,
            onRetry: _loadNavigatorItems,
            onAddCustomer: _showAddCustomerDialog,
            onImportCSV: _importCSV,
            onExportCSV: _exportCSV,
            onEditCustomer: _handleEditCustomer,
            onCreditLimitChanged: _handleCreditLimitChange,
            customerDataMap: _customerDataMap,
          ),
        ),
      ],
    );
  }

  Future<void> _showMobileDetailSheet(String itemId) async {
    setState(() {
      _selectedItemId = itemId;
      _isLoadingWorkspace = true;
    });

    try {
      final content = await _dataSource.loadWorkspaceContent(itemId);

      if (!mounted) return;

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return WorkspacePane(
              content: content,
              onRefresh: () async {
                Navigator.pop(context);
                await _refreshWorkspaceData();
              },
            );
          },
        ),
      );

      if (mounted) {
        setState(() {
          _selectedItemId = null;
          _isLoadingWorkspace = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingWorkspace = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading customer: $e')),
      );
    }
  }

  /// Handle edit customer request
  Future<void> _handleEditCustomer(String customerId) async {
    final customer = _customerDataMap[customerId];
    if (customer == null) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _CustomerFormDialog(customer: customer),
    );
    if (result == true) {
      await _refreshWorkspaceData();
    }
  }

  /// Handle credit limit change
  Future<void> _handleCreditLimitChange(
      String customerId, double creditLimit) async {
    try {
      final customer = _customerDataMap[customerId];
      if (customer == null) return;

      final companion = PeopleCompanion(
        id: Value(customer.id),
        creditLimit: Value(creditLimit),
      );

      await _db.updatePerson(companion);
      await _refreshWorkspaceData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credit limit updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating credit limit: $e')),
        );
      }
    }
  }

  /// Show add customer dialog
  Future<void> _showAddCustomerDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _CustomerFormDialog(customer: null),
    );
    if (result == true) {
      await _refreshWorkspaceData();
    }
  }

  /// Import customers from CSV
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
        await _refreshWorkspaceData();
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

  /// Export customers to CSV
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
            content: Text('Exported ${_navigatorItems.length} customers')));
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
