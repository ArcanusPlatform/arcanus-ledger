import 'package:flutter/material.dart';

import '../../../database/database.dart';

class FinanceCustomerSection extends StatelessWidget {
  final List<PeopleData> customers;
  final int? selectedPersonId;
  final bool customerRequired;
  final bool isLoading;
  final ValueChanged<int?> onPersonChanged;
  final TextEditingController nameController;
  final TextEditingController addressController;

  const FinanceCustomerSection({
    super.key,
    required this.customers,
    required this.selectedPersonId,
    required this.customerRequired,
    required this.isLoading,
    required this.onPersonChanged,
    required this.nameController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelected = selectedPersonId != null &&
        customers.any((c) => c.id == selectedPersonId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<int?>(
              initialValue: hasSelected ? selectedPersonId : null,
              decoration: InputDecoration(
                labelText:
                    customerRequired ? 'Linked customer *' : 'Linked customer',
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                if (!customerRequired)
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('No linked customer'),
                  ),
                ...customers.map(
                  (customer) => DropdownMenuItem<int?>(
                    value: customer.id,
                    child: Text(customer.name),
                  ),
                ),
              ],
              onChanged: isLoading ? null : onPersonChanged,
              validator: (value) {
                if (customerRequired && value == null) {
                  return 'Select a customer';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer name *',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a customer name';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Customer address',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              minLines: 2,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
