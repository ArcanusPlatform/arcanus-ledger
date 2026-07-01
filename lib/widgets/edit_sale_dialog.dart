import 'package:flutter/material.dart';

import '../database/database.dart';
import '../utils/responsive_utils.dart';
import 'responsive_dialog.dart';

class EditSaleDialog extends StatefulWidget {
  final AppDatabase db;
  final Sale sale;

  const EditSaleDialog({
    super.key,
    required this.db,
    required this.sale,
  });

  @override
  State<EditSaleDialog> createState() => _EditSaleDialogState();
}

class _EditSaleDialogState extends State<EditSaleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _invoiceNumberController;
  late final TextEditingController _dateController;
  late final TextEditingController _dueDateController;
  late final TextEditingController _notesController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _invoiceNumberController =
        TextEditingController(text: widget.sale.invoiceNumber);
    _dateController = TextEditingController(text: widget.sale.date);
    _dueDateController = TextEditingController(text: widget.sale.dueDate ?? '');
    _notesController = TextEditingController(text: widget.sale.notes ?? '');
  }

  @override
  void dispose() {
    _invoiceNumberController.dispose();
    _dateController.dispose();
    _dueDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime? _parseIsoDate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return DateTime.tryParse(trimmed);
  }

  String _isoDate(DateTime date) => date.toIso8601String().split('T')[0];

  Future<void> _pickDate(TextEditingController controller) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _parseIsoDate(controller.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null) return;
    setState(() => controller.text = _isoDate(selected));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await widget.db.updateSaleEditableFields(
        id: widget.sale.id,
        invoiceNumber: _invoiceNumberController.text.trim(),
        date: _dateController.text.trim(),
        dueDate: _dueDateController.text.trim(),
        notes: _notesController.text.trim(),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update sale: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      title: Row(
        children: [
          Icon(Icons.edit, color: Colors.purple.shade700),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Edit Sale',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _invoiceNumberController,
              decoration: const InputDecoration(
                labelText: 'Invoice Number *',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Required' : null,
            ),
            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Invoice Date *',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'Pick invoice date',
                  onPressed: () => _pickDate(_dateController),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Required';
                return _parseIsoDate(value) == null ? 'Use YYYY-MM-DD' : null;
              },
            ),
            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),
            TextFormField(
              controller: _dueDateController,
              decoration: InputDecoration(
                labelText: 'Due Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'Pick due date',
                  onPressed: () => _pickDate(_dueDateController),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                return _parseIsoDate(value) == null ? 'Use YYYY-MM-DD' : null;
              },
            ),
            SizedBox(height: AppSpacing.getFormFieldSpacing(context)),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: _isSaving ? null : _save,
          icon: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.check),
          label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
        ),
      ],
    );
  }
}
