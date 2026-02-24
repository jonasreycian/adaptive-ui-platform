import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

/// A navigation item descriptor.
class AdaptiveNavItem {
  const AdaptiveNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
  });

  final String label;
  final Widget icon;
  final Widget? activeIcon;
}

/// A token-driven bottom navigation bar.
class AdaptiveNavigationBar extends StatelessWidget {
  const AdaptiveNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AdaptiveNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.textSecondary,
      type: BottomNavigationBarType.fixed,
      items: items
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.icon,
              activeIcon: item.activeIcon ?? item.icon,
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}
