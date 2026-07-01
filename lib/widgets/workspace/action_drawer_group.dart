import 'package:flutter/material.dart';
import 'action_drawer.dart';

/// Group of action drawers with mutual exclusion logic
/// When one drawer expands, others collapse (if allowMultipleExpanded is false)
class ActionDrawerGroup extends StatefulWidget {
  final List<ActionDrawer> drawers;
  final bool allowMultipleExpanded;

  const ActionDrawerGroup({
    super.key,
    required this.drawers,
    this.allowMultipleExpanded = false,
  });

  @override
  State<ActionDrawerGroup> createState() => _ActionDrawerGroupState();
}

class _ActionDrawerGroupState extends State<ActionDrawerGroup> {
  final List<GlobalKey<ActionDrawerState>> _drawerKeys = [];
  int? _expandedDrawerIndex;

  @override
  void initState() {
    super.initState();
    _initializeKeys();
  }

  @override
  void didUpdateWidget(ActionDrawerGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.drawers.length != oldWidget.drawers.length) {
      _initializeKeys();
    }
  }

  void _initializeKeys() {
    _drawerKeys.clear();
    for (final drawer in widget.drawers) {
      final key = drawer.key;
      if (key is GlobalKey<ActionDrawerState>) {
        _drawerKeys.add(key);
      } else {
        _drawerKeys.add(GlobalKey<ActionDrawerState>());
      }
    }
  }

  void _handleExpansionChanged(int index, bool isExpanded) {
    if (!widget.allowMultipleExpanded && isExpanded) {
      // Collapse all other drawers
      for (int i = 0; i < _drawerKeys.length; i++) {
        if (i != index) {
          _drawerKeys[i].currentState?.collapse();
        }
      }
      setState(() {
        _expandedDrawerIndex = index;
      });
    } else if (!isExpanded && _expandedDrawerIndex == index) {
      setState(() {
        _expandedDrawerIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.drawers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.drawers.length,
        (index) {
          final drawer = widget.drawers[index];
          return ActionDrawer(
            key: _drawerKeys[index],
            title: drawer.title,
            icon: drawer.icon,
            accentColor: drawer.accentColor,
            content: drawer.content,
            initiallyExpanded: drawer.initiallyExpanded,
            onSaved: drawer.onSaved,
            onExpansionChanged: (isExpanded) {
              _handleExpansionChanged(index, isExpanded);
              drawer.onExpansionChanged?.call(isExpanded);
            },
          );
        },
      ),
    );
  }
}
