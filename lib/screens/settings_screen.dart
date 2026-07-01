import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'dart:convert';
import '../database/database.dart';
import '../utils/app_settings_store.dart';
import '../utils/backup_restore.dart';
import '../utils/database_path_service.dart';
import '../utils/local_database_picker.dart';
import '../utils/portable_vault_locator.dart';
import '../utils/portable_vault_service.dart';
import '../utils/storage_paths.dart';
import 'login_screen.dart';
import 'safe_removal_screen.dart';
import '../widgets/custom_app_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _db = AppDatabase.instance;
  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _registrationController = TextEditingController();

  String _businessType = 'Individual';
  String _databasePath = 'No database selected';
  bool _isLoading = true;
  bool _isChangingDatabaseLocation = false;
  bool _isPreparingRemoval = false;

  @override
  void initState() {
    super.initState();
    _loadBusinessDetails();
  }

  Future<void> _loadBusinessDetails() async {
    final settings = await AppSettingsStore.readAll();
    final name = settings['business_name'] ?? '';
    final address = settings['business_address'] ?? '';
    final phone = settings['business_phone'] ?? '';
    final email = settings['business_email'] ?? '';
    final registration = settings['business_registration'] ?? '';
    final type = settings['business_type'] ?? 'Individual';
    final databasePath = _currentDatabasePath();

    setState(() {
      _businessNameController.text = name;
      _addressController.text = address;
      _phoneController.text = phone;
      _emailController.text = email;
      _registrationController.text = registration;
      _businessType = type;
      _databasePath = databasePath;
      _isLoading = false;
    });
  }

  Future<void> _saveBusinessDetails() async {
    await AppSettingsStore.writeAll({
      'business_name': _businessNameController.text,
      'business_address': _addressController.text,
      'business_phone': _phoneController.text,
      'business_email': _emailController.text,
      'business_registration': _registrationController.text,
      'business_type': _businessType,
    });

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Business details saved!')));
    }
  }

  Future<void> _chooseDatabaseFolder() async {
    final folderPath = await LocalDatabasePicker.chooseFolder();
    if (folderPath == null) return;

    await _saveDatabaseLocation(
      () => DatabasePathService.saveDataFolder(folderPath),
    );
  }

  Future<void> _chooseDatabaseFile() async {
    final databasePath = await LocalDatabasePicker.chooseDatabase();
    if (databasePath == null) return;

    await _saveDatabaseLocation(
      () => DatabasePathService.saveDatabaseFile(databasePath),
    );
  }

  Future<void> _resetDatabaseLocation() async {
    setState(() => _isChangingDatabaseLocation = true);

    try {
      await DatabasePathService.clear();

      if (!mounted) return;

      setState(() {
        _databasePath = _currentDatabasePath();
        _isChangingDatabaseLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Database location reset. Restart the app to use managed storage.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() => _isChangingDatabaseLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database location reset failed: $error')),
      );
    }
  }

  Future<void> _saveDatabaseLocation(
    Future<String> Function() saveLocation,
  ) async {
    setState(() => _isChangingDatabaseLocation = true);

    try {
      final databasePath = await saveLocation();

      if (!mounted) return;

      setState(() {
        _databasePath = databasePath;
        _isChangingDatabaseLocation = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Database location saved. Restart the app to open this database.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() => _isChangingDatabaseLocation = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database location save failed: $error')),
      );
    }
  }

  String _currentDatabasePath() {
    try {
      return StoragePaths.databaseFile(PortableVaultLocator.databaseFileName);
    } catch (_) {
      return 'No database selected';
    }
  }

  Future<void> _changePIN() async {
    final currentPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Current PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'New PIN',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Confirm New PIN',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              final savedPin = await AppSettingsStore.readPin();

              if (currentPinController.text != savedPin) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Current PIN is incorrect')),
                );
                return;
              }

              if (newPinController.text.length != 6) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('PIN must be 6 digits')),
                );
                return;
              }

              if (newPinController.text != confirmPinController.text) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('PINs do not match')),
                );
                return;
              }

              await AppSettingsStore.writePin(newPinController.text);

              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('PIN changed successfully!')),
              );
            },
            child: const Text('Change PIN'),
          ),
        ],
      ),
    );
  }

  Future<void> _backupData() async {
    try {
      // Get all data
      final people = await _db.getAllPeople();
      final products = await _db.getAllProducts();
      final sales = await _db.getAllSales();
      final saleItemsList = await _db.getAllSaleItems();
      final payments = await _db.getAllPayments();
      final allocationsList = await _db.getAllAllocations();
      final expenses = await _db.getAllExpenses();
      final categories = await _db.getAllExpenseCategories();
      final productPurchasesList = await _db.getAllProductPurchases();
      final stockAllocationsList = await _db.getAllStockAllocations();

      // Get business details
      final businessDetails = {
        'name': _businessNameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'registration': _registrationController.text,
        'type': _businessType,
      };

      // Create backup object
      final backup = {
        'version': '2.0',
        'timestamp': DateTime.now().toIso8601String(),
        'business': businessDetails,
        'people': people.map((p) => p.toJson()).toList(),
        'products': products.map((p) => p.toJson()).toList(),
        'sales': sales.map((s) => s.toJson()).toList(),
        'saleItems': saleItemsList.map((i) => i.toJson()).toList(),
        'payments': payments.map((p) => p.toJson()).toList(),
        'allocations': allocationsList.map((a) => a.toJson()).toList(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
        'expenseCategories': categories.map((c) => c.toJson()).toList(),
        'productPurchases':
            productPurchasesList.map((p) => p.toJson()).toList(),
        'stockAllocations':
            stockAllocationsList.map((s) => s.toJson()).toList(),
      };

      await backupData(backup);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Backup successful!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Backup failed: $e')));
      }
    }
  }

  Future<void> _restoreData() async {
    // Confirm before wiping existing data
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore from Backup'),
        content: const Text(
          'This will replace ALL current data with the most recent backup. '
          'This cannot be undone.\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final jsonString = await restoreData();
      if (jsonString == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No backup found. Create a backup first.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      final backup = jsonDecode(jsonString) as Map<String, dynamic>;

      // Version check
      final version = backup['version'];
      if (version != '2.0') {
        throw Exception('Unsupported backup version: $version. Expected 2.0.');
      }

      // Restore business details
      final business = backup['business'] as Map<String, dynamic>? ?? {};
      await AppSettingsStore.writeAll({
        'business_name': business['name'] as String? ?? '',
        'business_address': business['address'] as String? ?? '',
        'business_phone': business['phone'] as String? ?? '',
        'business_email': business['email'] as String? ?? '',
        'business_registration': business['registration'] as String? ?? '',
        'business_type': business['type'] as String? ?? 'Individual',
      });

      // Transactional DB restore — wipe everything then re-insert in
      // dependency order: categories → people → products → sales →
      // payments → expenses
      await _db.deleteAllData();

      // 1. Expense categories
      for (final j in (backup['expenseCategories'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addExpenseCategory(
          ExpenseCategoriesCompanion(
            name: Value(m['name'] as String? ?? ''),
            color: Value(m['color'] as String? ?? 'grey'),
            icon: Value(m['icon'] as String? ?? 'receipt'),
            isDefault: Value((m['is_default'] as num?)?.toInt() ?? 0),
            isDeleted: Value((m['is_deleted'] as num?)?.toInt() ?? 0),
          ),
        );
      }

      // 2. People
      for (final j in (backup['people'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addPerson(
          PeopleCompanion(
            name: Value(m['name'] as String? ?? ''),
            phone: Value(m['phone'] as String?),
            email: Value(m['email'] as String?),
            address: Value(m['address'] as String?),
            notes: Value(m['notes'] as String?),
            type: Value(m['type'] as String? ?? 'CUSTOMER'),
            startBalance: Value(
              (m['start_balance'] as num?)?.toDouble() ?? 0.0,
            ),
            startDate: Value(m['start_date'] as String?),
            creditLimit: Value((m['credit_limit'] as num?)?.toDouble() ?? 0.0),
            paymentTermsDays: Value(
              (m['payment_terms_days'] as num?)?.toInt() ?? 0,
            ),
            dueDate: Value(m['due_date'] as String?),
            isDeleted: Value((m['is_deleted'] as num?)?.toInt() ?? 0),
          ),
        );
      }

      // 3. Products
      for (final j in (backup['products'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addProduct(
          ProductsCompanion(
            name: Value(m['name'] as String? ?? ''),
            description: Value(m['description'] as String?),
            price: Value((m['price'] as num?)?.toDouble() ?? 0.0),
            category: Value(m['category'] as String?),
            trackStock: Value((m['track_stock'] as bool?) ?? false),
            currentStock: Value(
              (m['current_stock'] as num?)?.toDouble() ?? 0.0,
            ),
            avgCost: Value((m['avg_cost'] as num?)?.toDouble() ?? 0.0),
            reorderLevel: Value(
              (m['reorder_level'] as num?)?.toDouble() ?? 10.0,
            ),
            bundle1Qty: Value((m['bundle1_qty'] as num?)?.toDouble() ?? 0.0),
            bundle1Price: Value(
              (m['bundle1_price'] as num?)?.toDouble() ?? 0.0,
            ),
            bundle2Qty: Value((m['bundle2_qty'] as num?)?.toDouble() ?? 0.0),
            bundle2Price: Value(
              (m['bundle2_price'] as num?)?.toDouble() ?? 0.0,
            ),
            bundle3Qty: Value((m['bundle3_qty'] as num?)?.toDouble() ?? 0.0),
            bundle3Price: Value(
              (m['bundle3_price'] as num?)?.toDouble() ?? 0.0,
            ),
            bundle4Qty: Value((m['bundle4_qty'] as num?)?.toDouble() ?? 0.0),
            bundle4Price: Value(
              (m['bundle4_price'] as num?)?.toDouble() ?? 0.0,
            ),
            bundle5Qty: Value((m['bundle5_qty'] as num?)?.toDouble() ?? 0.0),
            bundle5Price: Value(
              (m['bundle5_price'] as num?)?.toDouble() ?? 0.0,
            ),
            isDeleted: Value((m['is_deleted'] as num?)?.toInt() ?? 0),
          ),
        );
      }

      // 4. Sales
      for (final j in (backup['sales'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.createSale(
          SalesCompanion(
            personId: Value((m['person_id'] as num).toInt()),
            invoiceNumber: Value(m['invoice_number'] as String? ?? ''),
            date: Value(m['date'] as String? ?? ''),
            dueDate: Value(m['due_date'] as String?),
            saleType: Value(
              (m['saleType'] as String?) ??
                  (m['sale_type'] as String?) ??
                  'CREDIT',
            ),
            total: Value((m['total'] as num?)?.toDouble() ?? 0.0),
            status: Value(m['status'] as String? ?? 'NORMAL'),
            notes: Value(m['notes'] as String?),
            isDeleted: Value((m['is_deleted'] as num?)?.toInt() ?? 0),
          ),
        );
      }

      // 5. Sale items
      for (final j in (backup['saleItems'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addSaleItem(
          SaleItemsCompanion(
            saleId: Value((m['sale_id'] as num).toInt()),
            productId: Value((m['product_id'] as num).toInt()),
            quantity: Value((m['quantity'] as num?)?.toDouble() ?? 0.0),
            price: Value((m['price'] as num?)?.toDouble() ?? 0.0),
            total: Value((m['total'] as num?)?.toDouble() ?? 0.0),
            costOfGoods: Value((m['cost_of_goods'] as num?)?.toDouble() ?? 0.0),
          ),
        );
      }

      // 6. Product purchases
      for (final j in (backup['productPurchases'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addProductPurchase(
          ProductPurchasesCompanion(
            productId: Value((m['product_id'] as num).toInt()),
            supplierId: Value((m['supplier_id'] as num?)?.toInt()),
            date: Value(m['date'] as String? ?? ''),
            quantity: Value((m['quantity'] as num?)?.toDouble() ?? 0.0),
            qtyPerUnit: Value((m['qty_per_unit'] as num?)?.toDouble() ?? 1.0),
            costPerUnit: Value((m['cost_per_unit'] as num?)?.toDouble() ?? 0.0),
            totalCost: Value((m['total_cost'] as num?)?.toDouble() ?? 0.0),
            remainingQuantity: Value(
              (m['remaining_quantity'] as num?)?.toDouble() ?? 0.0,
            ),
          ),
        );
      }

      // 7. Payments
      for (final j in (backup['payments'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        final receiptType = (m['receiptType'] as String?) ??
            (m['receipt_type'] as String?) ??
            (m['payment_method'] as String?) ??
            'CREDIT_RECEIPT';
        await _db.addPayment(
          PaymentsCompanion(
            personId: Value((m['person_id'] as num).toInt()),
            date: Value(m['date'] as String? ?? ''),
            amount: Value((m['amount'] as num?)?.toDouble() ?? 0.0),
            receiptType: Value(receiptType),
            paymentMethod: Value(m['payment_method'] as String? ?? receiptType),
            reference: Value(m['reference'] as String?),
            isDeleted: Value((m['is_deleted'] as num?)?.toInt() ?? 0),
          ),
        );
      }

      // 8. Allocations
      for (final j in (backup['allocations'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addAllocation(
          AllocationsCompanion(
            paymentId: Value((m['payment_id'] as num).toInt()),
            allocatedItemId: Value(
                (m['sale_id'] as num? ?? m['allocated_item_id'] as num? ?? -1)
                    .toInt()),
            allocatedItemType:
                Value(m['allocated_item_type'] as String? ?? 'SALE'),
            amount: Value((m['amount'] as num?)?.toDouble() ?? 0.0),
            isActive: Value((m['is_active'] as num?)?.toInt() ?? 1),
          ),
        );
      }

      // 9. Stock allocations
      for (final j in (backup['stockAllocations'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addStockAllocation(
          StockAllocationsCompanion(
            saleItemId: Value((m['sale_item_id'] as num).toInt()),
            purchaseId: Value((m['purchase_id'] as num).toInt()),
            quantity: Value((m['quantity'] as num?)?.toDouble() ?? 0.0),
            costPerUnit: Value((m['cost_per_unit'] as num?)?.toDouble() ?? 0.0),
          ),
        );
      }

      // 10. Expenses
      for (final j in (backup['expenses'] as List? ?? [])) {
        final m = j as Map<String, dynamic>;
        await _db.addExpense(
          ExpensesCompanion(
            date: Value(m['date'] as String? ?? ''),
            category: Value(m['category'] as String? ?? ''),
            description: Value(m['description'] as String? ?? ''),
            amount: Value((m['amount'] as num?)?.toDouble() ?? 0.0),
            paymentMethod: Value(m['payment_method'] as String?),
            reference: Value(m['reference'] as String?),
            personId: Value((m['person_id'] as num?)?.toInt()),
            isDeleted: Value((m['is_deleted'] as num?)?.toInt() ?? 0),
          ),
        );
      }

      if (mounted) {
        _loadBusinessDetails();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Backup restored successfully! Please restart the app.',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Restore failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resetApp() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text(
          'This will delete ALL data including your PIN, business details, customers, products, and sales. This cannot be undone!\n\nAre you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              try {
                // Clear all database tables first
                await _db.deleteAllData();

                await AppSettingsStore.deleteAll();
                await DatabasePathService.clear();

                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              } catch (e) {
                navigator.pop(); // Close the dialog
                messenger.showSnackBar(
                  SnackBar(content: Text('Reset failed: $e')),
                );
              }
            },
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }

  Future<void> _safelyRemoveVault() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Safely Remove Vault'),
        content: const Text(
          'This will flush pending writes, checkpoint the database, close '
          'database handles, and lock the app into a safe-to-remove screen. '
          'Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Prepare Vault'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isPreparingRemoval = true);

    try {
      final result = await PortableVaultService.prepareForSafeRemoval();
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SafeRemovalScreen(dataPath: result.dataPath),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      setState(() => _isPreparingRemoval = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Safe removal failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Settings',
        subtitle: 'App settings and preferences',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business Details Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Business Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _businessType,
                      decoration: const InputDecoration(
                        labelText: 'Business Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Individual',
                          child: Text('Individual'),
                        ),
                        DropdownMenuItem(
                          value: 'Sole Trader',
                          child: Text('Sole Trader'),
                        ),
                        DropdownMenuItem(
                          value: 'Limited Company',
                          child: Text('Limited Company'),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _businessType = value!),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _businessNameController,
                      decoration: const InputDecoration(
                        labelText: 'Business Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _registrationController,
                      decoration: InputDecoration(
                        labelText: _businessType == 'Limited Company'
                            ? 'Company Registration Number'
                            : 'Tax/VAT Number (Optional)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _saveBusinessDetails,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Business Details'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Security Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Security',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _changePIN,
                      icon: const Icon(Icons.lock),
                      label: const Text('Change PIN'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Backup & Restore Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Backup & Restore',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Backup your data regularly to prevent data loss.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _backupData,
                      icon: const Icon(Icons.backup),
                      label: const Text('Download Backup'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _restoreData,
                      icon: const Icon(Icons.restore),
                      label: const Text('Restore from Backup'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Local Database Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Local Database',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _databasePath,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isChangingDatabaseLocation ||
                              !LocalDatabasePicker.isSupported
                          ? null
                          : _chooseDatabaseFolder,
                      icon: _isChangingDatabaseLocation
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.folder_open),
                      label: const Text('Choose Folder'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _isChangingDatabaseLocation ||
                              !LocalDatabasePicker.isSupported
                          ? null
                          : _chooseDatabaseFile,
                      icon: const Icon(Icons.storage),
                      label: const Text('Choose Database'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _isChangingDatabaseLocation
                          ? null
                          : _resetDatabaseLocation,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Portable Vault Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Portable Vault',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Prepare the USB vault before unplugging it.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed:
                          _isPreparingRemoval ? null : _safelyRemoveVault,
                      icon: _isPreparingRemoval
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.usb),
                      label: Text(
                        _isPreparingRemoval
                            ? 'Preparing Vault...'
                            : 'Safely Remove Vault',
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Danger Zone
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Danger Zone',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _resetApp,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Reset App (Delete Everything)'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _registrationController.dispose();
    super.dispose();
  }
}
