import 'package:flutter/material.dart';
import '../../models/workspace_models.dart';

/// Workspace pane widget displaying tabbed content for the selected customer
class WorkspacePane extends StatefulWidget {
  final WorkspaceContent? content;
  final VoidCallback? onRefresh;
  final bool isLoading;
  final String? errorMessage;

  const WorkspacePane({
    super.key,
    this.content,
    this.onRefresh,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  State<WorkspacePane> createState() => _WorkspacePaneState();
}

class _WorkspacePaneState extends State<WorkspacePane>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  @override
  void didUpdateWidget(covariant WorkspacePane oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Rebuild controller only if content changed
    if (widget.content != oldWidget.content) {
      _rebuildTabController();
    }
  }

  void _rebuildTabController() {
    // Clean up old controller safely
    _disposeTabController();

    if (widget.content == null || widget.content!.tabs.isEmpty) {
      _tabController = null;
      _currentTabIndex = 0;
      return;
    }

    // Ensure index stays within bounds
    final tabCount = widget.content!.tabs.length;

    if (_currentTabIndex >= tabCount) {
      _currentTabIndex = 0;
    }

    _tabController = TabController(
      length: tabCount,
      vsync: this,
      initialIndex: _currentTabIndex,
    );

    _tabController!.addListener(_handleTabChange);
  }

  void _initializeTabController() {
    if (widget.content == null || widget.content!.tabs.isEmpty) {
      return;
    }

    _tabController = TabController(
      length: widget.content!.tabs.length,
      vsync: this,
      initialIndex: _currentTabIndex,
    );

    _tabController!.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!mounted || _tabController == null) {
      return;
    }

    if (!_tabController!.indexIsChanging) {
      final newIndex = _tabController!.index;

      if (_currentTabIndex != newIndex) {
        setState(() {
          _currentTabIndex = newIndex;
        });
      }
    }
  }

  void _disposeTabController() {
    if (_tabController != null) {
      _tabController!.removeListener(_handleTabChange);
      _tabController!.dispose();
      _tabController = null;
    }
  }

  @override
  void dispose() {
    _disposeTabController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.content != null && _tabController != null)
            Expanded(
              child: TabBar(
                controller: _tabController,
                tabs: widget.content!.tabs.map((tab) {
                  return Tab(
                    icon: Icon(tab.icon, size: 18),
                    text: tab.label,
                  );
                }).toList(),
                labelColor: Colors.blue.shade700,
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: Colors.blue.shade700,
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Workspace',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

          // Refresh button
          if (widget.onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: widget.onRefresh,
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Loading state
    if (widget.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error state
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
                'Error loading content',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              if (widget.onRefresh != null) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: widget.onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Empty state
    if (widget.content == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Select a customer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Click on a customer from the list to view details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Safety fallback
    if (_tabController == null || widget.content!.tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return TabBarView(
      controller: _tabController,
      children: widget.content!.tabs
          .map((tab) => tab.content)
          .toList(),
    );
  }
}