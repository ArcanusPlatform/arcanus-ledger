import 'package:drift/drift.dart';

class People extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('CUSTOMER'))();
  RealColumn get startBalance => real().withDefault(const Constant(0.0))();
  TextColumn get startDate => text().nullable()();
  RealColumn get creditLimit => real().withDefault(const Constant(0.0))();
  IntColumn get paymentTermsDays => integer().withDefault(const Constant(0))();
  TextColumn get dueDate => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real()();
  TextColumn get category => text().nullable()();
  BoolColumn get trackStock => boolean().withDefault(const Constant(false))();
  RealColumn get currentStock => real().withDefault(const Constant(0.0))();
  RealColumn get avgCost => real().withDefault(const Constant(0.0))();
  RealColumn get reorderLevel => real().withDefault(const Constant(10.0))();

  // Bundle deals - up to 5 bundles per product
  RealColumn get bundle1Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle1Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle2Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle2Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle3Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle3Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle4Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle4Price => real().withDefault(const Constant(0.0))();
  RealColumn get bundle5Qty => real().withDefault(const Constant(0.0))();
  RealColumn get bundle5Price => real().withDefault(const Constant(0.0))();

  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('SUPPLIER'))();
  TextColumn get accountCode => text().withDefault(const Constant('2100'))(); // Creditors Control
  TextColumn get expenseCategory => text().nullable()(); // Default expense category for P&L
  RealColumn get openingBalance => real().withDefault(const Constant(0.0))();
  TextColumn get startDate => text().nullable()();
  RealColumn get creditLimit => real().withDefault(const Constant(0.0))();
  IntColumn get paymentTermsDays => integer().withDefault(const Constant(30))();
  TextColumn get dueDate => text().nullable()();
  TextColumn get terms => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()();
  TextColumn get invoiceNumber => text()();
  TextColumn get date => text()();
  TextColumn get dueDate => text().nullable()();
  TextColumn get saleType => text().withDefault(const Constant('CREDIT'))();
  RealColumn get total => real()();
  TextColumn get status => text().withDefault(const Constant('NORMAL'))();
  TextColumn get notes => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer()();
  IntColumn get productId => integer()();
  RealColumn get quantity => real()();
  RealColumn get price => real()();
  RealColumn get total => real()();
  RealColumn get costOfGoods => real().withDefault(const Constant(0.0))();
}

class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personId => integer()();
  TextColumn get date => text()();
  RealColumn get amount => real()();
  TextColumn get paymentType => text().withDefault(const Constant('CUSTOMER_RECEIPT'))(); // CUSTOMER_RECEIPT or SUPPLIER_PAYMENT
  TextColumn get receiptType =>
      text().withDefault(const Constant('CREDIT_RECEIPT'))();
  // Legacy storage column retained for existing data and backups.
  TextColumn get paymentMethod => text()();
  TextColumn get reference => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class Allocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get paymentId => integer()();
  IntColumn get allocatedItemId => integer()(); // Can be saleId, productPurchaseId, expenseId, or -1 for opening balance
  TextColumn get allocatedItemType => text().withDefault(const Constant('SALE'))(); // SALE, PRODUCT_PURCHASE, EXPENSE, OPENING_BALANCE, CREDIT_ON_ACCOUNT
  RealColumn get amount => real()();
  IntColumn get isActive => integer().withDefault(const Constant(1))();
}

class ProductPurchases extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()();
  IntColumn get supplierId => integer().nullable()();
  TextColumn get date => text()();
  RealColumn get quantity => real()();
  RealColumn get qtyPerUnit => real().withDefault(const Constant(1.0))();
  RealColumn get costPerUnit => real()();
  RealColumn get totalCost => real()();
  RealColumn get remainingQuantity => real()();
}

class StockAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleItemId => integer()();
  IntColumn get purchaseId => integer()();
  RealColumn get quantity => real()();
  RealColumn get costPerUnit => real()();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date => text()();
  TextColumn get category => text()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get reference => text().nullable()();
  IntColumn get personId => integer().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get color => text().withDefault(const Constant('grey'))();
  TextColumn get icon => text().withDefault(const Constant('receipt'))();
  IntColumn get isDefault => integer().withDefault(const Constant(0))();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

// ─────────────────────────────────────────────────────────────────────────────
// FINANCE MODULE
// ─────────────────────────────────────────────────────────────────────────────

/// A finance agreement — the agreement layer.
/// Stores the original terms and never changes after creation.
class FinanceAgreements extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Customer name (free text — not linked to People table)
  TextColumn get customerName => text()();
  TextColumn get customerAddress => text().nullable()();

  /// Date the agreement was signed (ISO yyyy-MM-dd)
  TextColumn get agreementDate => text()();

  /// Capital lent
  RealColumn get loanAmount => real()();

  /// Annual interest rate as a percentage (e.g. 10.0 = 10%)
  RealColumn get interestRate => real()();

  /// 'Weekly' or 'Monthly'
  TextColumn get paymentFrequency => text().withDefault(const Constant('Monthly'))();

  /// Total number of scheduled payments
  IntColumn get paymentCount => integer()();

  /// Date of first payment (ISO yyyy-MM-dd)
  TextColumn get firstPaymentDate => text()();

  /// Calculated at generation time — stored for display
  RealColumn get paymentAmount => real()();
  RealColumn get totalInterest => real()();
  RealColumn get totalRepayable => real()();

  /// 'ACTIVE', 'COMPLETE', 'OVERDUE'
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();

  // ── Finance source metadata (added v16) ──────────────────────────────────

  /// 'standalone' | 'allocated' | 'hybrid'
  TextColumn get financeSource =>
      text().withDefault(const Constant('standalone'))();

  /// FK to People.id — links agreement to a customer record (nullable for
  /// standalone agreements created outside the workspace)
  IntColumn get linkedPersonId => integer().nullable()();

  /// For allocated/hybrid: the total of the source sales absorbed
  RealColumn get sourceSalesAmount => real().nullable()();

  /// For hybrid: the additional manual amount on top of source sales
  RealColumn get additionalAmount => real().nullable()();

  /// Free-text purpose / reason for the finance arrangement
  TextColumn get purposeNote => text().nullable()();

  /// Free-text security or supporting asset note
  TextColumn get assetNote => text().nullable()();

  TextColumn get createdAt => text()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

/// Individual payment rows in the repayment schedule — the servicing ledger.
class FinancePayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get agreementId => integer()();

  IntColumn get paymentNo => integer()();

  /// ISO yyyy-MM-dd
  TextColumn get dueDate => text()();

  RealColumn get openingBalance => real()();
  RealColumn get paymentAmount => real()();
  RealColumn get interestAmount => real()();
  RealColumn get capitalAmount => real()();
  RealColumn get closingBalance => real()();

  /// 0 = pending, 1 = paid
  IntColumn get paid => integer().withDefault(const Constant(0))();

  /// ISO yyyy-MM-dd, nullable
  TextColumn get paidDate => text().nullable()();

  /// 'SCHEDULED' or 'SETTLEMENT' (early settlement row)
  TextColumn get rowType => text().withDefault(const Constant('SCHEDULED'))();
}

/// Junction table linking allocated/hybrid finance agreements to the
/// source sales/invoices that were absorbed into the agreement.
/// The original sales remain visible in the trade ledger but their
/// outstanding balance is considered restructured into finance.
class FinanceSaleLinks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get agreementId => integer()();
  IntColumn get saleId => integer()();
}

// ─────────────────────────────────────────────────────────────────────────────
// SUPPLIER INVOICES
// ─────────────────────────────────────────────────────────────────────────────

/// A purchase invoice from a supplier — mirrors the Sales table structure.
class SupplierInvoices extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer()(); // FK → People.id (type=SUPPLIER)
  TextColumn get invoiceNumber => text()();
  TextColumn get date => text()();
  TextColumn get dueDate => text().nullable()();
  RealColumn get total => real()();
  TextColumn get status => text().withDefault(const Constant('UNPAID'))(); // UNPAID, PAID, VOID
  TextColumn get notes => text().nullable()();
  IntColumn get isDeleted => integer().withDefault(const Constant(0))();
}

/// Line items on a supplier invoice.
class SupplierInvoiceItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get invoiceId => integer()();
  TextColumn get description => text()();
  TextColumn get category => text().nullable()(); // expense category or 'PRODUCT'
  IntColumn get productId => integer().nullable()(); // set if product purchase
  RealColumn get quantity => real().withDefault(const Constant(1.0))();
  RealColumn get unitCost => real()();
  RealColumn get total => real()();
}
