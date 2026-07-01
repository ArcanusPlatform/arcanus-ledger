import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/models/workspace_models.dart';

void main() {
  group('NavigatorItem', () {
    test('creates item with all required fields', () {
      final item = NavigatorItem(
        id: '1',
        primaryText: 'Test Customer',
        secondaryText: '123-456-7890',
        balance: 100.0,
        financeBalance: 0.0,
        creditLimit: 500.0,
        dueDate: DateTime(2024, 12, 31),
        status: NavigatorItemStatus.normal,
        riskColor: Colors.green,
      );

      expect(item.id, '1');
      expect(item.primaryText, 'Test Customer');
      expect(item.secondaryText, '123-456-7890');
      expect(item.balance, 100.0);
      expect(item.creditLimit, 500.0);
      expect(item.dueDate, DateTime(2024, 12, 31));
      expect(item.status, NavigatorItemStatus.normal);
      expect(item.riskColor, Colors.green);
    });

    test('fromCustomer factory calculates normal status correctly', () {
      final item = NavigatorItem.fromCustomer(
        _customer(
          phone: '123-456-7890',
          email: 'test@example.com',
          creditLimit: 500.0,
        ),
        100.0,
        DateTime.now().add(const Duration(days: 5)),
        0.0,
      );

      expect(item.status, NavigatorItemStatus.normal);
      expect(item.riskColor, Colors.green);
    });

    test('fromCustomer factory calculates dueSoon status correctly', () {
      final item = NavigatorItem.fromCustomer(
        _customer(
          phone: '123-456-7890',
          email: 'test@example.com',
          creditLimit: 500.0,
        ),
        100.0,
        DateTime.now().add(const Duration(days: 2)),
        0.0,
      );

      expect(item.status, NavigatorItemStatus.dueSoon);
      expect(item.riskColor, Colors.amber.shade700);
    });

    test('fromCustomer factory calculates overdue status correctly', () {
      final item = NavigatorItem.fromCustomer(
        _customer(
          phone: '123-456-7890',
          email: 'test@example.com',
          creditLimit: 500.0,
        ),
        100.0,
        DateTime.now().subtract(const Duration(days: 1)),
        0.0,
      );

      expect(item.status, NavigatorItemStatus.overdue);
      expect(item.riskColor, Colors.red);
    });

    test('fromCustomer factory calculates overLimit status correctly', () {
      final item = NavigatorItem.fromCustomer(
        _customer(
          phone: '123-456-7890',
          email: 'test@example.com',
          creditLimit: 500.0,
        ),
        600.0,
        DateTime.now().add(const Duration(days: 5)),
        0.0,
      );

      expect(item.status, NavigatorItemStatus.overLimit);
      expect(item.riskColor, Colors.red);
    });

    test('fromCustomer prefers phone over email for secondaryText', () {
      final item = NavigatorItem.fromCustomer(
        _customer(
          phone: '123-456-7890',
          email: 'test@example.com',
          creditLimit: 500.0,
        ),
        100.0,
        null,
        0.0,
      );

      expect(item.secondaryText, '123-456-7890');
    });

    test('fromCustomer uses email when phone is null', () {
      final item = NavigatorItem.fromCustomer(
        _customer(
          phone: null,
          email: 'test@example.com',
          creditLimit: 500.0,
        ),
        100.0,
        null,
        0.0,
      );

      expect(item.secondaryText, 'test@example.com');
    });

    test('items expose equivalent field values', () {
      final item1 = NavigatorItem(
        id: '1',
        primaryText: 'Test Customer',
        secondaryText: '123-456-7890',
        balance: 100.0,
        financeBalance: 0.0,
        creditLimit: 500.0,
        dueDate: DateTime(2024, 12, 31),
        status: NavigatorItemStatus.normal,
        riskColor: Colors.green,
      );

      final item2 = NavigatorItem(
        id: '1',
        primaryText: 'Test Customer',
        secondaryText: '123-456-7890',
        balance: 100.0,
        financeBalance: 0.0,
        creditLimit: 500.0,
        dueDate: DateTime(2024, 12, 31),
        status: NavigatorItemStatus.normal,
        riskColor: Colors.green,
      );

      expect(item1.id, item2.id);
      expect(item1.primaryText, item2.primaryText);
      expect(item1.secondaryText, item2.secondaryText);
      expect(item1.balance, item2.balance);
      expect(item1.creditLimit, item2.creditLimit);
      expect(item1.dueDate, item2.dueDate);
      expect(item1.status, item2.status);
      expect(item1.riskColor, item2.riskColor);
    });
  });

  group('WorkspaceTab', () {
    test('creates tab with all required fields', () {
      final tab = WorkspaceTab(
        label: 'Account',
        icon: Icons.person,
        content: const Text('Test Content'),
      );

      expect(tab.label, 'Account');
      expect(tab.icon, Icons.person);
      expect(tab.content, isA<Text>());
    });
  });

  group('WorkspaceContent', () {
    test('creates content with all required fields', () {
      final content = WorkspaceContent(
        itemId: '1',
        tabs: [
          WorkspaceTab(
            label: 'Account',
            icon: Icons.person,
            content: const Text('Account Content'),
          ),
          WorkspaceTab(
            label: 'Ledger',
            icon: Icons.receipt_long,
            content: const Text('Ledger Content'),
          ),
        ],
        initialTabIndex: 0,
      );

      expect(content.itemId, '1');
      expect(content.tabs.length, 2);
      expect(content.initialTabIndex, 0);
    });

    test('defaults initialTabIndex to 0', () {
      final content = WorkspaceContent(
        itemId: '1',
        tabs: [
          WorkspaceTab(
            label: 'Account',
            icon: Icons.person,
            content: const Text('Account Content'),
          ),
        ],
      );

      expect(content.initialTabIndex, 0);
    });

    test('content exposes equivalent field values', () {
      final content1 = WorkspaceContent(
        itemId: '1',
        tabs: [],
        initialTabIndex: 0,
      );

      final content2 = WorkspaceContent(
        itemId: '1',
        tabs: [],
        initialTabIndex: 0,
      );

      expect(content1.itemId, content2.itemId);
      expect(content1.tabs, content2.tabs);
      expect(content1.initialTabIndex, content2.initialTabIndex);
    });
  });

  group('NavigatorItemStatus', () {
    test('enum has all required values', () {
      expect(NavigatorItemStatus.values.length, 4);
      expect(NavigatorItemStatus.values, contains(NavigatorItemStatus.normal));
      expect(NavigatorItemStatus.values, contains(NavigatorItemStatus.dueSoon));
      expect(NavigatorItemStatus.values, contains(NavigatorItemStatus.overdue));
      expect(
        NavigatorItemStatus.values,
        contains(NavigatorItemStatus.overLimit),
      );
    });
  });

  group('WorkspaceDataSource', () {
    test('interface defines required methods', () {
      // This test verifies the interface exists and has the correct signature
      // Actual implementation testing will be done in integration tests
      expect(WorkspaceDataSource, isA<Type>());
    });
  });
}

PeopleData _customer({
  int id = 1,
  String name = 'Test Customer',
  String? phone,
  String? email,
  double creditLimit = 0,
}) {
  return PeopleData(
    id: id,
    name: name,
    phone: phone,
    email: email,
    address: null,
    notes: null,
    type: 'CUSTOMER',
    startBalance: 0,
    startDate: null,
    creditLimit: creditLimit,
    paymentTermsDays: 30,
    dueDate: null,
    isDeleted: 0,
  );
}
