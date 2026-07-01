import 'package:flutter/material.dart';
import '../../models/workspace_models.dart';
import '../../database/database.dart';
import 'navigator_row.dart';

/// Navigator pane widget displaying a scrollable list of customers
/// with expandable rows
class NavigatorPane extends StatefulWidget {
  final List<NavigatorItem> items;
  final String? selectedItemId;
  final ValueChanged<String> onItemSelected;
  final ValueChanged<String>? onItemDoubleClick;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onAddCustomer;
  final VoidCallback? onImportCSV;
  final VoidCallback? onExportCSV;
  final Function(String customerId)? onEditCustomer;
  final Function(String customerId, double creditLimit)? onCreditLimitChanged;
  final Map<String, PeopleData>? customerDataMap;

  const NavigatorPane({
    super.key,
    required this.items,
    this.selectedItemId,
    required this.onItemSelected,
    this.onItemDoubleClick,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
    this.onAddCustomer,
    this.onImportCSV,
    this.onExportCSV,
    this.onEditCustomer,
    this.onCreditLimitChanged,
    this.customerDataMap,
  });

  @override
  State<NavigatorPane> createState() => _NavigatorPaneState();
}

class _NavigatorPaneState extends State<NavigatorPane> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildColumnHeaders(context),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.people, size: 20),
              const SizedBox(width: 8),
              Text(
                'Customers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                '${widget.items.length}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onAddCustomer,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onImportCSV,
                  icon: const Icon(Icons.upload_file, size: 16),
                  label: const Text('Import'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onExportCSV,
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeaders(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'CUSTOMER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              'BALANCE',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              'LIMIT',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              'DUE',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 28), // Space for expand icon
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Show loading state
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show error state
    if (widget.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading customers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              if (widget.onRetry != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: widget.onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Show empty state
    if (widget.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No customers',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add a customer to get started',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      );
    }

    // Show customer list
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        final isSelected = item.id == widget.selectedItemId;
        final customerData = widget.customerDataMap?[item.id];

        return NavigatorRow(
          item: item,
          isSelected: isSelected,
          onTap: () => widget.onItemSelected(item.id),
          onDoubleTap: widget.onItemDoubleClick != null
              ? () => widget.onItemDoubleClick!(item.id)
              : null,
          onEdit: widget.onEditCustomer != null
              ? () => widget.onEditCustomer!(item.id)
              : null,
          onCreditLimitChanged: widget.onCreditLimitChanged != null
              ? (value) => widget.onCreditLimitChanged!(item.id, value)
              : null,
          customerData: customerData,
        );
      },
    );
  }
}
