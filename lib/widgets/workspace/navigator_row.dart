import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/workspace_models.dart';
import '../../utils/responsive_utils.dart';
import '../../database/database.dart';
import '../../features/customers/widgets/workbench_card.dart';

/// Individual customer row in the navigator pane
/// Expandable row with risk indicator, customer info, financial summary, and inline editors
class NavigatorRow extends StatefulWidget {
  final NavigatorItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onEdit;
  final Function(double)? onCreditLimitChanged;
  final PeopleData? customerData;

  const NavigatorRow({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.onDoubleTap,
    this.onEdit,
    this.onCreditLimitChanged,
    this.customerData,
  });

  @override
  State<NavigatorRow> createState() => _NavigatorRowState();
}

class _NavigatorRowState extends State<NavigatorRow> {
  bool _isHovered = false;
  bool _isExpanded = false;
  final _dateFormat = DateFormat('dd/MM');
  final _fullDateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            onDoubleTap: widget.onDoubleTap,
            child: Container(
              decoration: BoxDecoration(
                color: _getRowColor(),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 10,
                  vertical: isMobile ? 12 : 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCustomerInfo(isMobile),
                    ),
                    const SizedBox(width: 12),
                    _buildFinancialInfo(isMobile),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _isExpanded = !_isExpanded),
                      tooltip: _isExpanded ? 'Collapse' : 'Expand',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded) _buildExpandedSection(isMobile),
        ],
      ),
    );
  }

  Color _getRowColor() {
    // Traffic light system: Green/Amber/Red/Grey
    if (widget.isSelected) {
      return Colors.blue.shade50;
    }

    // Grey for zero balance
    if (widget.item.balance <= 0.01) {
      if (_isHovered) {
        return Colors.grey.shade100;
      }
      return Colors.grey.shade50;
    }

    // Use the risk color with appropriate opacity
    final baseColor = widget.item.riskColor;
    if (_isHovered) {
      return baseColor.withValues(alpha: 0.15);
    }
    return baseColor.withValues(alpha: 0.1);
  }

  Color _getBalanceTextColor() {
    // Balance text color complements the bar color
    if (widget.item.balance <= 0.01) {
      return Colors.grey.shade600;
    }

    // Use darker shade of the risk color for text
    switch (widget.item.status) {
      case NavigatorItemStatus.normal:
        return Colors.green.shade800;
      case NavigatorItemStatus.dueSoon:
        return Colors.amber.shade900;
      case NavigatorItemStatus.overdue:
      case NavigatorItemStatus.overLimit:
        return Colors.red.shade800;
    }
  }

  Widget _buildCustomerInfo(bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.item.primaryText,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: isMobile ? 16 : 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.item.hasActiveFinance) ...[
          const SizedBox(width: 6),
          Tooltip(
            message: 'Active finance',
            child: Icon(
              Icons.account_balance,
              size: 15,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFinancialInfo(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Balance - larger and colored to stand out
        SizedBox(
          width: 90,
          child: Text(
            '£${widget.item.balance.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: isMobile ? 17.0 : 16.0, // Larger than other columns
              color: _getBalanceTextColor(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Credit Limit - smaller, grey
        SizedBox(
          width: 80,
          child: Text(
            '£${widget.item.creditLimit.toStringAsFixed(0)}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 14.0 : 13.0,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Due Date - smaller, grey
        SizedBox(
          width: 70,
          child: Text(
            widget.item.dueDate != null
                ? _dateFormat.format(widget.item.dueDate!)
                : '-',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 14.0 : 13.0,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedSection(bool isMobile) {
    // Use slightly darker shade for expanded section
    Color expandedBgColor;
    if (widget.item.balance <= 0.01) {
      expandedBgColor = Colors.grey.shade100;
    } else {
      expandedBgColor = widget.item.riskColor.withValues(alpha: 0.18);
    }

    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 10),
      decoration: BoxDecoration(
        color: expandedBgColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InlineMoneyEditor(
                  label: 'Credit Limit',
                  value: widget.item.creditLimit,
                  onSaved: (value) {
                    if (widget.onCreditLimitChanged != null) {
                      widget.onCreditLimitChanged!(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InlineDateEditor(
                  label: 'Due Date',
                  value: widget.item.dueDate,
                  formatter: _fullDateFormat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit Customer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
