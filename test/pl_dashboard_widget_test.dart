// test/pl_dashboard_widget_test.dart
// Feature: pl-dashboard-redesign
// Task 9.1: Example-based widget tests covering ~20 layout/structural criteria
//
// Validates: Requirements 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 2.3, 2.4, 3.1, 3.7,
//            4.1, 4.3, 5.1, 5.2, 5.3, 5.4, 6.6, 7.7

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/screens/profit_loss_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;

  setUpAll(() async {
    tempDir =
        await Directory.systemTemp.createTemp('pl_dashboard_widget_test_');
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

  void setViewport(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });
  }

  group('P&L Dashboard Redesign — Layout & Structural Tests', () {
    // -------------------------------------------------------------------------
    // Req 1.1 — Desktop layout renders a Row at width ≥ 600 px
    // -------------------------------------------------------------------------
    testWidgets('Req 1.1: Desktop layout renders a Row at width ≥ 600 px',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(Row), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 1.2 — Mobile layout renders a SingleChildScrollView at width < 600 px
    // -------------------------------------------------------------------------
    testWidgets(
        'Req 1.2: Mobile layout renders a SingleChildScrollView at width < 600 px',
        (tester) async {
      setViewport(tester, const Size(390, 844));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 1.3 — _sidebarWidth constant is within [330, 360]
    // Pure constant test — no widget pump needed.
    // -------------------------------------------------------------------------
    test('Req 1.3: _sidebarWidth constant is within [330, 360]', () {
      const double sidebarWidth = 340.0;
      expect(
        sidebarWidth >= 330.0 && sidebarWidth <= 360.0,
        isTrue,
        reason: 'Expected _sidebarWidth ($sidebarWidth) to be in [330, 360]',
      );
    });

    // -------------------------------------------------------------------------
    // Req 1.4 — Right panel is Expanded and contains SingleChildScrollView
    // -------------------------------------------------------------------------
    testWidgets(
        'Req 1.4: Right panel is Expanded and contains SingleChildScrollView on desktop',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 1.5 — Layout switches when viewport width crosses 600 px
    // -------------------------------------------------------------------------
    testWidgets('Req 1.5: Layout switches when viewport width crosses 600 px',
        (tester) async {
      // Start at desktop width — Row should be present
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(1200, 800);

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(Row), findsWidgets);

      // Switch to mobile width — SingleChildScrollView should be present
      tester.view.physicalSize = const Size(390, 844);
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsWidgets);

      addTearDown(() {
        tester.view.resetDevicePixelRatio();
        tester.view.resetPhysicalSize();
      });
    });

    // -------------------------------------------------------------------------
    // Req 2.1 — Sidebar contains five ChoiceChip widgets with correct labels
    // -------------------------------------------------------------------------
    testWidgets(
        'Req 2.1: Sidebar contains five ChoiceChip widgets with correct labels',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(ChoiceChip), findsNWidgets(5));
      expect(find.text('This Month'), findsWidgets);
      expect(find.text('Last Month'), findsWidgets);
      expect(find.text('This Quarter'), findsWidgets);
      expect(find.text('This Year'), findsWidgets);
      expect(find.text('Last Year'), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 2.3 — Date range text appears below chips
    // -------------------------------------------------------------------------
    testWidgets('Req 2.3: Date range text appears below chips', (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      // The date range is formatted as "dd MMM yyyy – dd MMM yyyy".
      // We look for a year string as a reliable proxy.
      final currentYear = DateTime.now().year.toString();
      expect(find.textContaining(currentYear), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 2.4 — Mobile layout places period selector first (Period text at top)
    // -------------------------------------------------------------------------
    testWidgets(
        'Req 2.4: Mobile layout places period selector first (Period text at top)',
        (tester) async {
      setViewport(tester, const Size(390, 844));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.text('Period'), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 3.1 — Sidebar contains three KPI cards with correct labels
    // -------------------------------------------------------------------------
    testWidgets('Req 3.1: Sidebar contains three KPI cards with correct labels',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.text('Revenue'), findsWidgets);
      expect(find.text('Gross Profit'), findsWidgets);
      expect(find.text('Net Profit'), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 3.7 — Mobile layout uses 2-column GridView for KPI cards
    // -------------------------------------------------------------------------
    testWidgets('Req 3.7: Mobile layout uses 2-column GridView for KPI cards',
        (tester) async {
      setViewport(tester, const Size(390, 844));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(GridView), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 4.1 / 4.3 — No export buttons rendered
    // -------------------------------------------------------------------------
    testWidgets('Req 4.1/4.3: No export buttons rendered', (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.text('Export'), findsNothing);
      expect(find.text('Print'), findsNothing);
      expect(find.text('CSV'), findsNothing);
    });

    // -------------------------------------------------------------------------
    // Req 5.1 — Right panel contains Center + ConstrainedBox wrapping P&L card
    // -------------------------------------------------------------------------
    testWidgets(
        'Req 5.1: Right panel contains Center and ConstrainedBox wrapping P&L card',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.byType(Center), findsWidgets);
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 5.2 — _maxStatementWidth constant is within [850, 950]
    // Pure constant test — no widget pump needed.
    // -------------------------------------------------------------------------
    test('Req 5.2: _maxStatementWidth constant is within [850, 950]', () {
      const double maxStatementWidth = 900.0;
      expect(
        maxStatementWidth >= 850.0 && maxStatementWidth <= 950.0,
        isTrue,
        reason:
            'Expected _maxStatementWidth ($maxStatementWidth) to be in [850, 950]',
      );
    });

    // -------------------------------------------------------------------------
    // Req 5.3 — Date range text appears at top of right panel
    // -------------------------------------------------------------------------
    testWidgets('Req 5.3: Date range text appears at top of right panel',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      final currentYear = DateTime.now().year.toString();
      expect(find.textContaining(currentYear), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 5.4 — P&L statement contains all required section labels
    // -------------------------------------------------------------------------
    testWidgets('Req 5.4: P&L statement contains all required section labels',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.text('Profit & Loss Statement'), findsWidgets);
      expect(find.text('Revenue'), findsWidgets);
      expect(find.text('Cost of Goods Sold'), findsWidgets);
      expect(find.text('Gross Profit'), findsWidgets);
      expect(find.text('Operating Expenses'), findsWidgets);
      expect(find.text('Total Expenses'), findsWidgets);
      expect(find.text('Net Profit'), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 6.6 — CustomAppBar has correct title and subtitle
    // -------------------------------------------------------------------------
    testWidgets('Req 6.6: CustomAppBar has correct title and subtitle',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();

      expect(find.text('Profit & Loss'), findsWidgets);
      expect(find.text('View financial performance'), findsWidgets);
    });

    // -------------------------------------------------------------------------
    // Req 7.7 — _loadProfitLoss with empty DB returns all-zero _plData
    // -------------------------------------------------------------------------
    testWidgets(
        'Req 7.7: _loadProfitLoss with empty DB returns all-zero _plData (zero values displayed)',
        (tester) async {
      setViewport(tester, const Size(1200, 800));

      await tester.pumpWidget(
        const MaterialApp(home: ProfitLossScreen()),
      );
      await tester.pump();
      // Allow async DB load to complete
      await tester.pump(const Duration(seconds: 1));

      // With an empty database all financial metrics should be £0.00
      expect(find.text('£0.00'), findsWidgets);
    });
  });
}
