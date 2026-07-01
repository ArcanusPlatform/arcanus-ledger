import 'package:flutter/material.dart';

class FinanceNotesSection extends StatelessWidget {
  final TextEditingController purposeController;
  final TextEditingController assetController;

  const FinanceNotesSection({
    super.key,
    required this.purposeController,
    required this.assetController,
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
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose note',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: assetController,
              decoration: const InputDecoration(
                labelText: 'Asset note',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
