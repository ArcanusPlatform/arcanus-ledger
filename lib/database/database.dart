import 'package:drift/drift.dart';
import 'tables.dart';
import '../models/payment_allocation_model.dart';
import 'connection/unsupported.dart'
    if (dart.library.html) 'connection/web.dart'
    if (dart.library.io) 'connection/native.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    People,
    Suppliers,
    Products,
    Sales,
    SaleItems,
    Payments,
    Allocations,
    ProductPurchases,
    StockAllocations,
    Expenses,
    ExpenseCategories,
    FinanceAgreements,
    FinancePayments,
    FinanceSaleLinks,
    SupplierInvoices,
    SupplierInvoiceItems,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  static const String financeSettlementReceiptType = 'FINANCE_SETTLEMENT';

  static String financeSettlementReference(int agreementId) =>
      'Ledger Settlement FIN-${agreementId.toString().padLeft(3, '0')}';

  static AppDatabase? _instance;

  static AppDatabase get instance {
    if (_instance == null) {
      throw StateError(
        'AppDatabase not initialized. Call AppDatabase.init() first.',
      );
    }
    return _instance!;
  }

  static Future<void> init() async {
    if (_instance != null) return;
    final executor = await connect();
    _instance = AppDatabase(executor);
  }

  static bool get isInitialized => _instance != null;

  static Future<void> prepareForRemoval() async {
    final db = _instance;
    if (db == null) return;

    await db.flushAndCheckpoint();
    await db.close();
  }

  @override
  Future<void> close() async {
    await super.close();
    if (identical(_instance, this)) {
      _instance = null;
    }
  }

  @override
  int get schemaVersion => 22;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _createLiteSyncTables();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from == 1) {
            await m.addColumn(people, people.startBalance);
            await m.addColumn(people, people.startDate);
            await m.deleteTable('sales');
            await m.createTable(sales);
          }
          if (from <= 2) {
            await m.addColumn(people, people.creditLimit);
            await m.addColumn(people, people.paymentTermsDays);
          }
          if (from <= 3) {
            await m.addColumn(products, products.trackStock);
            await m.addColumn(products, products.currentStock);
            await m.addColumn(products, products.avgCost);
            await m.addColumn(saleItems, saleItems.costOfGoods);
            await m.createTable(productPurchases);
            await m.createTable(stockAllocations);
          }
          if (from <= 4) {
            await m.createTable(expenses);
          }
          if (from <= 5) {
            await m.createTable(expenseCategories);
            await _seedDefaultExpenseCategories();
          }
          if (from <= 6) {
            await m.addColumn(products, products.reorderLevel);
            await m.addColumn(productPurchases, productPurchases.supplierId);
          }
          if (from <= 7) {
            await m.addColumn(people, people.notes);
          }
          if (from <= 8) {
            await m.addColumn(products, products.bundle1Qty);
            await m.addColumn(products, products.bundle1Price);
            await m.addColumn(products, products.bundle2Qty);
            await m.addColumn(products, products.bundle2Price);
            await m.addColumn(products, products.bundle3Qty);
            await m.addColumn(products, products.bundle3Price);
            await m.addColumn(products, products.bundle4Qty);
            await m.addColumn(products, products.bundle4Price);
            await m.addColumn(products, products.bundle5Qty);
            await m.addColumn(products, products.bundle5Price);
          }
          if (from <= 9) {
            await m.addColumn(productPurchases, productPurchases.qtyPerUnit);
          }
          if (from <= 10) {
            try {
              await m.addColumn(people, people.dueDate);
            } catch (_) {
              // Column may already exist if migration ran previously
            }
          }
          if (from <= 11) {
            try {
              await m.addColumn(sales, sales.dueDate);
            } catch (_) {
              // Column may already exist if migration ran previously
            }
          }
          if (from <= 12) {
            try {
              await m.addColumn(sales, sales.saleType);
            } catch (_) {
              // Column may already exist if migration ran previously
            }
            await customStatement('''
              UPDATE sales
              SET sale_type = 'CASH'
              WHERE id IN (
                SELECT s.id
                FROM sales s
                JOIN allocations a
                  ON a.sale_id = s.id
                 AND a.is_active = 1
                GROUP BY s.id
                HAVING SUM(a.amount) >= s.total - 0.01
              )
            ''');
          }
          if (from <= 13) {
            try {
              await m.addColumn(payments, payments.receiptType);
            } catch (_) {
              // Column may already exist if migration ran previously
            }
            await customStatement('''
              UPDATE payments
              SET receipt_type = CASE
                WHEN id IN (
                  SELECT p.id
                  FROM payments p
                  JOIN allocations a
                    ON a.payment_id = p.id
                   AND a.is_active = 1
                  JOIN sales s
                    ON s.id = a.sale_id
                   AND s.is_deleted = 0
                  WHERE s.sale_type = 'CASH'
                )
                THEN 'CASH_SALE'
                ELSE 'CREDIT_RECEIPT'
              END
            ''');
            await customStatement('''
              UPDATE sales
              SET status = 'PAID'
              WHERE sale_type = 'CASH'
                AND status = 'NORMAL'
                AND is_deleted = 0
            ''');
          }
          if (from <= 14) {
            await m.createTable(financeAgreements);
            await m.createTable(financePayments);
          }
          if (from <= 15) {
            // Finance source metadata columns
            try {
              await m.addColumn(
                  financeAgreements, financeAgreements.financeSource);
            } catch (_) {}
            try {
              await m.addColumn(
                  financeAgreements, financeAgreements.linkedPersonId);
            } catch (_) {}
            try {
              await m.addColumn(
                  financeAgreements, financeAgreements.sourceSalesAmount);
            } catch (_) {}
            try {
              await m.addColumn(
                  financeAgreements, financeAgreements.additionalAmount);
            } catch (_) {}
            try {
              await m.addColumn(
                  financeAgreements, financeAgreements.purposeNote);
            } catch (_) {}
            try {
              await m.addColumn(financeAgreements, financeAgreements.assetNote);
            } catch (_) {}
            // Sale links junction table
            await m.createTable(financeSaleLinks);
          }
          if (from <= 16) {
            // Suppliers table
            try {
              await m.createTable(suppliers);
            } catch (_) {}
            // payment_type column on payments (missed in earlier migrations)
            try {
              await m.addColumn(payments, payments.paymentType);
            } catch (_) {}
          }
          if (from <= 17) {
            // No-op placeholder for v17
          }
          if (from <= 18) {
            // Rename allocations.sale_id → allocated_item_id
            // and add allocated_item_type column
            try {
              await customStatement('''
                ALTER TABLE allocations RENAME COLUMN sale_id TO allocated_item_id
              ''');
            } catch (_) {
              // Column may already be renamed (fresh install)
            }
            try {
              await m.addColumn(allocations, allocations.allocatedItemType);
            } catch (_) {}
            // Back-fill type for existing rows
            await customStatement('''
              UPDATE allocations
              SET allocated_item_type = CASE
                WHEN allocated_item_id = -1 THEN 'OPENING_BALANCE'
                WHEN allocated_item_id = 0  THEN 'CREDIT_ON_ACCOUNT'
                ELSE 'SALE'
              END
              WHERE allocated_item_type IS NULL OR allocated_item_type = ''
            ''');
          }
          if (from <= 19) {
            // Seed full COA expense categories for existing users.
            await _seedDefaultExpenseCategories();
          }
          if (from <= 20) {
            // Supplier invoices tables
            await m.createTable(supplierInvoices);
            await m.createTable(supplierInvoiceItems);
            // Ensure payment_type exists for any DB that missed it
            try {
              await m.addColumn(payments, payments.paymentType);
            } catch (_) {}
          }
          if (from <= 21) {
            await _createLiteSyncTables();
          }
        },
      );

  Future<String> integrityCheck() async {
    final rows = await customSelect('PRAGMA integrity_check').get();
    if (rows.isEmpty) {
      return 'No integrity check result returned';
    }

    final values = rows.first.data.values;
    final value = values.isEmpty ? null : values.first;
    return value?.toString() ?? 'No integrity check result returned';
  }

  Future<void> checkpointWal() async {
    await customSelect('PRAGMA wal_checkpoint(TRUNCATE)').get();
  }

  Future<void> flushAndCheckpoint() async {
    await customStatement('PRAGMA optimize');
    await checkpointWal();
  }

  Future<void> _createLiteSyncTables() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS lite_sync_events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        operation TEXT NOT NULL,
        payload_json TEXT NOT NULL,
        created_at TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'PENDING',
        synced_at TEXT,
        error TEXT
      )
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_lite_sync_events_status_created
      ON lite_sync_events(status, created_at)
    ''');
  }

  Future<void> ensureLiteSyncTables() => _createLiteSyncTables();

  Future<int> recordLiteSyncEvent({
    required String entityType,
    required int entityId,
    required String operation,
    required String payloadJson,
    DateTime? createdAt,
  }) async {
    await ensureLiteSyncTables();
    return customInsert(
      '''
      INSERT INTO lite_sync_events
        (entity_type, entity_id, operation, payload_json, created_at, status)
      VALUES (?, ?, ?, ?, ?, 'PENDING')
      ''',
      variables: [
        Variable.withString(entityType),
        Variable.withInt(entityId),
        Variable.withString(operation),
        Variable.withString(payloadJson),
        Variable.withString((createdAt ?? DateTime.now()).toIso8601String()),
      ],
    );
  }

  Future<List<LiteSyncEvent>> getLiteSyncEvents({String? status}) async {
    await ensureLiteSyncTables();
    final rows = await customSelect(
      '''
      SELECT id, entity_type, entity_id, operation, payload_json, created_at,
             status, synced_at, error
      FROM lite_sync_events
      ${status == null ? '' : 'WHERE status = ?'}
      ORDER BY created_at DESC
      ''',
      variables: status == null ? const [] : [Variable.withString(status)],
    ).get();

    return rows.map((row) => LiteSyncEvent.fromData(row.data)).toList();
  }

  Future<Map<String, int>> getLiteSyncCounts() async {
    await ensureLiteSyncTables();
    final rows = await customSelect(
      '''
      SELECT status, COUNT(*) AS count
      FROM lite_sync_events
      GROUP BY status
      ''',
    ).get();

    final counts = <String, int>{'PENDING': 0, 'SYNCED': 0, 'FAILED': 0};
    for (final row in rows) {
      counts[row.data['status'] as String] = row.data['count'] as int;
    }
    return counts;
  }

  Future<void> markLiteSyncEventSynced(int id, {DateTime? syncedAt}) async {
    await ensureLiteSyncTables();
    await customStatement(
      '''
      UPDATE lite_sync_events
      SET status = 'SYNCED', synced_at = ?, error = NULL
      WHERE id = ?
      ''',
      [(syncedAt ?? DateTime.now()).toIso8601String(), id],
    );
  }

  /// Inserts the default COA expense categories, skipping any that already exist.
  Future<void> ensureDefaultExpenseCategories() =>
      _seedDefaultExpenseCategories();

  Future<void> _seedDefaultExpenseCategories() async {
    final existing = await select(expenseCategories).get();
    final existingNames = existing.map((c) => c.name).toSet();

    Future<void> add(String name, String color, String icon) async {
      if (!existingNames.contains(name)) {
        await into(expenseCategories).insert(ExpenseCategoriesCompanion(
          name: Value(name),
          color: Value(color),
          icon: Value(icon),
          isDefault: const Value(1),
        ));
      }
    }

    // 5000 Direct Expenses
    await add('Productive Labour', 'red', 'build');
    await add('Cost of Sales Labour', 'red', 'build');
    await add('Sub-Contractors', 'red', 'business_center');
    await add('Sales Commissions', 'red', 'campaign');
    await add('Sales Promotions', 'pink', 'campaign');
    await add('Advertising', 'pink', 'campaign');
    await add('Gifts and Samples', 'pink', 'shopping_cart');
    await add('P.R. (Lit. & Brochures)', 'pink', 'description');
    await add('Postage and Courier', 'brown', 'local_shipping');
    await add('Bad Debts Written Off', 'grey', 'money_off');
    await add('Miscellaneous Direct Costs', 'grey', 'inventory_2');

    // 7000 Employment
    await add('Gross Wages', 'blue', 'people');
    await add('Directors Salaries', 'blue', 'people');
    await add('Directors Remuneration', 'blue', 'people');
    await add('Staff Salaries', 'blue', 'people');
    await add('Wages - Regular', 'blue', 'people');
    await add('Wages - Casual', 'blue', 'people');
    await add('Employers N.I.', 'indigo', 'people');
    await add('Employers Pensions', 'indigo', 'people');
    await add('Recruitment Expenses', 'indigo', 'business_center');
    await add('SSP Reclaimed', 'teal', 'people');
    await add('SMP Reclaimed', 'teal', 'people');

    // 7100 Premises
    await add('Rent', 'orange', 'home');
    await add('Rates', 'orange', 'home');
    await add('Water Rates', 'cyan', 'home');
    await add('Premises Insurance', 'orange', 'shield');
    await add('Gas', 'orange', 'bolt');
    await add('Oil', 'orange', 'bolt');
    await add('Other Heating Costs', 'orange', 'bolt');
    await add('Electricity', 'yellow', 'bolt');
    await add('Cleaning', 'teal', 'build');
    await add('Repairs & Maintenance', 'brown', 'build');
    await add('Security Costs', 'indigo', 'shield');

    // 7300 Motor & Travel
    await add('Vehicle Fuel', 'green', 'local_gas_station');
    await add('Vehicle Repairs & Servicing', 'green', 'directions_car');
    await add('Vehicle Licences', 'green', 'directions_car');
    await add('Vehicle Insurance', 'green', 'shield');
    await add('Motor Expenses', 'green', 'directions_car');
    await add('Congestion Charges', 'green', 'directions_car');
    await add('Mileage Claims', 'green', 'directions_car');
    await add('Scale Charges', 'green', 'directions_car');
    await add('Travelling', 'teal', 'directions_car');
    await add('Car Hire', 'teal', 'directions_car');
    await add('Hotels', 'teal', 'hotel');
    await add('Taxis & Parking', 'teal', 'local_taxi');
    await add('Overseas Travel', 'teal', 'flight');
    await add('Subsistence', 'teal', 'restaurant');

    // 7500 Office
    await add('Printing & Stationery', 'purple', 'description');
    await add('Postage', 'purple', 'mail');
    await add('Office Supplies', 'purple', 'inventory_2');
    await add('Books & Subscriptions', 'purple', 'description');
    await add('Telephone & Fax', 'teal', 'phone');
    await add('Internet Charges', 'teal', 'wifi');
    await add('Computers & Software', 'blue', 'computer');
    await add('Mobile Charges', 'teal', 'smartphone');
    await add('Office Equipment', 'purple', 'computer');
    await add('Photocopier Costs', 'purple', 'description');

    // 7600 Professional
    await add('Legal Fees', 'indigo', 'gavel');
    await add('Audit Fees', 'indigo', 'business_center');
    await add('Accountancy Fees', 'indigo', 'business_center');
    await add('Consultancy Fees', 'indigo', 'business_center');
    await add('Professional Fees', 'indigo', 'business_center');
    await add('Management Charges', 'indigo', 'business_center');
    await add('Software Subscriptions', 'blue', 'computer');

    // 7700 General
    await add('Bank Charges', 'grey', 'account_balance');
    await add('Interest Payable', 'grey', 'account_balance');
    await add('Interest Receivable', 'grey', 'account_balance');
    await add('Currency Charges', 'grey', 'currency_exchange');
    await add('Loan Interest Paid', 'grey', 'account_balance');
    await add('Insurance', 'red', 'shield');
    await add('General Insurance', 'red', 'shield');
    await add('Refreshments', 'brown', 'restaurant');
    await add('Clothing Costs', 'brown', 'shopping_cart');
    await add('Training Costs', 'blue', 'school');
    await add('Entertainment', 'pink', 'celebration');
    await add('Sundry Expenses', 'grey', 'inventory_2');
  }

  // People operations
  Future<List<dynamic>> getAllPeople() =>
      (select(people)..where((t) => t.isDeleted.equals(0))).get();
  Future<dynamic> getPersonById(int id) =>
      (select(people)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> addPerson(PeopleCompanion person) => into(people).insert(person);
  Future<bool> updatePerson(PeopleCompanion person) =>
      update(people).replace(person);
  Future<int> deletePerson(int id) =>
      (update(people)..where((t) => t.id.equals(id)))
          .write(const PeopleCompanion(isDeleted: Value(1)));

  // Products operations
  Future<List<dynamic>> getAllProducts() =>
      (select(products)..where((t) => t.isDeleted.equals(0))).get();
  Future<int> addProduct(ProductsCompanion product) =>
      into(products).insert(product);
  Future<bool> updateProduct(ProductsCompanion product) async {
    if (!product.id.present) {
      throw ArgumentError('Product ID is required for update');
    }
    final updatedRows = await (update(products)
          ..where((t) => t.id.equals(product.id.value)))
        .write(product);
    return updatedRows > 0;
  }

  Future<int> deleteProduct(int id) =>
      (update(products)..where((t) => t.id.equals(id)))
          .write(const ProductsCompanion(isDeleted: Value(1)));

  // Sales operations
  Future<List<dynamic>> getAllSales() =>
      (select(sales)..where((t) => t.isDeleted.equals(0))).get();
  Future<dynamic> getSaleById(int id) =>
      (select(sales)..where((t) => t.id.equals(id))).getSingleOrNull();
  Future<int> createSale(SalesCompanion sale) => into(sales).insert(sale);
  Future<bool> updateSale(SalesCompanion sale) async {
    if (!sale.id.present) {
      throw ArgumentError('Sale ID is required for update');
    }
    final updatedRows = await (update(sales)
          ..where((t) => t.id.equals(sale.id.value)))
        .write(sale);
    return updatedRows > 0;
  }

  Future<int> updateSaleEditableFields({
    required int id,
    required String invoiceNumber,
    required String date,
    String? dueDate,
    String? notes,
  }) async {
    return transaction(() async {
      final updatedRows =
          await (update(sales)..where((t) => t.id.equals(id))).write(
        SalesCompanion(
          invoiceNumber: Value(invoiceNumber),
          date: Value(date),
          dueDate: Value(dueDate == null || dueDate.trim().isEmpty
              ? null
              : dueDate.trim()),
          notes: Value(
              notes == null || notes.trim().isEmpty ? null : notes.trim()),
        ),
      );

      await customStatement(
        '''
        UPDATE payments
        SET reference = ?
        WHERE receipt_type = 'CASH_SALE'
          AND id IN (
            SELECT payment_id
            FROM allocations
            WHERE allocated_item_id = ?
              AND allocated_item_type = 'SALE'
              AND is_active = 1
          )
        ''',
        ['Payment for INV-$invoiceNumber', id],
      );

      return updatedRows;
    });
  }

  Future<int> deleteSale(int id) =>
      (update(sales)..where((t) => t.id.equals(id)))
          .write(const SalesCompanion(isDeleted: Value(1)));

  // Sale Items operations
  Future<List<dynamic>> getSaleItems(int saleId) =>
      (select(saleItems)..where((t) => t.saleId.equals(saleId))).get();
  Future<List<SaleItem>> getAllSaleItems() => select(saleItems).get();
  Future<int> addSaleItem(SaleItemsCompanion item) =>
      into(saleItems).insert(item);
  Future<bool> updateSaleItem(SaleItemsCompanion item) =>
      update(saleItems).replace(item);

  // Payments operations
  Future<List<dynamic>> getAllPayments() => select(payments).get();
  Future<int> addPayment(PaymentsCompanion payment) =>
      into(payments).insert(payment);
  Future<int> deletePayment(int id) =>
      (delete(payments)..where((t) => t.id.equals(id))).go();

  // Allocations operations
  Future<int> addAllocation(AllocationsCompanion allocation) =>
      into(allocations).insert(allocation);
  Future<List<Allocation>> getAllAllocations() => select(allocations).get();
  Future<List<dynamic>> getAllocationsForSale(int saleId) => (select(
        allocations,
      )..where((t) =>
              t.allocatedItemId.equals(saleId) &
              t.allocatedItemType.equals('SALE') &
              t.isActive.equals(1)))
          .get();

  // Suppliers operations
  Future<List<Supplier>> getActiveSuppliers() => (select(suppliers)
        ..where((t) => t.isDeleted.equals(0))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .get();
  Future<int> addSupplier(SuppliersCompanion supplier) =>
      into(suppliers).insert(supplier);
  Future<bool> updateSupplier(SuppliersCompanion supplier) =>
      update(suppliers).replace(supplier);
  Future<int> deleteSupplier(int id) =>
      (update(suppliers)..where((t) => t.id.equals(id)))
          .write(const SuppliersCompanion(isDeleted: Value(1)));

  // ── Supplier Invoice operations ───────────────────────────────────────────

  Future<List<SupplierInvoice>> getSupplierInvoices(int supplierId) =>
      (select(supplierInvoices)
            ..where(
                (t) => t.supplierId.equals(supplierId) & t.isDeleted.equals(0))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<SupplierInvoice>> getAllSupplierInvoices() =>
      (select(supplierInvoices)..where((t) => t.isDeleted.equals(0))).get();

  Future<int> createSupplierInvoice(SupplierInvoicesCompanion invoice) =>
      into(supplierInvoices).insert(invoice);

  Future<int> deleteSupplierInvoice(int id) =>
      (update(supplierInvoices)..where((t) => t.id.equals(id)))
          .write(const SupplierInvoicesCompanion(isDeleted: Value(1)));

  Future<int> addSupplierInvoiceItem(SupplierInvoiceItemsCompanion item) =>
      into(supplierInvoiceItems).insert(item);

  Future<List<SupplierInvoiceItem>> getSupplierInvoiceItems(int invoiceId) =>
      (select(supplierInvoiceItems)
            ..where((t) => t.invoiceId.equals(invoiceId)))
          .get();

  /// Post a supplier invoice with its line items atomically.
  /// Also updates product stock/avgCost for product lines.
  Future<int> createSupplierInvoiceWithItems(
    SupplierInvoicesCompanion invoice,
    List<Map<String, dynamic>> items,
  ) =>
      transaction(() async {
        final invoiceId = await into(supplierInvoices).insert(invoice);
        for (final item in items) {
          await into(supplierInvoiceItems).insert(
            SupplierInvoiceItemsCompanion(
              invoiceId: Value(invoiceId),
              description: Value(item['description'] as String),
              category: Value(item['category'] as String?),
              productId: Value(item['productId'] as int?),
              quantity: Value((item['quantity'] as num).toDouble()),
              unitCost: Value((item['unitCost'] as num).toDouble()),
              total: Value((item['total'] as num).toDouble()),
            ),
          );
          // Update product stock if it's a product line
          final productId = item['productId'] as int?;
          if (productId != null) {
            final product = await getProductById(productId);
            if (product != null) {
              final qty = (item['quantity'] as num).toDouble();
              final cost = (item['total'] as num).toDouble();
              final newQty = product.currentStock + qty;
              final newAvgCost =
                  ((product.currentStock * product.avgCost) + cost) / newQty;
              await (update(products)..where((p) => p.id.equals(productId)))
                  .write(ProductsCompanion(
                currentStock: Value(newQty),
                avgCost: Value(newAvgCost),
              ));
              await addProductPurchase(ProductPurchasesCompanion(
                productId: Value(productId),
                supplierId: invoice.supplierId,
                date: invoice.date,
                quantity: Value(qty),
                qtyPerUnit: const Value(1.0),
                costPerUnit: Value((item['unitCost'] as num).toDouble()),
                totalCost: Value(cost),
                remainingQuantity: Value(qty),
              ));
            }
          } else {
            final category = item['category'] as String?;
            if (category != null && category.trim().isNotEmpty) {
              await into(expenses).insert(ExpensesCompanion(
                date: invoice.date,
                category: Value(category),
                description: Value(item['description'] as String),
                amount: Value((item['total'] as num).toDouble()),
                paymentMethod: const Value(null),
                reference: invoice.invoiceNumber.present
                    ? Value('Supplier invoice ${invoice.invoiceNumber.value}')
                    : const Value(null),
                personId: invoice.supplierId.present
                    ? Value(invoice.supplierId.value)
                    : const Value.absent(),
                isDeleted: const Value(0),
              ));
            }
          }
        }
        return invoiceId;
      });

  /// Record a supplier payment and allocate it to invoices.
  Future<int> recordSupplierPayment({
    required int supplierId,
    required String date,
    required double amount,
    required String paymentMethod,
    String? reference,
    List<Map<String, dynamic>> allocations = const [],
  }) =>
      transaction(() async {
        final paymentId = await into(payments).insert(PaymentsCompanion(
          personId: Value(supplierId),
          date: Value(date),
          amount: Value(amount),
          paymentType: const Value('SUPPLIER_PAYMENT'),
          receiptType: const Value('SUPPLIER_PAYMENT'),
          paymentMethod: Value(paymentMethod),
          reference: Value(reference),
          isDeleted: const Value(0),
        ));
        final allocatedInvoiceIds = <int>{};
        for (final alloc in allocations) {
          if ((alloc['amount'] as num) > 0) {
            final invoiceId = alloc['invoiceId'] as int;
            await into(this.allocations).insert(AllocationsCompanion(
              paymentId: Value(paymentId),
              allocatedItemId: Value(invoiceId),
              allocatedItemType: const Value('SUPPLIER_INVOICE'),
              amount: Value((alloc['amount'] as num).toDouble()),
              isActive: const Value(1),
            ));
            allocatedInvoiceIds.add(invoiceId);
          }
        }

        for (final invoiceId in allocatedInvoiceIds) {
          await _refreshSupplierInvoiceStatus(invoiceId);
        }

        return paymentId;
      });

  Future<void> _refreshSupplierInvoiceStatus(int invoiceId) async {
    final invoice = await (select(supplierInvoices)
          ..where((t) => t.id.equals(invoiceId)))
        .getSingleOrNull();
    if (invoice == null || invoice.status == 'VOID') return;

    final allocated = await _supplierInvoicePaidAmount(invoiceId);
    final nextStatus = allocated >= invoice.total - 0.01
        ? 'PAID'
        : allocated > 0.01
            ? 'PART_PAID'
            : 'UNPAID';

    if (nextStatus != invoice.status) {
      await (update(supplierInvoices)..where((t) => t.id.equals(invoiceId)))
          .write(SupplierInvoicesCompanion(status: Value(nextStatus)));
    }
  }

  Future<double> _supplierInvoicePaidAmount(int invoiceId) async {
    final invoiceAllocations = await (select(allocations)
          ..where((a) =>
              a.allocatedItemId.equals(invoiceId) &
              a.allocatedItemType.equals('SUPPLIER_INVOICE') &
              a.isActive.equals(1)))
        .get();

    return invoiceAllocations.fold<double>(0.0, (sum, a) => sum + a.amount);
  }

  /// Outstanding supplier invoices — total minus allocated payments.
  Future<List<Map<String, dynamic>>> getOutstandingSupplierInvoices(
      int supplierId) async {
    final invoices = await getSupplierInvoices(supplierId);
    final allAllocs = await (select(allocations)
          ..where((a) =>
              a.allocatedItemType.equals('SUPPLIER_INVOICE') &
              a.isActive.equals(1)))
        .get();
    final result = <Map<String, dynamic>>[];
    for (final inv in invoices) {
      if (inv.status == 'VOID') continue;
      final paid = allAllocs
          .where((a) => a.allocatedItemId == inv.id)
          .fold(0.0, (s, a) => s + a.amount);
      final remaining = inv.total - paid;
      if (remaining > 0.01) {
        result.add({
          'id': inv.id,
          'invoiceNumber': inv.invoiceNumber,
          'date': inv.date,
          'dueDate': inv.dueDate,
          'total': inv.total,
          'paid': paid,
          'remaining': remaining,
        });
      }
    }
    return result;
  }

  /// Full supplier account summary — opening balance + invoices + payments.
  Future<Map<String, dynamic>> getSupplierAccountSummary(int supplierId) async {
    final supplier = await (select(people)
          ..where((t) => t.id.equals(supplierId) & t.isDeleted.equals(0)))
        .getSingleOrNull();

    final invoiceList = await getSupplierInvoices(supplierId);

    final supplierPayments = await (select(payments)
          ..where(
            (t) =>
                t.personId.equals(supplierId) &
                t.paymentType.equals('SUPPLIER_PAYMENT') &
                t.isDeleted.equals(0),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .get();

    double totalOwed = 0;
    double totalPaid = 0;
    final List<Map<String, dynamic>> ledger = [];

    if (supplier != null && supplier.startBalance > 0) {
      totalOwed += supplier.startBalance;
      ledger.add({
        'type': 'opening',
        'date': supplier.startDate ??
            DateTime.now().toIso8601String().split('T')[0],
        'reference': 'Opening Balance',
        'debit': supplier.startBalance,
        'credit': 0.0,
      });
    }

    for (final inv in invoiceList) {
      if (inv.status == 'VOID') continue;
      totalOwed += inv.total;
      ledger.add({
        'type': 'invoice',
        'id': inv.id,
        'date': inv.date,
        'dueDate': inv.dueDate,
        'reference': 'INV-${inv.invoiceNumber}',
        'debit': inv.total,
        'credit': 0.0,
        'status': inv.status,
      });
    }

    for (final payment in supplierPayments) {
      totalPaid += payment.amount;
      ledger.add({
        'type': 'payment',
        'date': payment.date,
        'reference': payment.reference ?? 'Supplier Payment',
        'debit': 0.0,
        'credit': payment.amount,
      });
    }

    ledger.sort(
      (a, b) => (a['date'] as String).compareTo(b['date'] as String),
    );

    return {
      'totalOwed': totalOwed,
      'totalPaid': totalPaid,
      'balance': totalOwed - totalPaid,
      'ledger': ledger,
    };
  }

  // Get account summary for a person
  Future<Map<String, dynamic>> getPersonAccountSummary(int personId) async {
    final person = await (select(
      people,
    )..where((t) => t.id.equals(personId)))
        .getSingleOrNull();
    final allSales = await (select(
      sales,
    )..where((t) => t.personId.equals(personId) & t.isDeleted.equals(0)))
        .get();
    final allPayments = await (select(
      payments,
    )..where((t) => t.personId.equals(personId) & t.isDeleted.equals(0)))
        .get();

    double totalInvoiced = 0;
    double totalPaid = 0;
    List<Map<String, dynamic>> ledger = [];

    // Add start balance as opening entry if it exists
    if (person != null && person.startBalance > 0 && person.startDate != null) {
      totalInvoiced += person.startBalance; // include in running balance
      ledger.add({
        'type': 'opening',
        'date': person.startDate!,
        'reference': 'Opening Balance',
        'debit': person.startBalance,
        'credit': 0.0,
        'status': 'NORMAL',
        'id': 0,
      });
    }

    for (var sale in allSales) {
      if (sale.status != 'VOID') {
        totalInvoiced += sale.total;
        ledger.add({
          'type': 'invoice',
          'date': sale.date,
          'dueDate': sale.dueDate,
          'reference': 'INV-${sale.invoiceNumber}',
          'debit': sale.total,
          'credit': 0.0,
          'status': sale.status,
          'id': sale.id,
        });
      }
    }

    for (var payment in allPayments) {
      totalPaid += payment.amount;
      ledger.add({
        'type': 'payment',
        'date': payment.date,
        'reference': payment.reference ?? 'Receipt',
        'debit': 0.0,
        'credit': payment.amount,
        'method': payment.receiptType,
        'receiptType': payment.receiptType,
        'id': payment.id,
      });
    }

    ledger.sort(
      (a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])),
    );

    return {
      'totalInvoiced': totalInvoiced,
      'totalPaid': totalPaid,
      'balance': totalInvoiced - totalPaid,
      'ledger': ledger,
    };
  }

  // Expenses operations
  Future<List<dynamic>> getAllExpenses() => select(expenses).get();
  Future<int> addExpense(ExpensesCompanion expense) =>
      into(expenses).insert(expense);
  Future<bool> updateExpense(ExpensesCompanion expense) =>
      update(expenses).replace(expense);
  Future<int> deleteExpense(int id) =>
      (delete(expenses)..where((t) => t.id.equals(id))).go();

  // Expense Categories operations
  Future<List<dynamic>> getAllExpenseCategories() =>
      (select(expenseCategories)..where((t) => t.isDeleted.equals(0))).get();
  Future<int> addExpenseCategory(ExpenseCategoriesCompanion category) =>
      into(expenseCategories).insert(category);
  Future<bool> updateExpenseCategory(ExpenseCategoriesCompanion category) =>
      update(expenseCategories).replace(category);
  Future<int> deleteExpenseCategory(int id) async {
    // Check if category is used
    final category = await (select(
      expenseCategories,
    )..where((c) => c.id.equals(id)))
        .getSingle();
    final expensesWithCategory = await (select(
      expenses,
    )..where((t) => t.category.equals(category.name)))
        .get();
    if (expensesWithCategory.isNotEmpty) {
      return 0; // Cannot delete, category is in use
    }
    return (delete(expenseCategories)..where((t) => t.id.equals(id))).go();
  }

  // Get outstanding invoices for a person
  Future<List<Map<String, dynamic>>> getOutstandingInvoices(
    int personId,
  ) async {
    final allSales = await (select(sales)
          ..where(
            (t) =>
                t.personId.equals(personId) &
                t.isDeleted.equals(0) &
                t.status.equals('NORMAL'),
          ))
        .get();
    final allAllocations = await select(allocations).get();

    List<Map<String, dynamic>> outstanding = [];

    for (var sale in allSales) {
      final allocated = allAllocations
          .where((a) =>
              a.allocatedItemId == sale.id &&
              a.allocatedItemType == 'SALE' &&
              a.isActive == 1)
          .fold(0.0, (sum, a) => sum + a.amount);

      final remaining = sale.total - allocated;
      if (remaining > 0.01) {
        outstanding.add({
          'id': sale.id,
          'invoiceNumber': sale.invoiceNumber,
          'date': sale.date,
          'dueDate': sale.dueDate,
          'total': sale.total,
          'allocated': allocated,
          'remaining': remaining,
        });
      }
    }

    return outstanding;
  }

  // FIFO Stock Allocation
  Future<double> allocateStockFIFO(
    int productId,
    double quantity,
    int saleItemId,
  ) async {
    final purchaseList = await (select(productPurchases)
          ..where(
            (p) =>
                p.productId.equals(productId) &
                p.remainingQuantity.isBiggerThanValue(0),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.date)]))
        .get();

    double remainingToAllocate = quantity;
    double totalCOGS = 0.0;

    for (var purchase in purchaseList) {
      if (remainingToAllocate <= 0) break;

      final allocateQty = remainingToAllocate < purchase.remainingQuantity
          ? remainingToAllocate
          : purchase.remainingQuantity;

      await into(stockAllocations).insert(
        StockAllocationsCompanion(
          saleItemId: Value(saleItemId),
          purchaseId: Value(purchase.id),
          quantity: Value(allocateQty),
          costPerUnit: Value(purchase.costPerUnit),
        ),
      );

      await (update(
        productPurchases,
      )..where((p) => p.id.equals(purchase.id)))
          .write(
        ProductPurchasesCompanion(
          remainingQuantity: Value(purchase.remainingQuantity - allocateQty),
        ),
      );

      totalCOGS += allocateQty * purchase.costPerUnit;
      remainingToAllocate -= allocateQty;
    }

    if (remainingToAllocate > 0) {
      throw Exception('Insufficient stock for allocation');
    }

    return totalCOGS;
  }

  // Reverse stock allocation for voided sales
  Future<void> reverseStockAllocation(int saleItemId) async {
    final allocationList = await (select(
      stockAllocations,
    )..where((a) => a.saleItemId.equals(saleItemId)))
        .get();

    for (var allocation in allocationList) {
      final purchase = await (select(
        productPurchases,
      )..where((p) => p.id.equals(allocation.purchaseId)))
          .getSingle();

      await (update(
        productPurchases,
      )..where((p) => p.id.equals(purchase.id)))
          .write(
        ProductPurchasesCompanion(
          remainingQuantity: Value(
            purchase.remainingQuantity + allocation.quantity,
          ),
        ),
      );

      await (delete(
        stockAllocations,
      )..where((a) => a.id.equals(allocation.id)))
          .go();
    }
  }

  // Get product by ID
  Future<Product?> getProductById(int id) async {
    return await (select(
      products,
    )..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Get suppliers (people with type SUPPLIER)
  Future<List<PeopleData>> getSuppliers() async {
    return await (select(
      people,
    )..where((t) => t.type.equals('SUPPLIER') & t.isDeleted.equals(0)))
        .get();
  }

  // Add product purchase
  Future<int> addProductPurchase(ProductPurchasesCompanion purchase) =>
      into(productPurchases).insert(purchase);
  Future<List<ProductPurchase>> getAllProductPurchases() =>
      select(productPurchases).get();
  Future<List<StockAllocation>> getAllStockAllocations() =>
      select(stockAllocations).get();
  Future<int> addStockAllocation(StockAllocationsCompanion allocation) =>
      into(stockAllocations).insert(allocation);

  // Get purchase history for a product
  Future<List<ProductPurchase>> getPurchaseHistory(int productId) async {
    return await (select(productPurchases)
          ..where((p) => p.productId.equals(productId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  // Payment-specific queries for Customer Receipts feature

  /// Get all payments with customer details
  /// Returns payments joined with customer information, excluding deleted payments
  Future<List<Map<String, dynamic>>> getPaymentsWithCustomers() async {
    final query = select(payments).join([
      leftOuterJoin(people, people.id.equalsExp(payments.personId)),
    ])
      ..where(payments.isDeleted.equals(0))
      ..orderBy([OrderingTerm.desc(payments.date)]);

    final results = await query.get();

    return results
        .where(
            (row) => row.readTable(payments).paymentType == 'CUSTOMER_RECEIPT')
        .map((row) {
      final payment = row.readTable(payments);
      final person = row.readTableOrNull(people);

      return {
        'id': payment.id,
        'personId': payment.personId,
        'date': payment.date,
        'amount': payment.amount,
        'receiptType': payment.receiptType,
        'paymentMethod': payment.paymentMethod,
        'reference': payment.reference ?? '',
        'isDeleted': payment.isDeleted,
        'customerName': person?.name ?? 'Unknown',
        'customerPhone': person?.phone,
        'customerEmail': person?.email,
      };
    }).toList();
  }

  /// Get payment details by ID with allocations
  /// Returns payment information along with all its allocation records
  Future<Map<String, dynamic>> getPaymentDetails(int paymentId) async {
    final payment = await (select(
      payments,
    )..where((p) => p.id.equals(paymentId)))
        .getSingleOrNull();

    if (payment == null) {
      throw Exception('Receipt not found');
    }

    final person = await (select(
      people,
    )..where((p) => p.id.equals(payment.personId)))
        .getSingleOrNull();

    final allocationsList = await (select(allocations)
          ..where(
            (a) => a.paymentId.equals(paymentId) & a.isActive.equals(1),
          ))
        .get();

    List<Map<String, dynamic>> allocationDetails = [];
    for (var allocation in allocationsList) {
      if (allocation.allocatedItemId == -1 || allocation.allocatedItemId == 0) {
        // Opening balance allocation
        allocationDetails.add({
          'id': allocation.id,
          'saleId': allocation.allocatedItemId,
          'amount': allocation.amount,
          'reference': 'Opening Balance',
          'date': person?.startDate ?? payment.date,
          'isActive': allocation.isActive,
        });
      } else {
        // Invoice allocation
        final sale = await (select(
          sales,
        )..where((s) => s.id.equals(allocation.allocatedItemId)))
            .getSingleOrNull();
        allocationDetails.add({
          'id': allocation.id,
          'saleId': allocation.allocatedItemId,
          'amount': allocation.amount,
          'reference': sale != null ? 'INV-${sale.invoiceNumber}' : 'Unknown',
          'date': sale?.date ?? payment.date,
          'isActive': allocation.isActive,
        });
      }
    }

    return {
      'id': payment.id,
      'personId': payment.personId,
      'date': payment.date,
      'amount': payment.amount,
      'paymentType': payment.paymentType,
      'paymentMethod': payment.paymentMethod,
      'reference': payment.reference ?? '',
      'isDeleted': payment.isDeleted,
      'customerName': person?.name ?? 'Unknown',
      'allocations': allocationDetails,
    };
  }

  /// Get outstanding items for a customer (opening balance + invoices)
  /// Returns list of items that can receive payment allocations
  Future<List<OutstandingItem>> getOutstandingItemsForCustomer(
    int customerId,
  ) async {
    List<OutstandingItem> items = [];

    // Get customer details
    final person = await (select(
      people,
    )..where((p) => p.id.equals(customerId)))
        .getSingleOrNull();

    if (person == null) {
      return items;
    }

    // Add opening balance if it exists and is greater than zero
    if (person.startBalance > 0) {
      // Get all payments for this customer
      final customerPayments = await (select(payments)
            ..where(
              (p) => p.personId.equals(customerId) & p.isDeleted.equals(0),
            ))
          .get();

      final paymentIds = customerPayments.map((p) => p.id).toList();

      // Calculate how much of opening balance has been allocated
      double allocatedToOpening = 0.0;
      if (paymentIds.isNotEmpty) {
        final openingAllocations = await (select(allocations)
              ..where(
                (a) =>
                    a.allocatedItemId.equals(-1) &
                    a.allocatedItemType.equals('OPENING_BALANCE') &
                    a.isActive.equals(1) &
                    a.paymentId.isIn(paymentIds),
              ))
            .get();

        allocatedToOpening = openingAllocations.fold(
          0.0,
          (sum, a) => sum + a.amount,
        );
      }

      final remainingOpening = person.startBalance - allocatedToOpening;

      if (remainingOpening > 0.01) {
        items.add(
          OutstandingItem(
            id: 'opening',
            type: 'opening',
            saleId: null,
            reference: 'Opening Balance',
            date: person.startDate ?? DateTime.now().toIso8601String(),
            dueDate: person.dueDate,
            outstandingAmount: remainingOpening,
          ),
        );
      }
    }

    // Get all normal (non-deleted, non-voided) sales for this customer
    final customerSales = await (select(sales)
          ..where(
            (s) =>
                s.personId.equals(customerId) &
                s.isDeleted.equals(0) &
                s.status.equals('NORMAL'),
          )
          ..orderBy([(s) => OrderingTerm.asc(s.date)]))
        .get();

    // For each sale, calculate outstanding amount
    for (var sale in customerSales) {
      final saleAllocations = await (select(
        allocations,
      )..where((a) =>
              a.allocatedItemId.equals(sale.id) &
              a.allocatedItemType.equals('SALE') &
              a.isActive.equals(1)))
          .get();

      final allocated = saleAllocations.fold(0.0, (sum, a) => sum + a.amount);
      final remaining = sale.total - allocated;

      if (remaining > 0.01) {
        items.add(
          OutstandingItem(
            id: 'invoice_${sale.id}',
            type: 'invoice',
            saleId: sale.id,
            reference: 'INV-${sale.invoiceNumber}',
            date: sale.date,
            dueDate: sale.dueDate,
            outstandingAmount: remaining,
          ),
        );
      }
    }

    // Sort all items by date (chronological order)
    items.sort((a, b) => a.date.compareTo(b.date));

    // Calculate total credit on account (saleId=0 allocations = unallocated payments)
    final customerPayments = await (select(payments)
          ..where(
            (p) => p.personId.equals(customerId) & p.isDeleted.equals(0),
          ))
        .get();
    final paymentIds = customerPayments.map((p) => p.id).toList();
    if (paymentIds.isNotEmpty) {
      final creditAllocations = await (select(allocations)
            ..where(
              (a) =>
                  a.allocatedItemId.equals(0) &
                  a.allocatedItemType.equals('CREDIT_ON_ACCOUNT') &
                  a.isActive.equals(1) &
                  a.paymentId.isIn(paymentIds),
            ))
          .get();
      final totalCredit =
          creditAllocations.fold(0.0, (sum, a) => sum + a.amount);
      if (totalCredit > 0.01) {
        items.insert(
          0,
          OutstandingItem(
            id: 'credit_on_account',
            type: 'credit',
            saleId: null,
            reference: 'Credit on Account',
            date: DateTime.now().toIso8601String(),
            dueDate: null,
            outstandingAmount: -totalCredit, // negative = reduces balance
          ),
        );
      }
    }

    return items;
  }

  /// Save payment with allocations as a transaction
  /// Ensures atomicity - either all records are saved or none
  Future<int> savePaymentWithAllocations(
    PaymentsCompanion payment,
    List<AllocationRecord> allocationRecords,
  ) async {
    return await transaction(() async {
      return _insertPaymentWithAllocations(payment, allocationRecords);
    });
  }

  Future<int> _insertPaymentWithAllocations(
    PaymentsCompanion payment,
    List<AllocationRecord> allocationRecords,
  ) async {
    final paymentId = await into(payments).insert(payment);

    for (var record in allocationRecords) {
      if (record.amount > 0) {
        await into(allocations).insert(
          AllocationsCompanion(
            paymentId: Value(paymentId),
            allocatedItemId: Value(record.saleId ?? -1),
            allocatedItemType: Value(
              record.saleId == null || record.saleId! <= 0
                  ? (record.saleId == 0
                      ? 'CREDIT_ON_ACCOUNT'
                      : 'OPENING_BALANCE')
                  : 'SALE',
            ),
            amount: Value(record.amount),
            isActive: const Value(1),
          ),
        );
      }
    }

    return paymentId;
  }

  /// Soft delete payment and deactivate all associated allocations
  /// Uses transaction to ensure consistency
  Future<void> deletePaymentWithAllocations(int paymentId) async {
    await transaction(() async {
      await _deletePaymentWithAllocations(paymentId);
    });
  }

  Future<void> _deletePaymentWithAllocations(int paymentId) async {
    await (update(payments)..where((p) => p.id.equals(paymentId))).write(
      const PaymentsCompanion(isDeleted: Value(1)),
    );

    await (update(allocations)..where((a) => a.paymentId.equals(paymentId)))
        .write(const AllocationsCompanion(isActive: Value(0)));
  }

  Future<int> createSaleWithItems(
    SalesCompanion sale,
    List<Map<String, dynamic>> items, {
    bool skipStockValidation = false,
    PaymentsCompanion? receipt,
  }) async {
    return await transaction(() async {
      // First, check for sufficient stock for all items (unless skipped for imports).
      if (!skipStockValidation) {
        for (var item in items) {
          final product = item['product'] as Product;
          final quantity = item['quantity'] as double;

          if (product.trackStock) {
            final freshProduct = await getProductById(product.id);
            if (freshProduct == null) {
              throw Exception('Product ${product.name} could not be found.');
            }
            if (quantity > freshProduct.currentStock) {
              // This exception will roll back the entire transaction.
              throw Exception(
                  'Insufficient stock for ${product.name}. Available: ${freshProduct.currentStock.toStringAsFixed(0)}, Required: ${quantity.toStringAsFixed(0)}');
            }
          }
        }
      }

      // If all stock checks pass, proceed to create the sale.
      final saleId = await into(sales).insert(sale);

      // Process each line item.
      for (var item in items) {
        final product = item['product'] as Product;
        final quantity = item['quantity'] as double;
        final pricePerUnit = item['pricePerUnit'] as double;
        final total = item['total'] as double;

        final saleItemId = await into(saleItems).insert(
          SaleItemsCompanion(
            saleId: Value(saleId),
            productId: Value(product.id),
            quantity: Value(quantity),
            price: Value(pricePerUnit),
            total: Value(total),
          ),
        );

        if (product.trackStock) {
          if (skipStockValidation) {
            // For imports: Calculate COGS using average cost, don't deduct stock
            final freshProduct = await getProductById(product.id);
            final estimatedCOGS = quantity * (freshProduct?.avgCost ?? 0.0);

            await (update(saleItems)..where((si) => si.id.equals(saleItemId)))
                .write(
              SaleItemsCompanion(costOfGoods: Value(estimatedCOGS)),
            );
          } else {
            // For normal sales: Try FIFO allocation, fallback to avgCost
            double actualCOGS;
            try {
              actualCOGS = await allocateStockFIFO(
                product.id,
                quantity,
                saleItemId,
              );
            } catch (e) {
              // FIFO failed (no purchase records), use average cost
              final freshProduct = await getProductById(product.id);
              actualCOGS = quantity * (freshProduct?.avgCost ?? 0.0);
            }

            await (update(saleItems)..where((si) => si.id.equals(saleItemId)))
                .write(
              SaleItemsCompanion(costOfGoods: Value(actualCOGS)),
            );

            // Read the fresh product again to get the most up-to-date stock before updating
            final freshProduct = await getProductById(product.id);
            final newStock = freshProduct!.currentStock - quantity;
            await (update(products)..where((p) => p.id.equals(product.id)))
                .write(
              ProductsCompanion(currentStock: Value(newStock)),
            );
          }
        }
      }
      if (receipt != null) {
        final paymentId = await into(payments).insert(receipt);
        await into(allocations).insert(
          AllocationsCompanion(
            paymentId: Value(paymentId),
            allocatedItemId: Value(saleId),
            allocatedItemType: const Value('SALE'),
            amount: Value(receipt.amount.value),
            isActive: const Value(1),
          ),
        );
      }
      return saleId;
    });
  }

  // Search, Filter, and Sort operations

  /// Search for people by name, email, or phone
  /// Returns all people matching the search term in any searchable field
  Future<List<PeopleData>> searchPeople(String searchTerm) async {
    final lowerTerm = searchTerm.toLowerCase();
    final allPeople = await select(people).get();

    return allPeople.where((person) {
      return person.name.toLowerCase().contains(lowerTerm) ||
          (person.email?.toLowerCase().contains(lowerTerm) ?? false) ||
          (person.phone?.toLowerCase().contains(lowerTerm) ?? false) ||
          (person.address?.toLowerCase().contains(lowerTerm) ?? false);
    }).toList();
  }

  /// Search for products by name or description
  /// Returns all products matching the search term
  Future<List<Product>> searchProducts(String searchTerm) async {
    final lowerTerm = searchTerm.toLowerCase();
    final allProducts = await select(products).get();

    return allProducts.where((product) {
      return product.name.toLowerCase().contains(lowerTerm) ||
          (product.description?.toLowerCase().contains(lowerTerm) ?? false) ||
          (product.category?.toLowerCase().contains(lowerTerm) ?? false);
    }).toList();
  }

  /// Search for sales by invoice number or customer name
  /// Returns all sales matching the search term
  Future<List<Map<String, dynamic>>> searchSales(String searchTerm) async {
    final lowerTerm = searchTerm.toLowerCase();
    final allSales = await select(sales).get();

    List<Map<String, dynamic>> results = [];
    for (var sale in allSales) {
      if (sale.invoiceNumber.toLowerCase().contains(lowerTerm)) {
        final person = await getPersonById(sale.personId);
        results.add({
          'sale': sale,
          'customerName': person?.name ?? 'Unknown',
        });
      } else {
        final person = await getPersonById(sale.personId);
        if ((person?.name ?? '').toLowerCase().contains(lowerTerm)) {
          results.add({
            'sale': sale,
            'customerName': person?.name ?? 'Unknown',
          });
        }
      }
    }

    return results;
  }

  /// Filter people by type (CUSTOMER or SUPPLIER)
  Future<List<PeopleData>> filterPeopleByType(String type) async {
    return await (select(people)
          ..where((p) => p.type.equals(type) & p.isDeleted.equals(0)))
        .get();
  }

  /// Filter sales by status (NORMAL or VOID)
  Future<List<Sale>> filterSalesByStatus(String status) async {
    return await (select(sales)
          ..where((s) => s.status.equals(status) & s.isDeleted.equals(0)))
        .get();
  }

  /// Filter products by stock tracking status
  Future<List<Product>> filterProductsByStockTracking(bool trackStock) async {
    return await (select(products)
          ..where(
              (p) => p.trackStock.equals(trackStock) & p.isDeleted.equals(0)))
        .get();
  }

  /// Filter expenses by category
  Future<List<Expense>> filterExpensesByCategory(String category) async {
    return await (select(expenses)
          ..where((e) => e.category.equals(category) & e.isDeleted.equals(0)))
        .get();
  }

  /// Sort people by name (ascending or descending)
  Future<List<PeopleData>> sortPeopleByName({bool ascending = true}) async {
    return await (select(people)
          ..where((p) => p.isDeleted.equals(0))
          ..orderBy([
            (p) =>
                ascending ? OrderingTerm.asc(p.name) : OrderingTerm.desc(p.name)
          ]))
        .get();
  }

  /// Sort products by price (ascending or descending)
  Future<List<Product>> sortProductsByPrice({bool ascending = true}) async {
    return await (select(products)
          ..where((p) => p.isDeleted.equals(0))
          ..orderBy([
            (p) => ascending
                ? OrderingTerm.asc(p.price)
                : OrderingTerm.desc(p.price)
          ]))
        .get();
  }

  /// Sort sales by date (ascending or descending)
  Future<List<Sale>> sortSalesByDate({bool ascending = true}) async {
    return await (select(sales)
          ..where((s) => s.isDeleted.equals(0))
          ..orderBy([
            (s) =>
                ascending ? OrderingTerm.asc(s.date) : OrderingTerm.desc(s.date)
          ]))
        .get();
  }

  /// Sort sales by total amount (ascending or descending)
  Future<List<Sale>> sortSalesByTotal({bool ascending = true}) async {
    return await (select(sales)
          ..where((s) => s.isDeleted.equals(0))
          ..orderBy([
            (s) => ascending
                ? OrderingTerm.asc(s.total)
                : OrderingTerm.desc(s.total)
          ]))
        .get();
  }

  /// Sort products by stock level (ascending or descending)
  Future<List<Product>> sortProductsByStock({bool ascending = true}) async {
    return await (select(products)
          ..where((p) => p.isDeleted.equals(0) & p.trackStock.equals(true))
          ..orderBy([
            (p) => ascending
                ? OrderingTerm.asc(p.currentStock)
                : OrderingTerm.desc(p.currentStock)
          ]))
        .get();
  }

  /// Sort expenses by amount (ascending or descending)
  Future<List<Expense>> sortExpensesByAmount({bool ascending = true}) async {
    return await (select(expenses)
          ..where((e) => e.isDeleted.equals(0))
          ..orderBy([
            (e) => ascending
                ? OrderingTerm.asc(e.amount)
                : OrderingTerm.desc(e.amount)
          ]))
        .get();
  }

  /// Delete all data from all tables (for app reset)
  Future<void> deleteAllData() async {
    await ensureLiteSyncTables();
    await transaction(() async {
      await customStatement('DELETE FROM lite_sync_events');
      await delete(allocations).go();
      await delete(stockAllocations).go();
      await delete(saleItems).go();
      await delete(sales).go();
      await delete(payments).go();
      await delete(productPurchases).go();
      await delete(products).go();
      await delete(expenses).go();
      await delete(expenseCategories).go();
      await delete(suppliers).go();
      await delete(financeAgreements).go();
      await delete(financePayments).go();
      await delete(people).go();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FINANCE MODULE — DB METHODS
  // ─────────────────────────────────────────────────────────────────────────

  /// Save a new agreement + its full payment schedule atomically.
  Future<int> saveFinanceAgreementWithSchedule(
    FinanceAgreementsCompanion agreement,
    List<FinancePaymentsCompanion> schedule,
  ) async {
    return transaction(() async {
      final id = await into(financeAgreements).insert(agreement);
      for (final row in schedule) {
        await into(financePayments).insert(
          row.copyWith(agreementId: Value(id)),
        );
      }
      return id;
    });
  }

  /// Load all non-deleted agreements, newest first.
  Future<List<FinanceAgreement>> getAllFinanceAgreements() =>
      (select(financeAgreements)
            ..where((t) => t.isDeleted.equals(0))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  /// Load a single agreement by id.
  Future<FinanceAgreement?> getFinanceAgreementById(int id) =>
      (select(financeAgreements)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Load the payment schedule for an agreement, ordered by payment number.
  Future<List<FinancePayment>> getFinancePayments(int agreementId) =>
      (select(financePayments)
            ..where((t) => t.agreementId.equals(agreementId))
            ..orderBy([(t) => OrderingTerm.asc(t.paymentNo)]))
          .get();

  /// Mark one payment as paid (or unpaid).
  Future<void> updateFinancePaymentPaid(
    int paymentId, {
    required bool paid,
    String? paidDate,
  }) =>
      (update(financePayments)..where((t) => t.id.equals(paymentId))).write(
        FinancePaymentsCompanion(
          paid: Value(paid ? 1 : 0),
          paidDate: Value(paidDate),
        ),
      );

  /// Mark a batch of payments as paid in one transaction.
  Future<void> bulkMarkFinancePaymentsPaid(
    List<int> paymentIds,
    String paidDate,
  ) =>
      transaction(() async {
        for (final id in paymentIds) {
          await updateFinancePaymentPaid(id, paid: true, paidDate: paidDate);
        }
      });

  /// Update agreement status ('ACTIVE' | 'COMPLETE' | 'OVERDUE').
  Future<void> updateFinanceAgreementStatus(int id, String status) =>
      (update(financeAgreements)..where((t) => t.id.equals(id))).write(
        FinanceAgreementsCompanion(status: Value(status)),
      );

  /// Early settlement: delete unpaid scheduled rows, append settlement row,
  /// mark agreement COMPLETE — all in one transaction.
  Future<void> settleFinanceAgreementEarly(
    int agreementId,
    FinancePaymentsCompanion settlementRow,
  ) =>
      transaction(() async {
        // Remove pending scheduled rows
        await (delete(financePayments)
              ..where(
                (t) =>
                    t.agreementId.equals(agreementId) &
                    t.paid.equals(0) &
                    t.rowType.equals('SCHEDULED'),
              ))
            .go();

        // Insert the settlement row
        await into(financePayments).insert(
          settlementRow.copyWith(agreementId: Value(agreementId)),
        );

        // Mark agreement complete
        await updateFinanceAgreementStatus(agreementId, 'COMPLETE');
      });

  /// Soft-delete an agreement and hard-delete its payment rows.
  Future<void> deleteFinanceAgreement(int id) => transaction(() async {
        await _deleteFinanceSettlementReceiptsForAgreement(id);
        await (delete(financePayments)..where((t) => t.agreementId.equals(id)))
            .go();
        await (delete(financeSaleLinks)..where((t) => t.agreementId.equals(id)))
            .go();
        await (update(financeAgreements)..where((t) => t.id.equals(id))).write(
          const FinanceAgreementsCompanion(isDeleted: Value(1)),
        );
      });

  /// Update editable agreement fields (re-saves schedule too).
  Future<void> updateFinanceAgreementWithSchedule(
    FinanceAgreementsCompanion agreement,
    List<FinancePaymentsCompanion> schedule,
  ) =>
      transaction(() async {
        await (update(financeAgreements)
              ..where((t) => t.id.equals(agreement.id.value)))
            .write(agreement);
        // Replace schedule
        await (delete(financePayments)
              ..where((t) => t.agreementId.equals(agreement.id.value)))
            .go();
        for (final row in schedule) {
          await into(financePayments).insert(
            row.copyWith(agreementId: agreement.id),
          );
        }
      });

  // ── Finance source / sale links ───────────────────────────────────────────

  /// Save agreement + schedule + optional sale links atomically.
  Future<int> saveFinanceAgreementFull(
    FinanceAgreementsCompanion agreement,
    List<FinancePaymentsCompanion> schedule,
    List<int> linkedSaleIds,
  ) =>
      transaction(() async {
        final id = await into(financeAgreements).insert(agreement);
        for (final row in schedule) {
          await into(financePayments).insert(
            row.copyWith(agreementId: Value(id)),
          );
        }
        for (final saleId in linkedSaleIds) {
          await into(financeSaleLinks).insert(
            FinanceSaleLinksCompanion(
              agreementId: Value(id),
              saleId: Value(saleId),
            ),
          );
        }
        await _createFinanceSettlementReceipts(
          agreementId: id,
          agreement: agreement,
          linkedSaleIds: linkedSaleIds,
        );
        return id;
      });

  /// Update agreement + schedule + sale links atomically.
  Future<void> updateFinanceAgreementFull(
    FinanceAgreementsCompanion agreement,
    List<FinancePaymentsCompanion> schedule,
    List<int> linkedSaleIds,
  ) =>
      transaction(() async {
        final id = agreement.id.value;
        await _deleteFinanceSettlementReceiptsForAgreement(id);
        await (update(financeAgreements)..where((t) => t.id.equals(id)))
            .write(agreement);
        await (delete(financePayments)..where((t) => t.agreementId.equals(id)))
            .go();
        for (final row in schedule) {
          await into(financePayments).insert(
            row.copyWith(agreementId: Value(id)),
          );
        }
        await (delete(financeSaleLinks)..where((t) => t.agreementId.equals(id)))
            .go();
        for (final saleId in linkedSaleIds) {
          await into(financeSaleLinks).insert(
            FinanceSaleLinksCompanion(
              agreementId: Value(id),
              saleId: Value(saleId),
            ),
          );
        }
        await _createFinanceSettlementReceipts(
          agreementId: id,
          agreement: agreement,
          linkedSaleIds: linkedSaleIds,
        );
      });

  /// Get sale IDs linked to a finance agreement.
  Future<List<int>> getFinanceSaleLinks(int agreementId) async {
    final rows = await (select(financeSaleLinks)
          ..where((t) => t.agreementId.equals(agreementId)))
        .get();
    return rows.map((r) => r.saleId).toList();
  }

  /// Get invoice settlement amounts created by a finance agreement.
  Future<Map<int, double>> getFinanceSettlementSaleAmounts(
    int agreementId,
  ) async {
    final reference = financeSettlementReference(agreementId);
    final settlementPayments = await (select(payments)
          ..where(
            (p) =>
                p.receiptType.equals(financeSettlementReceiptType) &
                p.reference.equals(reference) &
                p.isDeleted.equals(0),
          ))
        .get();

    final result = <int, double>{};
    for (final payment in settlementPayments) {
      final rows = await (select(allocations)
            ..where(
              (a) => a.paymentId.equals(payment.id) & a.isActive.equals(1),
            ))
          .get();
      for (final row in rows) {
        if (row.allocatedItemType == 'SALE' && row.allocatedItemId > 0) {
          result[row.allocatedItemId] =
              (result[row.allocatedItemId] ?? 0) + row.amount;
        }
      }
    }
    return result;
  }

  Future<void> _deleteFinanceSettlementReceiptsForAgreement(
    int agreementId,
  ) async {
    final reference = financeSettlementReference(agreementId);
    final settlementPayments = await (select(payments)
          ..where(
            (p) =>
                p.receiptType.equals(financeSettlementReceiptType) &
                p.reference.equals(reference) &
                p.isDeleted.equals(0),
          ))
        .get();

    for (final payment in settlementPayments) {
      await _deletePaymentWithAllocations(payment.id);
    }
  }

  Future<void> _createFinanceSettlementReceipts({
    required int agreementId,
    required FinanceAgreementsCompanion agreement,
    required List<int> linkedSaleIds,
  }) async {
    if (linkedSaleIds.isEmpty) return;

    final source =
        agreement.financeSource.present ? agreement.financeSource.value : '';
    if (source == 'standalone') return;

    if (!agreement.linkedPersonId.present || !agreement.agreementDate.present) {
      return;
    }
    final personId = agreement.linkedPersonId.value;
    if (personId == null) return;

    final reference = financeSettlementReference(agreementId);
    final date = agreement.agreementDate.value;

    for (final saleId in linkedSaleIds) {
      final sale = await (select(sales)..where((s) => s.id.equals(saleId)))
          .getSingleOrNull();
      if (sale == null) {
        throw Exception('Sale $saleId could not be found for finance receipt');
      }
      if (sale.personId != personId) {
        throw Exception(
          'Sale ${sale.invoiceNumber} does not belong to the selected customer',
        );
      }

      final saleAllocations = await (select(allocations)
            ..where((a) =>
                a.allocatedItemId.equals(saleId) &
                a.allocatedItemType.equals('SALE') &
                a.isActive.equals(1)))
          .get();
      final allocated =
          saleAllocations.fold(0.0, (sum, row) => sum + row.amount);
      final outstanding = sale.total - allocated;
      if (outstanding <= 0.01) continue;

      await _insertPaymentWithAllocations(
        PaymentsCompanion(
          personId: Value(personId),
          date: Value(date),
          amount: Value(outstanding),
          receiptType: const Value(financeSettlementReceiptType),
          paymentMethod: const Value(financeSettlementReceiptType),
          reference: Value(reference),
          isDeleted: const Value(0),
        ),
        [
          AllocationRecord(
            itemId: 'invoice_$saleId',
            saleId: saleId,
            amount: outstanding,
          ),
        ],
      );
    }
  }

  /// Get all active (non-deleted, non-complete) finance agreements
  /// linked to a specific customer (People.id).
  Future<List<FinanceAgreement>> getActiveFinanceAgreementsForCustomer(
          int personId) =>
      (select(financeAgreements)
            ..where((t) =>
                t.linkedPersonId.equals(personId) &
                t.isDeleted.equals(0) &
                t.status.isNotIn(['COMPLETE'])))
          .get();

  /// Get all finance agreements (including complete) for a customer.
  Future<List<FinanceAgreement>> getAllFinanceAgreementsForCustomer(
          int personId) =>
      (select(financeAgreements)
            ..where((t) =>
                t.linkedPersonId.equals(personId) & t.isDeleted.equals(0))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  /// Get the set of sale IDs that are linked to any active finance agreement
  /// for a customer — used to exclude them from the trade outstanding matrix.
  Future<Set<int>> getFinancedSaleIdsForCustomer(int personId) async {
    final agreements = await getActiveFinanceAgreementsForCustomer(personId);
    final result = <int>{};
    for (final a in agreements) {
      final ids = await getFinanceSaleLinks(a.id);
      result.addAll(ids);
    }
    return result;
  }
}

class LiteSyncEvent {
  const LiteSyncEvent({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payloadJson,
    required this.createdAt,
    required this.status,
    this.syncedAt,
    this.error,
  });

  final int id;
  final String entityType;
  final int entityId;
  final String operation;
  final String payloadJson;
  final String createdAt;
  final String status;
  final String? syncedAt;
  final String? error;

  factory LiteSyncEvent.fromData(Map<String, dynamic> data) {
    return LiteSyncEvent(
      id: data['id'] as int,
      entityType: data['entity_type'] as String,
      entityId: data['entity_id'] as int,
      operation: data['operation'] as String,
      payloadJson: data['payload_json'] as String,
      createdAt: data['created_at'] as String,
      status: data['status'] as String,
      syncedAt: data['synced_at'] as String?,
      error: data['error'] as String?,
    );
  }
}
