import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';

class CsvService {
  final AppDatabase _db = AppDatabase.instance;

  // ==================== CUSTOMERS ====================

  String generateCustomerTemplate() {
    const headers = [
      'name',
      'telephone',
      'email',
      'location',
      'notes',
      'startBalance',
      'startDate',
      'creditLimit',
      'paymentTermsDays',
    ];
    const example = [
      'John Smith',
      '07123456789',
      'john@example.com',
      'London',
      'VIP customer',
      '500.00',
      '2025-11-01',
      '1000.00',
      '14',
    ];

    return ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportCustomers() async {
    final customers = await _db.getAllPeople();
    final customerList = customers
        .where((p) => p.type == 'CUSTOMER' && p.isDeleted == 0)
        .toList();

    final rows = [
      [
        'name',
        'telephone',
        'email',
        'location',
        'notes',
        'startBalance',
        'startDate',
        'creditLimit',
        'paymentTermsDays',
      ],
      ...customerList.map((c) => [
            c.name,
            c.phone ?? '',
            c.email ?? '',
            c.address ?? '',
            c.notes ?? '',
            c.startBalance.toString(),
            c.startDate ?? '',
            c.creditLimit.toString(),
            c.paymentTermsDays.toString(),
          ]),
    ];

    return ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importCustomers(String csvContent) async {
    try {
      final rows = CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty || row.length < headers.length ||
              row.every((element) => element.toString().trim().isEmpty)) continue;

          final nameIdx = headers.indexOf('name');
          if (nameIdx == -1 || row[nameIdx].toString().trim().isEmpty) continue;
          final name = row[nameIdx].toString().trim();

          // Support both 'telephone' and 'phone' for backwards compatibility
          final phoneIdx = _getIdx(headers, ['telephone', 'phone']);
          final phone = phoneIdx >= 0 && row.length > phoneIdx
              ? row[phoneIdx].toString().trim()
              : null;

          // Support both 'location' and 'address' for backwards compatibility
          final locationIdx = _getIdx(headers, ['location', 'address']);
          final location = locationIdx >= 0 && row.length > locationIdx
              ? row[locationIdx].toString().trim()
              : null;

          final emailIdx = headers.indexOf('email');
          final email = emailIdx >= 0 && row.length > emailIdx ? row[emailIdx].toString().trim() : null;

          final notesIdx = headers.indexOf('notes');
          final notes = notesIdx >= 0 && row.length > notesIdx ? row[notesIdx].toString().trim() : null;

          final balIdx = headers.indexOf('startbalance');
          final startBalance = balIdx >= 0 && row.length > balIdx ? double.tryParse(row[balIdx].toString()) ?? 0.0 : 0.0;

          final dateIdx = headers.indexOf('startdate');
          final startDate = dateIdx >= 0 && row.length > dateIdx ? row[dateIdx].toString().trim() : DateTime.now().toIso8601String().split('T')[0];

          final limitIdx = headers.indexOf('creditlimit');
          final creditLimit = limitIdx >= 0 && row.length > limitIdx ? double.tryParse(row[limitIdx].toString()) ?? 0.0 : 0.0;

          final termsIdx = _getIdx(headers, ['paymenttermsdays', 'paymentterms']);
          final paymentTerms = termsIdx >= 0 && row.length > termsIdx ? int.tryParse(row[termsIdx].toString()) ?? 0 : 0;

          await _db.addPerson(PeopleCompanion(
            name: drift.Value(name),
            phone: drift.Value(phone?.isEmpty ?? true ? null : phone),
            email: drift.Value(email?.isEmpty ?? true ? null : email),
            address: drift.Value(location?.isEmpty ?? true ? null : location),
            notes: drift.Value(notes?.isEmpty ?? true ? null : notes),
            type: const drift.Value('CUSTOMER'),
            startBalance: drift.Value(startBalance),
            startDate: drift.Value(startDate.isEmpty ? null : startDate),
            creditLimit: drift.Value(creditLimit),
            paymentTermsDays: drift.Value(paymentTerms),
          ));

          imported++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }

  int _getIdx(List<String> headers, List<String> candidates) {
    for (final c in candidates) {
      final idx = headers.indexOf(c);
      if (idx != -1) return idx;
    }
    return -1;
  }

  // ==================== SUPPLIERS ====================

  String generateSupplierTemplate() {
    const headers = [
      'name',
      'telephone',
      'email',
      'location',
      'notes',
      'startBalance',
      'startDate',
      'creditLimit',
      'paymentTermsDays',
    ];
    const example = [
      'ABC Supplies Ltd',
      '02012345678',
      'supplier@example.com',
      'Manchester',
      'Main supplier',
      '0.00',
      '2025-11-01',
      '10000.00',
      '30',
    ];

    return ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportSuppliers() async {
    final suppliers = await _db.getAllPeople();
    final supplierList = suppliers
        .where((p) => p.type == 'SUPPLIER' && p.isDeleted == 0)
        .toList();

    final rows = [
      [
        'name',
        'telephone',
        'email',
        'location',
        'notes',
        'startBalance',
        'startDate',
        'creditLimit',
        'paymentTermsDays',
      ],
      ...supplierList.map((s) => [
            s.name,
            s.phone ?? '',
            s.email ?? '',
            s.address ?? '',
            s.notes ?? '',
            s.startBalance.toString(),
            s.startDate ?? '',
            s.creditLimit.toString(),
            s.paymentTermsDays.toString(),
          ]),
    ];

    return ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importSuppliers(String csvContent) async {
    try {
      final rows = CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty || row.length < headers.length ||
              row.every((element) => element.toString().trim().isEmpty)) continue;

          final nameIdx = headers.indexOf('name');
          if (nameIdx == -1 || row[nameIdx].toString().trim().isEmpty) continue;
          final name = row[nameIdx].toString().trim();

          final phoneIdx = _getIdx(headers, ['telephone', 'phone']);
          final phone = phoneIdx >= 0 && row.length > phoneIdx
              ? row[phoneIdx].toString().trim()
              : null;

          final locationIdx = _getIdx(headers, ['location', 'address']);
          final location = locationIdx >= 0 && row.length > locationIdx
              ? row[locationIdx].toString().trim()
              : null;

          final emailIdx = headers.indexOf('email');
          final email = emailIdx >= 0 && row.length > emailIdx ? row[emailIdx].toString().trim() : null;

          final notesIdx = headers.indexOf('notes');
          final notes = notesIdx >= 0 && row.length > notesIdx ? row[notesIdx].toString().trim() : null;

          final balIdx = headers.indexOf('startbalance');
          final startBalance = balIdx >= 0 && row.length > balIdx ? double.tryParse(row[balIdx].toString()) ?? 0.0 : 0.0;

          final dateIdx = headers.indexOf('startdate');
          final startDate = dateIdx >= 0 && row.length > dateIdx ? row[dateIdx].toString().trim() : DateTime.now().toIso8601String().split('T')[0];

          final limitIdx = headers.indexOf('creditlimit');
          final creditLimit = limitIdx >= 0 && row.length > limitIdx ? double.tryParse(row[limitIdx].toString()) ?? 0.0 : 0.0;

          final termsIdx = _getIdx(headers, ['paymenttermsdays', 'paymentterms']);
          final paymentTerms = termsIdx >= 0 && row.length > termsIdx ? int.tryParse(row[termsIdx].toString()) ?? 0 : 0;

          await _db.addSupplier(SuppliersCompanion(
            name: drift.Value(name),
            phone: drift.Value(phone?.isEmpty ?? true ? null : phone),
            email: drift.Value(email?.isEmpty ?? true ? null : email),
            address: drift.Value(location?.isEmpty ?? true ? null : location),
            notes: drift.Value(notes?.isEmpty ?? true ? null : notes),
            type: const drift.Value('SUPPLIER'),
            openingBalance: drift.Value(startBalance),
            startDate: drift.Value(startDate.isEmpty ? null : startDate),
            creditLimit: drift.Value(creditLimit),
            paymentTermsDays: drift.Value(paymentTerms),
            createdAt: drift.Value(DateTime.now().toIso8601String()),
          ));

          imported++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }

  // ==================== PRODUCTS ====================

  String generateProductTemplate() {
    const headers = [
      'name',
      'description',
      'price',
      'category',
      'trackStock',
      'currentStock',
      'avgCost',
      'reorderLevel'
    ];
    const example = [
      'Widget Pro',
      'High quality widget',
      '29.99',
      'Electronics',
      'true',
      '100',
      '15.50',
      '20'
    ];

    return ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportProducts() async {
    final products = await _db.getAllProducts();
    final productList = products.where((p) => p.isDeleted == 0).toList();

    final rows = [
      [
        'name',
        'description',
        'price',
        'category',
        'trackStock',
        'currentStock',
        'avgCost',
        'reorderLevel'
      ],
      ...productList.map((p) => [
            p.name,
            p.description ?? '',
            p.price.toString(),
            p.category ?? '',
            p.trackStock ? 'true' : 'false',
            p.currentStock == p.currentStock.truncateToDouble()
                ? p.currentStock.toInt().toString()
                : p.currentStock.toString(),
            p.avgCost == p.avgCost.truncateToDouble()
                ? p.avgCost.toInt().toString()
                : p.avgCost.toString(),
            p.reorderLevel == p.reorderLevel.truncateToDouble()
                ? p.reorderLevel.toInt().toString()
                : p.reorderLevel.toString(),
          ]),
    ];

    return ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importProducts(String csvContent) async {
    try {
      final rows = CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      for (int i = 1; i < rows.length; i++) {
        try {
          final row = rows[i];
          if (row.isEmpty || row.length < headers.length ||
              row.every((element) => element.toString().trim().isEmpty)) continue;

          final nameIdx = headers.indexOf('name');
          if (nameIdx == -1 || row[nameIdx].toString().trim().isEmpty) continue;
          final name = row[nameIdx].toString().trim();

          final descIdx = headers.indexOf('description');
          final description = descIdx >= 0 ? row[descIdx].toString().trim() : null;

          final priceIdx = headers.indexOf('price');
          final price = priceIdx >= 0 ? double.tryParse(row[priceIdx].toString()) ?? 0.0 : 0.0;

          final catIdx = headers.indexOf('category');
          final category = catIdx >= 0 ? row[catIdx].toString().trim() : null;

          final trackIdx = headers.indexOf('trackstock');
          final trackStock = trackIdx >= 0 && row[trackIdx].toString().toLowerCase() == 'true';

          final stockIdx = headers.indexOf('currentstock');
          final currentStock = stockIdx >= 0 ? double.tryParse(row[stockIdx].toString()) ?? 0.0 : 0.0;

          final costIdx = headers.indexOf('avgcost');
          final avgCost = costIdx >= 0 ? double.tryParse(row[costIdx].toString()) ?? 0.0 : 0.0;

          final reorderIdx = headers.indexOf('reorderlevel');
          final reorderLevel = reorderIdx >= 0 ? double.tryParse(row[reorderIdx].toString()) ?? 10.0 : 10.0;

          await _db.addProduct(ProductsCompanion(
            name: drift.Value(name),
            description:
                drift.Value(description?.isEmpty ?? true ? null : description),
            price: drift.Value(price),
            category: drift.Value(category?.isEmpty ?? true ? null : category),
            trackStock: drift.Value(trackStock),
            currentStock: drift.Value(currentStock),
            avgCost: drift.Value(avgCost),
            reorderLevel: drift.Value(reorderLevel),
          ));

          imported++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 1}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }

  // ==================== SALES ====================

  String generateSalesTemplate() {
    const headers = [
      'invoiceNumber',
      'date',
      'dueDate',
      'saleType',
      'customerName',
      'productName',
      'quantity',
      'pricePerUnit',
      'status',
      'notes',
    ];
    const example = [
      '1',
      '2025-11-15',
      '2025-12-15',
      'CREDIT',
      'John Smith',
      'Widget A',
      '2',
      '149.99',
      'NORMAL',
      'Rush order',
    ];

    return ListToCsvConverter().convert([headers, example]);
  }

  Future<String> exportSales() async {
    final sales = await _db.getAllSales();
    final people = await _db.getAllPeople();
    final products = await _db.getAllProducts();
    final salesList = sales.where((s) => s.isDeleted == 0).toList();

    final rows = <List<dynamic>>[
      [
        'invoiceNumber',
        'date',
        'dueDate',
        'saleType',
        'customerName',
        'productName',
        'quantity',
        'pricePerUnit',
        'status',
        'notes',
      ],
    ];

    for (var sale in salesList) {
      final customerList = people.where((p) => p.id == sale.personId).toList();
      if (customerList.isEmpty) continue;
      final customer = customerList.first;

      final saleItems = await _db.getSaleItems(sale.id);

      if (saleItems.isEmpty) {
        rows.add([
          sale.invoiceNumber,
          sale.date,
          sale.dueDate ?? '',
          sale.saleType,
          customer.name,
          '',
          '',
          '',
          sale.status,
          sale.notes ?? '',
        ]);
      } else {
        for (var item in saleItems) {
          final productList =
              products.where((p) => p.id == item.productId).toList();
          final productName =
              productList.isEmpty ? 'Unknown Product' : productList.first.name;
          final qty = item.quantity == item.quantity.truncateToDouble()
              ? item.quantity.toInt().toString()
              : item.quantity.toString();

          rows.add([
            sale.invoiceNumber,
            sale.date,
            sale.dueDate ?? '',
            sale.saleType,
            customer.name,
            productName,
            qty,
            item.price.toString(),
            sale.status,
            sale.notes ?? '',
          ]);
        }
      }
    }

    return ListToCsvConverter().convert(rows);
  }

  Future<Map<String, dynamic>> importSales(String csvContent) async {
    try {
      final rows = CsvToListConverter().convert(csvContent);
      if (rows.isEmpty) return {'success': false, 'message': 'Empty CSV file'};

      final headers = rows[0].map((e) => e.toString().toLowerCase()).toList();
      int imported = 0;
      int failed = 0;
      final errors = <String>[];

      final people = await _db.getAllPeople();
      final products = await _db.getAllProducts();

      // Group rows by invoice number to handle multi-line invoices
      final Map<String, List<int>> invoiceRows = {};
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i];
        if (row.isEmpty || row.length < 3) continue;

        final invoiceNumber = headers.contains('invoicenumber') &&
                row.length > headers.indexOf('invoicenumber')
            ? row[headers.indexOf('invoicenumber')].toString().trim()
            : 'INV-${DateTime.now().millisecondsSinceEpoch}-$i';

        invoiceRows.putIfAbsent(invoiceNumber, () => []).add(i);
      }

      // Process each invoice
      for (final entry in invoiceRows.entries) {
        try {
          final invoiceNumber = entry.key;
          final rowIndices = entry.value;
          final firstRow = rows[rowIndices.first];

          final date = headers.contains('date') &&
                  firstRow.length > headers.indexOf('date')
              ? firstRow[headers.indexOf('date')].toString().trim()
              : DateTime.now().toIso8601String().split('T')[0];

          final customerName = headers.contains('customername') &&
                  firstRow.length > headers.indexOf('customername')
              ? firstRow[headers.indexOf('customername')].toString().trim()
              : '';

          if (customerName.isEmpty) {
            failed++;
            errors.add('Invoice $invoiceNumber: Customer name is required');
            continue;
          }

          // Find or create customer
          PeopleData customer;
          try {
            customer = people.firstWhere(
              (p) =>
                  p.name.toLowerCase() == customerName.toLowerCase() &&
                  p.type == 'CUSTOMER',
            );
          } catch (e) {
            // Customer doesn't exist, create it
            final customerId = await _db.addPerson(PeopleCompanion(
              name: drift.Value(customerName),
              type: const drift.Value('CUSTOMER'),
            ));

            // Reload people to get the new customer
            final allPeople = await _db.getAllPeople();
            customer = allPeople.firstWhere((p) => p.id == customerId);
          }

          final importedStatus = headers.contains('status') &&
                  firstRow.length > headers.indexOf('status')
              ? firstRow[headers.indexOf('status')]
                  .toString()
                  .trim()
                  .toUpperCase()
              : 'NORMAL';

          final saleType = headers.contains('saletype') &&
                  firstRow.length > headers.indexOf('saletype')
              ? firstRow[headers.indexOf('saletype')]
                  .toString()
                  .trim()
                  .toUpperCase()
              : 'CREDIT';
          final normalizedSaleType = saleType == 'CASH' ? 'CASH' : 'CREDIT';
          final status = importedStatus == 'VOID'
              ? 'VOID'
              : normalizedSaleType == 'CASH'
                  ? 'PAID'
                  : importedStatus;

          final dueDate = headers.contains('duedate') &&
                  firstRow.length > headers.indexOf('duedate')
              ? firstRow[headers.indexOf('duedate')].toString().trim()
              : DateTime.tryParse(date)
                  ?.add(Duration(days: customer.paymentTermsDays))
                  .toIso8601String()
                  .split('T')[0];

          final notes = headers.contains('notes') &&
                  firstRow.length > headers.indexOf('notes')
              ? firstRow[headers.indexOf('notes')].toString().trim()
              : null;

          // Collect all items for this invoice
          final List<Map<String, dynamic>> items = [];
          double totalAmount = 0.0;

          for (final rowIndex in rowIndices) {
            final row = rows[rowIndex];

            final productName = headers.contains('productname') &&
                    row.length > headers.indexOf('productname')
                ? row[headers.indexOf('productname')].toString().trim()
                : '';

            if (productName.isEmpty) {
              errors.add(
                  'Invoice $invoiceNumber, Row ${rowIndex + 1}: Product name is required');
              continue;
            }

            final quantity = headers.contains('quantity') &&
                    row.length > headers.indexOf('quantity')
                ? double.tryParse(
                        row[headers.indexOf('quantity')].toString()) ??
                    1.0
                : 1.0;

            final pricePerUnit = headers.contains('priceperunit') &&
                    row.length > headers.indexOf('priceperunit')
                ? double.tryParse(
                        row[headers.indexOf('priceperunit')].toString()) ??
                    0.0
                : 0.0;

            // Find or create product
            Product product;
            try {
              product = products.firstWhere(
                (p) => p.name.toLowerCase() == productName.toLowerCase(),
              );
            } catch (e) {
              // Product doesn't exist, create it
              final productId = await _db.addProduct(ProductsCompanion(
                name: drift.Value(productName),
                price: drift.Value(pricePerUnit),
                trackStock: const drift.Value(false),
                currentStock: const drift.Value(0.0),
                avgCost: const drift.Value(0.0),
              ));

              // Reload products to get the new one
              final allProducts = await _db.getAllProducts();
              product = allProducts.firstWhere((p) => p.id == productId);

              // Add to local products list for subsequent rows
              products.add(product);
            }

            final lineTotal = quantity * pricePerUnit;
            totalAmount += lineTotal;

            items.add({
              'product': product,
              'quantity': quantity,
              'pricePerUnit': pricePerUnit,
              'total': lineTotal,
            });
          }

          if (items.isEmpty) {
            failed++;
            errors.add('Invoice $invoiceNumber: No valid items found');
            continue;
          }

          // Create sale with items using the transaction method
          // Skip stock validation for imports (historical data)
          await _db.createSaleWithItems(
            SalesCompanion(
              personId: drift.Value(customer.id),
              invoiceNumber: drift.Value(invoiceNumber),
              date: drift.Value(date),
              dueDate: drift.Value(dueDate?.isEmpty ?? true ? null : dueDate),
              saleType: drift.Value(normalizedSaleType),
              total: drift.Value(totalAmount),
              status: drift.Value(status),
              notes: drift.Value(notes?.isEmpty ?? true ? null : notes),
            ),
            items,
            skipStockValidation: true,
            receipt: normalizedSaleType == 'CASH' && status != 'VOID'
                ? PaymentsCompanion(
                    personId: drift.Value(customer.id),
                    date: drift.Value(date),
                    amount: drift.Value(totalAmount),
                    receiptType: const drift.Value('CASH_SALE'),
                    paymentMethod: const drift.Value('CASH_SALE'),
                    reference: drift.Value('Payment for INV-$invoiceNumber'),
                    isDeleted: const drift.Value(0),
                  )
                : null,
          );

          imported++;
        } catch (e) {
          failed++;
          errors.add('Invoice ${entry.key}: $e');
        }
      }

      return {
        'success': true,
        'imported': imported,
        'failed': failed,
        'errors': errors,
      };
    } catch (e) {
      return {'success': false, 'message': 'Error parsing CSV: $e'};
    }
  }
}
