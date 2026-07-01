import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/payment_allocation_model.dart';
import '../features/customers/models/customer_board_models.dart';

/// Pure data logic for the Customer Control Board.
/// No Flutter/UI imports — safe to test independently.
class CustomerService {
  final AppDatabase _db;

  CustomerService(this._db);

  // ── Date helpers ────────────────────────────────────────────────────────────

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static DateTime? parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }

  static String formatCurrency(double amount) =>
      '£${amount.toStringAsFixed(0)}';

  static String matrixColumnLabel(Product? product) {
    final name = product?.name.trim();
    if (name == null || name.isEmpty) return 'PRODUCT';
    return name.toUpperCase();
  }

  // ── Risk assessment ─────────────────────────────────────────────────────────

  static CustomerRisk riskFor(
    PeopleData customer,
    double total,
    int daysOverdue,
  ) {
    if (total <= 0.01) return CustomerRisk.clear;
    if (customer.creditLimit > 0 && total > customer.creditLimit) {
      return CustomerRisk.overLimit;
    }
    if (daysOverdue > 30) return CustomerRisk.overdue;
    return CustomerRisk.onTrack;
  }

  // ── Due date helpers ─────────────────────────────────────────────────────────

  static DateTime? oldestOutstandingDate(List<OutstandingItem> items) {
    DateTime? oldest;
    for (final item in items) {
      final date = parseDate(item.date);
      if (date == null) continue;
      if (oldest == null || date.isBefore(oldest)) oldest = date;
    }
    return oldest;
  }

  static DateTime? oldestOutstandingDueDate(
    List<OutstandingItem> items,
    PeopleData customer,
  ) {
    DateTime? oldest;
    for (final item in items) {
      final itemDate = parseDate(item.date);
      final dueDate = parseDate(item.dueDate) ??
          (itemDate == null
              ? null
              : dateOnly(itemDate)
                  .add(Duration(days: customer.paymentTermsDays)));
      if (dueDate == null) continue;
      if (oldest == null || dueDate.isBefore(oldest)) oldest = dueDate;
    }
    return oldest;
  }

  // ── Matrix builder ───────────────────────────────────────────────────────────

  Future<CustomerMatrix> buildCustomerMatrix(
    List<OutstandingItem> outstandingItems,
  ) async {
    final productCache = <int, Product>{};
    final columns = <String>[];
    final rows = <CustomerMatrixRow>[];

    void addColumn(String col) {
      if (!columns.contains(col)) columns.add(col);
    }

    for (var i = 0; i < outstandingItems.length; i++) {
      final item = outstandingItems[i];
      final values = <String, double>{};
      final date = parseDate(item.date) ?? DateTime.now();

      void addValue(String col, double value) {
        if (value <= 0.01) return;
        addColumn(col);
        values[col] = (values[col] ?? 0) + value;
      }

      if (item.type == 'opening' || item.saleId == null) {
        addValue('OPENING', item.outstandingAmount);
      } else {
        final sale = await _db.getSaleById(item.saleId!) as Sale?;
        final saleItems =
            (await _db.getSaleItems(item.saleId!)).cast<SaleItem>().toList();
        final itemTotal =
            saleItems.fold<double>(0, (sum, si) => sum + si.total);
        final ratio = itemTotal <= 0
            ? 1.0
            : (item.outstandingAmount / itemTotal).clamp(0.0, 1.0);

        if (saleItems.isEmpty) {
          addValue('UNALLOCATED', item.outstandingAmount);
        } else {
          for (final si in saleItems) {
            final product = productCache[si.productId] ??
                await _db.getProductById(si.productId);
            if (product != null) productCache[si.productId] = product;
            addValue(matrixColumnLabel(product), si.total * ratio);
          }
        }

        if (values.isEmpty && sale != null) {
          addValue('UNALLOCATED', item.outstandingAmount);
        }
      }

      rows.add(CustomerMatrixRow(
        label: 'W${i + 1}',
        reference: item.reference,
        date: date,
        dueDate: parseDate(item.dueDate),
        values: values,
      ));
    }

    final columnTotals = <String, double>{};
    for (final row in rows) {
      for (final entry in row.values.entries) {
        columnTotals[entry.key] = (columnTotals[entry.key] ?? 0) + entry.value;
      }
    }

    return CustomerMatrix(
      columns: columns,
      rows: rows,
      columnTotals: columnTotals,
      grandTotal: rows.fold(0.0, (sum, row) => sum + row.total),
    );
  }

  // ── Control row builder ──────────────────────────────────────────────────────

  Future<List<CustomerControlRow>> buildControlRows(
    List<PeopleData> customers, {
    String sortBy = 'Name',
  }) async {
    final rows = <CustomerControlRow>[];
    final today = dateOnly(DateTime.now());

    for (final customer in customers) {
      final outstandingItems =
          await _db.getOutstandingItemsForCustomer(customer.id);
      final matrix = await buildCustomerMatrix(outstandingItems);
      final total = matrix.grandTotal;
      final oldestDebtDate = oldestOutstandingDate(outstandingItems);
      final dueDate = oldestOutstandingDueDate(outstandingItems, customer);
      final daysOverdue =
          dueDate == null ? 0 : today.difference(dateOnly(dueDate)).inDays;
      final risk = riskFor(customer, total, daysOverdue);

      rows.add(CustomerControlRow(
        customer: customer,
        total: total,
        oldestDebtDate: oldestDebtDate,
        dueDate: dueDate,
        daysOverdue: daysOverdue,
        risk: risk,
        matrix: matrix,
      ));
    }

    if (sortBy == 'Balance') {
      rows.sort((a, b) => b.total.compareTo(a.total));
    }

    return rows;
  }

  // ── Credit limit save ────────────────────────────────────────────────────────

  Future<void> saveCreditLimit(PeopleData customer, double creditLimit) async {
    if (creditLimit < 0) return;
    await _db.updatePerson(_buildCompanion(customer, creditLimit: creditLimit));
  }

  static PeopleCompanion _buildCompanion(
    PeopleData customer, {
    double? creditLimit,
    int? paymentTermsDays,
    String? dueDate,
  }) {
    return PeopleCompanion(
      id: Value(customer.id),
      name: Value(customer.name),
      phone: Value(customer.phone),
      email: Value(customer.email),
      address: Value(customer.address),
      notes: Value(customer.notes),
      type: Value(customer.type),
      startBalance: Value(customer.startBalance),
      startDate: Value(customer.startDate),
      creditLimit: Value(creditLimit ?? customer.creditLimit),
      paymentTermsDays: Value(paymentTermsDays ?? customer.paymentTermsDays),
      dueDate: Value(dueDate ?? customer.dueDate),
      isDeleted: Value(customer.isDeleted),
    );
  }
}
