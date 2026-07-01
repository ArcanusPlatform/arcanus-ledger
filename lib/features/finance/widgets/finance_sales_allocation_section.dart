import 'package:flutter/material.dart';

import '../models/finance_models.dart';
import '../services/finance_service.dart';

class FinanceSalesAllocationSection extends StatelessWidget {
  final FinanceSource source;
  final int? selectedPersonId;
  final List<SelectableSale> sales;
  final bool isLoading;
  final double selectedTotal;
  final ValueChanged<SelectableSale> onToggleSale;
  final VoidCallback onRefresh;

  const FinanceSalesAllocationSection({
    super.key,
    required this.source,
    required this.selectedPersonId,
    required this.sales,
    required this.isLoading,
    required this.selectedTotal,
    required this.onToggleSale,
    required this.onRefresh,
  });

  bool get _visible =>
      source == FinanceSource.allocated || source == FinanceSource.hybrid;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Sales Allocation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Refresh sales',
                  onPressed:
                      selectedPersonId == null || isLoading ? null : onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (selectedPersonId == null)
              Text(
                'Select a customer to choose existing sales.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (sales.isEmpty)
              Text(
                'No outstanding sales available.',
                style: TextStyle(color: Colors.grey.shade700),
              )
            else ...[
              ...sales.map(
                (sale) => CheckboxListTile(
                  value: sale.selected,
                  onChanged: (_) => onToggleSale(sale),
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(sale.invoiceNumber),
                  subtitle: Text(FinanceService.formatDate(sale.date)),
                  secondary: Text(
                    FinanceService.formatCurrency(sale.outstanding),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(height: 20),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Selected total',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    FinanceService.formatCurrency(selectedTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
