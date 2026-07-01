import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/models/payment_allocation_model.dart';

import 'test_helpers.dart';
import 'test_setup.dart';

void main() {
  group('Sale and receipt classification', () {
    late AppDatabase db;

    setUp(() async {
      setupTests();
      db = await TestDatabaseHelper.createTestDatabase();
    });

    tearDown(() async {
      await TestDatabaseHelper.closeTestDatabase(db);
    });

    test('cash sales create a paid sale and cash sale receipt', () async {
      final customerId = await db.addPerson(
        const PeopleCompanion(
          name: Value('Cash Customer'),
          type: Value('CUSTOMER'),
        ),
      );
      final productId = await db.addProduct(
        const ProductsCompanion(
          name: Value('Service'),
          price: Value(120),
          trackStock: Value(false),
          currentStock: Value(0),
          avgCost: Value(0),
        ),
      );
      final product = await db.getProductById(productId);

      final saleId = await db.createSaleWithItems(
        SalesCompanion(
          personId: Value(customerId),
          invoiceNumber: const Value('27'),
          date: const Value('2026-05-12'),
          dueDate: const Value('2026-05-12'),
          saleType: const Value('CASH'),
          total: const Value(120),
          status: const Value('PAID'),
        ),
        [
          {
            'product': product!,
            'quantity': 1.0,
            'pricePerUnit': 120.0,
            'total': 120.0,
          }
        ],
        receipt: PaymentsCompanion(
          personId: Value(customerId),
          date: const Value('2026-05-12'),
          amount: const Value(120),
          receiptType: const Value('CASH_SALE'),
          paymentMethod: const Value('CASH_SALE'),
          reference: const Value('Payment for INV-27'),
        ),
      );

      final sale = await db.getSaleById(saleId) as Sale;
      expect(sale.saleType, 'CASH');
      expect(sale.status, 'PAID');

      final payments = (await db.getAllPayments()).cast<Payment>();
      expect(payments.single.receiptType, 'CASH_SALE');
      expect(payments.single.paymentMethod, 'CASH_SALE');

      final outstanding = await db.getOutstandingInvoices(customerId);
      expect(outstanding, isEmpty);
    });

    test('credit receipts keep the credit receipt type', () async {
      final customerId = await db.addPerson(
        const PeopleCompanion(
          name: Value('Credit Customer'),
          type: Value('CUSTOMER'),
        ),
      );

      final paymentId = await db.savePaymentWithAllocations(
        PaymentsCompanion(
          personId: Value(customerId),
          date: const Value('2026-05-12'),
          amount: const Value(50),
          receiptType: const Value('CREDIT_RECEIPT'),
          paymentMethod: const Value('CREDIT_RECEIPT'),
          reference: const Value('Receipt against outstanding balance'),
        ),
        [
          AllocationRecord(
            itemId: 'credit',
            saleId: 0,
            amount: 50,
          ),
        ],
      );

      final details = await db.getPaymentDetails(paymentId);
      expect(details['receiptType'], 'CREDIT_RECEIPT');
      expect(details['paymentMethod'], 'CREDIT_RECEIPT');
    });

    test('editing invoice metadata updates sale fields and receipt reference',
        () async {
      final customerId = await db.addPerson(
        const PeopleCompanion(
          name: Value('Editable Customer'),
          type: Value('CUSTOMER'),
        ),
      );
      final productId = await db.addProduct(
        const ProductsCompanion(
          name: Value('Service'),
          price: Value(80),
          trackStock: Value(false),
          currentStock: Value(0),
          avgCost: Value(0),
        ),
      );
      final product = await db.getProductById(productId);

      final saleId = await db.createSaleWithItems(
        SalesCompanion(
          personId: Value(customerId),
          invoiceNumber: const Value('44'),
          date: const Value('2026-05-12'),
          dueDate: const Value('2026-05-19'),
          saleType: const Value('CASH'),
          total: const Value(80),
          status: const Value('PAID'),
        ),
        [
          {
            'product': product!,
            'quantity': 1.0,
            'pricePerUnit': 80.0,
            'total': 80.0,
          }
        ],
        receipt: PaymentsCompanion(
          personId: Value(customerId),
          date: const Value('2026-05-12'),
          amount: const Value(80),
          receiptType: const Value('CASH_SALE'),
          paymentMethod: const Value('CASH_SALE'),
          reference: const Value('Payment for INV-44'),
        ),
      );

      await db.updateSaleEditableFields(
        id: saleId,
        invoiceNumber: '45',
        date: '2026-05-13',
        dueDate: '2026-05-20',
        notes: 'Updated invoice reference',
      );

      final sale = await db.getSaleById(saleId) as Sale;
      expect(sale.invoiceNumber, '45');
      expect(sale.date, '2026-05-13');
      expect(sale.dueDate, '2026-05-20');
      expect(sale.notes, 'Updated invoice reference');

      final payment = (await db.getAllPayments()).cast<Payment>().single;
      expect(payment.reference, 'Payment for INV-45');
    });
  });
}
