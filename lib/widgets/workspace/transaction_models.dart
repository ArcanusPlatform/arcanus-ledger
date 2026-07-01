// ignore_for_file: constant_identifier_names

/// Placeholder for transaction types if a full BusinessTransactions table is not used.
enum TransactionType {
  SALE,
  PURCHASE,
  EXPENSE,
  PAYMENT,
  RECEIPT,
  FINANCE_AGREEMENT,
  FINANCE_PAYMENT,
}

class NominalCodes {
  static const bank = '1200';
  static const debtors = '1100';
  static const creditors = '2100';
  static const sales = '4000';
  static const purchases = '5000';
  static const vatOutput = '2200';
  static const vatInput = '2201';
}