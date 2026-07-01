import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Defines the user-editable thresholds for the "Traffic Light" system.
class StatusSettings {
  final int amberLeadDays;
  final int amberGraceDays;

  const StatusSettings({
    this.amberLeadDays = 3,
    this.amberGraceDays = 3,
  });
}

/// Helper to determine the row color based on business logic.
class StatusLogic {
  static Color getColor({
    required DateTime dueDate,
    required double balance,
    required double creditLimit,
    required StatusSettings settings,
  }) {
    final now = DateTime.now();
    final daysUntilDue =
        dueDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    // 1. Red: Over Credit Limit OR Past Grace Period
    if (balance > creditLimit || daysUntilDue < -settings.amberGraceDays) {
      return Colors.redAccent;
    }

    // 2. Amber: 3 days before OR up to 3 days after (Grace Period)
    if (daysUntilDue <= settings.amberLeadDays &&
        daysUntilDue >= -settings.amberGraceDays) {
      return Colors.orangeAccent;
    }

    // 3. Green: Within terms
    if (balance > 0) {
      return Colors.greenAccent;
    }

    return Colors.grey.withValues(alpha: 0.5);
  }
}

/// Enhanced Shell for Workspace panels with optional Status Indicator.
class WorkbenchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final Color bodyColor;
  final Color borderColor;
  final Widget child;
  final Color? statusColor; // Added for the traffic light logic

  const WorkbenchCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.bodyColor,
    required this.borderColor,
    required this.child,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      color: bodyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: statusColor ?? borderColor,
          width: statusColor != null ? 2.0 : 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: statusColor ??
                accentColor, // Header reflects status if provided
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withAlpha(210),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ColoredBox(
            color: bodyColor,
            child: Padding(padding: const EdgeInsets.all(10), child: child),
          ),
        ],
      ),
    );
  }
}

// ── Inline Editors (Preserved functionality) ─────────────────────────────────

class InlineMoneyEditor extends StatefulWidget {
  final String label;
  final double value;
  final ValueChanged<double> onSaved;

  const InlineMoneyEditor({
    super.key,
    required this.label,
    required this.value,
    required this.onSaved,
  });

  @override
  State<InlineMoneyEditor> createState() => _InlineMoneyEditorState();
}

class _InlineMoneyEditorState extends State<InlineMoneyEditor> {
  late final TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(covariant InlineMoneyEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && !_isSaving) {
      _controller.text = widget.value.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final cleaned = _controller.text.replaceAll('£', '').replaceAll(',', '');
    final value = double.tryParse(cleaned);
    if (value == null) return;
    setState(() => _isSaving = true);
    widget.onSaved(value);
    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(fontSize: 14),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onSubmitted: (_) => _save(),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixText: '£',
        isDense: true,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check, size: 20),
          onPressed: _isSaving ? null : _save,
        ),
      ),
    );
  }
}

class InlineDateEditor extends StatelessWidget {
  final String label;
  final DateTime? value;
  final DateFormat formatter;

  const InlineDateEditor({
    super.key,
    required this.label,
    required this.value,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        border: const OutlineInputBorder(),
      ),
      child: Text(
        value == null ? '-' : formatter.format(value!),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
