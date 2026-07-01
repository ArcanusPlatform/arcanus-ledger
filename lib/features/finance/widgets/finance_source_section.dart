import 'package:flutter/material.dart';

import '../models/finance_models.dart';

class FinanceSourceSection extends StatelessWidget {
  final FinanceSource value;
  final ValueChanged<FinanceSource> onChanged;

  const FinanceSourceSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agreement Source',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: FinanceSource.values.map((source) {
                return ChoiceChip(
                  label: Text(source.label),
                  selected: value == source,
                  onSelected: (_) => onChanged(source),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
