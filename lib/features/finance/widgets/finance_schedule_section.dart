import 'package:flutter/material.dart';

import '../models/finance_models.dart';
import '../services/finance_service.dart';

class FinanceScheduleSection extends StatelessWidget {
  final GeneratedSchedule? schedule;

  const FinanceScheduleSection({
    super.key,
    required this.schedule,
  });

  @override
  Widget build(BuildContext context) {
    final generated = schedule;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Repayment Schedule Preview',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (generated == null)
              Text(
                'Generate a preview before saving.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else ...[
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _Metric(
                    label: 'Payment',
                    value: FinanceService.formatCurrency(
                      generated.totals.paymentAmount,
                    ),
                  ),
                  _Metric(
                    label: 'Interest',
                    value: FinanceService.formatCurrency(
                      generated.totals.totalInterest,
                    ),
                  ),
                  _Metric(
                    label: 'Total repayable',
                    value: FinanceService.formatCurrency(
                      generated.totals.totalRepayable,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
                  dataRowMinHeight: 40,
                  dataRowMaxHeight: 48,
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Due date')),
                    DataColumn(label: Text('Opening'), numeric: true),
                    DataColumn(label: Text('Payment'), numeric: true),
                    DataColumn(label: Text('Interest'), numeric: true),
                    DataColumn(label: Text('Capital'), numeric: true),
                    DataColumn(label: Text('Closing'), numeric: true),
                  ],
                  rows: generated.rows
                      .map(
                        (row) => DataRow(
                          cells: [
                            DataCell(Text('${row.paymentNo}')),
                            DataCell(
                                Text(FinanceService.formatDate(row.dueDate))),
                            DataCell(Text(FinanceService.formatCurrency(
                                row.openingBalance))),
                            DataCell(Text(FinanceService.formatCurrency(
                                row.paymentAmount))),
                            DataCell(Text(FinanceService.formatCurrency(
                                row.interestAmount))),
                            DataCell(Text(FinanceService.formatCurrency(
                                row.capitalAmount))),
                            DataCell(Text(FinanceService.formatCurrency(
                                row.closingBalance))),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
