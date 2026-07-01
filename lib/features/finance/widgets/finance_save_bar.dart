import 'package:flutter/material.dart';

import '../models/finance_models.dart';
import '../services/finance_service.dart';

class FinanceSaveBar extends StatelessWidget {
  final bool isSaving;
  final bool isEditing;
  final double loanAmount;
  final GeneratedSchedule? schedule;
  final VoidCallback onSave;

  const FinanceSaveBar({
    super.key,
    required this.isSaving,
    required this.isEditing,
    required this.loanAmount,
    required this.schedule,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final generated = schedule;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 18,
                runSpacing: 4,
                children: [
                  _SummaryText(
                    label: 'Loan',
                    value: FinanceService.formatCurrency(loanAmount),
                  ),
                  _SummaryText(
                    label: 'Repayable',
                    value: generated == null
                        ? '-'
                        : FinanceService.formatCurrency(
                            generated.totals.totalRepayable,
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: isSaving ? null : onSave,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(isEditing ? 'Save Changes' : 'Save Agreement'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryText({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
