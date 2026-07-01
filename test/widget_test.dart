import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/screens/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('recordkeep_widget_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
      switch (call.method) {
        case 'getApplicationDocumentsDirectory':
        case 'getApplicationSupportDirectory':
        case 'getTemporaryDirectory':
          return tempDir.path;
        default:
          return null;
      }
    });
    await AppDatabase.init();
  });

  tearDownAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('dashboard opens Customer Workspace as the main desktop screen',
      (tester) async {
    _setViewport(tester, const Size(1200, 800));

    await _pumpDashboard(tester);

    final navBar = _navigationBar(tester);
    expect(find.text('Customer Workspace'), findsOneWidget);
    expect(find.text('New Sale'), findsWidgets);
    expect(find.text('Receipt'), findsWidgets);
    expect(find.text('Dashboard'), findsNothing);
    expect(navBar.selectedIndex, 0);
    expect(_destinationLabels(navBar), [
      'Customers',
      'Suppliers',
      'Products',
      'Sales',
      'Receipts',
      'Expenses',
      'P&L',
      'Reports',
      'Settings',
    ]);
    expect(find.text('Customers'), findsWidgets);
    expect(find.text('Products'), findsWidgets);
    expect(find.text('More'), findsNothing);
  });

  testWidgets('mobile navigation starts on Customers and exposes Products/More',
      (tester) async {
    _setViewport(tester, const Size(590, 844));

    await _pumpDashboard(tester);

    final navBar = _navigationBar(tester);
    expect(find.text('Customer Workspace'), findsOneWidget);
    expect(find.text('Dashboard'), findsNothing);
    expect(navBar.selectedIndex, 0);
    expect(_destinationLabels(navBar), ['Customers', 'Products', 'More']);

    navBar.onDestinationSelected!(2);
    await tester.pump();

    expect(find.text('Other business tools'), findsOneWidget);
    expect(find.text('Suppliers'), findsOneWidget);
  });
}

Future<void> _pumpDashboard(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    ),
  );
  await tester.pump();
}

NavigationBar _navigationBar(WidgetTester tester) {
  return tester.widget<NavigationBar>(find.byType(NavigationBar));
}

List<String> _destinationLabels(NavigationBar navBar) {
  return navBar.destinations
      .cast<NavigationDestination>()
      .map((destination) => destination.label)
      .toList();
}

void _setViewport(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}
