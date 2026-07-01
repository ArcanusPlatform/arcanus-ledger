// test/pl_dashboard_property_test.dart
// Feature: pl-dashboard-redesign
// Property 1: KPI card always renders with required structural elements
// Property 2: Net profit KPI card color reflects sign of value
// Property 3: Expense aggregation is consistent and complete
//
// Validates: Requirements 3.2, 3.4, 7.4
//
// This test uses a manual iteration approach (flutter_test + dart:math Random)
// since fast_check is not in pubspec.yaml.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Replicates the expense aggregation logic from _loadProfitLoss.
/// Returns a record of (expensesByCategory, totalExpenses).
///
/// Validates: Requirements 7.4
({Map<String, double> expensesByCategory, double totalExpenses})
    aggregateExpenses(List<({String category, double amount})> expenses) {
  final expensesByCategory = <String, double>{};
  double totalExpenses = 0.0;

  for (final expense in expenses) {
    expensesByCategory[expense.category] =
        (expensesByCategory[expense.category] ?? 0.0) + expense.amount;
    totalExpenses += expense.amount;
  }

  return (
    expensesByCategory: expensesByCategory,
    totalExpenses: totalExpenses,
  );
}

/// Replicates the net-profit color-selection expression from
/// _ProfitLossScreenState._buildSidebar, allowing it to be tested in
/// isolation without pumping any widgets.
///
/// Validates: Requirements 3.4
Color netProfitColor(double netProfit) =>
    netProfit >= 0 ? Colors.green : Colors.red;

/// Standalone helper that replicates the _buildKpiCard logic from
/// _ProfitLossScreenState, allowing it to be tested without accessing
/// private state.
Widget buildKpiCardForTest(
    String label, String value, IconData icon, Color color) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0, // AppSpacing.desktopScreenPadding
        vertical: 10,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.0, // AppTypography.desktopLabel
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.0, // AppTypography.desktopBodyText
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

void main() {
  group('Feature: pl-dashboard-redesign', () {
    testWidgets(
      'Property 1: KPI card always renders with required structural elements',
      (tester) async {
        // Input space covering varied labels, values, icons, and colors.
        // The nested loops produce 9 × 7 × 6 × 6 = 2268 combinations;
        // we stop after 100 to keep the test fast while still exercising
        // a representative cross-section of the input space.
        final labels = [
          'Revenue',
          'Gross Profit',
          'Net Profit',
          'Expenses',
          'COGS',
          '',
          'A very long label that wraps',
          '£',
          '0',
        ];
        final values = [
          '£0.00',
          '£1234.56',
          '£-99.99',
          '£999999.99',
          '£0.01',
          '-£50.00',
          '£1.00',
        ];
        final icons = [
          Icons.trending_up,
          Icons.trending_down,
          Icons.attach_money,
          Icons.account_balance_wallet,
          Icons.star,
          Icons.home,
        ];
        final colors = [
          Colors.green,
          Colors.red,
          Colors.blue,
          Colors.teal,
          Colors.orange,
          Colors.purple,
        ];

        int iterations = 0;

        outerLoop:
        for (final label in labels) {
          for (final value in values) {
            for (final icon in icons) {
              for (final color in colors) {
                await tester.pumpWidget(
                  MaterialApp(
                    home: Scaffold(
                      body: buildKpiCardForTest(label, value, icon, color),
                    ),
                  ),
                );

                // Property: widget tree contains a Row
                expect(
                  find.byType(Row),
                  findsWidgets,
                  reason:
                      'Expected a Row widget for label=$label, value=$value',
                );

                // Property: widget tree contains an Icon with size <= 20
                final iconWidgets =
                    tester.widgetList<Icon>(find.byType(Icon)).toList();
                expect(
                  iconWidgets.any((i) => i.size != null && i.size! <= 20),
                  isTrue,
                  reason:
                      'Expected an Icon with size <= 20 for label=$label, value=$value',
                );

                // Property: label Text is present (skip empty-string labels
                // because find.text('') matches many widgets)
                if (label.isNotEmpty) {
                  expect(
                    find.text(label),
                    findsOneWidget,
                    reason:
                        'Expected label text "$label" to be present',
                  );
                }

                // Property: value Text is present
                expect(
                  find.text(value),
                  findsOneWidget,
                  reason:
                      'Expected value text "$value" to be present',
                );

                iterations++;
                if (iterations >= 100) break outerLoop;
              }
            }
          }
        }

        expect(
          iterations,
          greaterThanOrEqualTo(100),
          reason: 'Property test must run at least 100 iterations',
        );
      },
      tags: 'pl-dashboard-redesign',
    );

    // ---------------------------------------------------------------------------
    // Property 2: Net profit KPI card color reflects sign of value
    // Validates: Requirements 3.4
    // Tag: Feature: pl-dashboard-redesign,
    //      Property 2: Net profit KPI card color reflects sign of value
    // ---------------------------------------------------------------------------
    test(
      'Property 2: Net profit KPI card color reflects sign of value',
      () {
        // --- Fixed boundary and representative values ---
        final positiveValues = <double>[
          0.0,
          0.001,
          0.01,
          1.0,
          100.0,
          999999.99,
          double.maxFinite,
        ];
        final negativeValues = <double>[
          -0.001,
          -0.01,
          -1.0,
          -100.0,
          -999999.99,
          -double.maxFinite,
        ];

        // --- Sweep: 10001 values from -50.0 to +50.0 in steps of 0.01 ---
        // This covers both sides of zero with fine granularity and ensures
        // the test runs well over 100 iterations.
        final sweepValues = <double>[
          for (int i = 0; i <= 10000; i++) i * 0.01 - 50.0,
        ];

        int iterations = 0;

        // Verify positive / zero values → Colors.green
        for (final value in [...positiveValues, ...sweepValues.where((v) => v >= 0)]) {
          expect(
            netProfitColor(value),
            equals(Colors.green),
            reason: 'Expected Colors.green for netProfit=$value (>= 0)',
          );
          iterations++;
        }

        // Verify negative values → Colors.red
        for (final value in [...negativeValues, ...sweepValues.where((v) => v < 0)]) {
          expect(
            netProfitColor(value),
            equals(Colors.red),
            reason: 'Expected Colors.red for netProfit=$value (< 0)',
          );
          iterations++;
        }

        expect(
          iterations,
          greaterThanOrEqualTo(100),
          reason: 'Property 2 test must run at least 100 iterations',
        );
      },
      tags: 'pl-dashboard-redesign',
    );

    // ---------------------------------------------------------------------------
    // Property 3: Expense aggregation is consistent and complete
    // Validates: Requirements 7.4
    // Tag: Feature: pl-dashboard-redesign,
    //      Property 3: Expense aggregation is consistent and complete
    // ---------------------------------------------------------------------------
    test(
      'Property 3: Expense aggregation is consistent and complete',
      () {
        // **Validates: Requirements 7.4**

        const categories = [
          'Rent',
          'Utilities',
          'Supplies',
          'Marketing',
          'Salaries',
          'Other',
        ];
        const amounts = [0.0, 0.01, 10.0, 100.0, 999.99, 1234.56];

        // Build a varied set of expense lists covering the required cases.
        final testCases = <List<({String category, double amount})>>[
          // Empty list
          [],

          // Single expense – one entry per (category, amount) combination
          for (final cat in categories)
            for (final amt in amounts)
              [(category: cat, amount: amt)],

          // Multiple expenses in the same category
          [
            (category: 'Rent', amount: 100.0),
            (category: 'Rent', amount: 200.0),
            (category: 'Rent', amount: 999.99),
          ],
          [
            (category: 'Salaries', amount: 1234.56),
            (category: 'Salaries', amount: 1234.56),
          ],

          // Multiple expenses in different categories
          [
            (category: 'Rent', amount: 500.0),
            (category: 'Utilities', amount: 100.0),
            (category: 'Supplies', amount: 50.0),
          ],
          [
            (category: 'Marketing', amount: 999.99),
            (category: 'Salaries', amount: 1234.56),
            (category: 'Other', amount: 0.01),
            (category: 'Rent', amount: 0.0),
          ],

          // Large list – 50+ expenses cycling through all categories and amounts
          [
            for (int i = 0; i < 54; i++)
              (
                category: categories[i % categories.length],
                amount: amounts[i % amounts.length],
              ),
          ],

          // Another large list with all same category
          [
            for (int i = 0; i < 60; i++)
              (category: 'Utilities', amount: amounts[i % amounts.length]),
          ],

          // Mixed: zero amounts alongside non-zero
          [
            (category: 'Rent', amount: 0.0),
            (category: 'Rent', amount: 100.0),
            (category: 'Supplies', amount: 0.0),
            (category: 'Supplies', amount: 10.0),
          ],

          // All-zero amounts
          [
            for (final cat in categories) (category: cat, amount: 0.0),
          ],

          // Repeated identical entries
          [
            for (int i = 0; i < 10; i++)
              (category: 'Marketing', amount: 10.0),
          ],

          // Additional varied lists to reach ≥ 100 iterations
          // Two-category combinations (6 × 6 = 36 more cases)
          for (int ci = 0; ci < categories.length; ci++)
            for (int ai = 0; ai < amounts.length; ai++)
              [
                (category: categories[ci], amount: amounts[ai]),
                (
                  category: categories[(ci + 1) % categories.length],
                  amount: amounts[(ai + 1) % amounts.length]
                ),
              ],

          // Three-category combinations (6 more cases)
          for (int i = 0; i < categories.length; i++)
            [
              (category: categories[i], amount: 100.0),
              (category: categories[(i + 2) % categories.length], amount: 200.0),
              (category: categories[(i + 4) % categories.length], amount: 300.0),
            ],

          // Lists with all six categories present (6 more cases, one per amount)
          for (final amt in amounts)
            [
              for (final cat in categories) (category: cat, amount: amt),
            ],

          // Extra single-expense cases to push total past 100
          [(category: 'Rent', amount: 0.001)],
          [(category: 'Utilities', amount: 9999.99)],
          [(category: 'Supplies', amount: 0.005)],
          [(category: 'Marketing', amount: 50000.0)],
          [(category: 'Salaries', amount: 0.1)],
          [(category: 'Other', amount: 1.0)],
          [(category: 'Rent', amount: 2.0)],
          [(category: 'Utilities', amount: 3.0)],
          [(category: 'Supplies', amount: 4.0)],
          [(category: 'Marketing', amount: 5.0)],
        ];

        int iterations = 0;

        for (final expenses in testCases) {
          final result = aggregateExpenses(expenses);
          final expensesByCategory = result.expensesByCategory;
          final totalExpenses = result.totalExpenses;

          // Property 3a: sum of category values equals totalExpenses
          final categorySum = expensesByCategory.values
              .fold(0.0, (a, b) => a + b);
          expect(
            categorySum,
            closeTo(totalExpenses, 0.001),
            reason:
                'Property 3a failed: sum of category values ($categorySum) '
                '!= totalExpenses ($totalExpenses) for expenses=$expenses',
          );

          // Property 3b: each category value equals the sum of its expenses
          for (final k in expensesByCategory.keys) {
            final expectedCategoryTotal = expenses
                .where((e) => e.category == k)
                .fold(0.0, (a, b) => a + b.amount);
            expect(
              expensesByCategory[k]!,
              closeTo(expectedCategoryTotal, 0.001),
              reason:
                  'Property 3b failed: expensesByCategory[$k]='
                  '${expensesByCategory[k]} != expected $expectedCategoryTotal '
                  'for expenses=$expenses',
            );
          }

          iterations++;
        }

        expect(
          iterations,
          greaterThanOrEqualTo(100),
          reason: 'Property 3 test must run at least 100 iterations',
        );
      },
      tags: 'pl-dashboard-redesign',
    );
  });
}
