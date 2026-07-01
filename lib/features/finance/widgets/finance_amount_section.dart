import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/finance_models.dart';
import '../services/finance_service.dart';

class FinanceAmountSection extends StatelessWidget {
  final FinanceSource source;
  final TextEditingController amountController;
  final TextEditingController additionalController;
  final TextEditingController rateController;
  final TextEditingController paymentCountController;
  final String frequency;
  final String agreementDate;
  final String firstPaymentDate;
  final double selectedSalesTotal;
  final double effectiveLoanAmount;
  final ValueChanged<String?> onFrequencyChanged;
  final VoidCallback onAgreementDateTap;
  final VoidCallback onFirstPaymentDateTap;
  final VoidCallback onGenerateSchedule;

  const FinanceAmountSection({
    super.key,
    required this.source,
    required this.amountController,
    required this.additionalController,
    required this.rateController,
    required this.paymentCountController,
    required this.frequency,
    required this.agreementDate,
    required this.firstPaymentDate,
    required this.selectedSalesTotal,
    required this.effectiveLoanAmount,
    required this.onFrequencyChanged,
    required this.onAgreementDateTap,
    required this.onFirstPaymentDateTap,
    required this.onGenerateSchedule,
  });

  bool get _usesSales =>
      source == FinanceSource.allocated || source == FinanceSource.hybrid;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agreement Terms',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            if (source == FinanceSource.standalone)
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Agreement amount *',
                  prefixText: '£',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  final amount = _parseDouble(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter an agreement amount';
                  }
                  return null;
                },
              )
            else
              _AmountSummary(
                label: 'Selected sales',
                value: FinanceService.formatCurrency(selectedSalesTotal),
              ),
            if (source == FinanceSource.hybrid) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: additionalController,
                decoration: const InputDecoration(
                  labelText: 'Additional amount *',
                  prefixText: '£',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (value) {
                  final amount = _parseDouble(value);
                  if (amount == null || amount <= 0) {
                    return 'Enter an additional amount';
                  }
                  return null;
                },
              ),
            ],
            if (_usesSales) ...[
              const SizedBox(height: 12),
              _AmountSummary(
                label: 'Agreement amount',
                value: FinanceService.formatCurrency(effectiveLoanAmount),
              ),
            ],
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns = constraints.maxWidth >= 720;
                final fields = [
                  TextFormField(
                    controller: rateController,
                    decoration: const InputDecoration(
                      labelText: 'Interest rate *',
                      suffixText: '%',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    validator: (value) {
                      final rate = _parseDouble(value);
                      if (rate == null) return 'Enter a numeric rate';
                      if (rate < 0) return 'Interest rate cannot be negative';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: paymentCountController,
                    decoration: const InputDecoration(
                      labelText: 'Number of payments *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final count = int.tryParse(value?.trim() ?? '');
                      if (count == null || count <= 0) {
                        return 'Enter a positive payment count';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: frequency,
                    decoration: const InputDecoration(
                      labelText: 'Frequency *',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                      DropdownMenuItem(
                          value: 'Monthly', child: Text('Monthly')),
                    ],
                    onChanged: onFrequencyChanged,
                  ),
                  _DateButton(
                    label: 'Agreement date',
                    value: agreementDate,
                    onTap: onAgreementDateTap,
                  ),
                  _DateButton(
                    label: 'First payment date',
                    value: firstPaymentDate,
                    onTap: onFirstPaymentDateTap,
                  ),
                ];

                if (!twoColumns) {
                  return Column(
                    children: [
                      for (final field in fields) ...[
                        field,
                        if (field != fields.last) const SizedBox(height: 12),
                      ],
                    ],
                  );
                }

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: fields
                      .map((field) => SizedBox(
                            width: (constraints.maxWidth - 12) / 2,
                            child: field,
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onGenerateSchedule,
                icon: const Icon(Icons.calculate),
                label: const Text('Preview Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static double? _parseDouble(String? value) {
    final cleaned = value?.replaceAll(',', '').trim();
    if (cleaned == null || cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }
}

class _AmountSummary extends StatelessWidget {
  final String label;
  final String value;

  const _AmountSummary({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(FinanceService.formatDate(value)),
      ),
    );
  }
}
