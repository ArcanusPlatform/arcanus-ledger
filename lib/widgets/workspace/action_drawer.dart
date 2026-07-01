import 'package:flutter/material.dart';

/// Collapsible action drawer for transactional forms
/// Expands to show content, collapses after save
class ActionDrawer extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final Widget content;
  final bool initiallyExpanded;
  final VoidCallback? onSaved;
  final ValueChanged<bool>? onExpansionChanged;

  const ActionDrawer({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.content,
    this.initiallyExpanded = false,
    this.onSaved,
    this.onExpansionChanged,
  });

  @override
  State<ActionDrawer> createState() => ActionDrawerState();
}

class ActionDrawerState extends State<ActionDrawer>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Expand the drawer
  void expand() {
    if (!_isExpanded) {
      setState(() {
        _isExpanded = true;
      });
      _animationController.forward();
      widget.onExpansionChanged?.call(true);
    }
  }

  /// Collapse the drawer
  void collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
      });
      _animationController.reverse();
      widget.onExpansionChanged?.call(false);
    }
  }

  /// Toggle expansion state
  void toggle() {
    if (_isExpanded) {
      collapse();
    } else {
      expand();
    }
  }

  /// Handle save callback - collapse drawer after save
  void handleSave() {
    widget.onSaved?.call();
    collapse();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: _isExpanded ? 2 : 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizeTransition(
            sizeFactor: _animation,
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.accentColor.withAlpha(26),
          border: Border(
            left: BorderSide(
              color: widget.accentColor,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: widget.accentColor,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: widget.accentColor,
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.expand_more,
                color: widget.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: widget.content,
    );
  }
}
