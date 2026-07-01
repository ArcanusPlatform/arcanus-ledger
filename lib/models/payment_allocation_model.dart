/// Model classes for payment allocation logic
class OutstandingItem {
  final String id; // "opening" or "invoice_{id}"
  final String type; // "opening" or "invoice"
  final int? saleId; // null for opening balance
  final String reference; // "Opening Balance" or invoice number
  final String date;
  final String? dueDate;
  final double outstandingAmount;

  OutstandingItem({
    required this.id,
    required this.type,
    this.saleId,
    required this.reference,
    required this.date,
    this.dueDate,
    required this.outstandingAmount,
  });

  @override
  String toString() {
    return 'OutstandingItem(id: $id, type: $type, saleId: $saleId, reference: $reference, date: $date, dueDate: $dueDate, outstandingAmount: $outstandingAmount)';
  }
}

class AllocationRecord {
  final String itemId;
  final int? saleId;
  final double amount;

  AllocationRecord({required this.itemId, this.saleId, required this.amount});

  @override
  String toString() {
    return 'AllocationRecord(itemId: $itemId, saleId: $saleId, amount: $amount)';
  }
}
