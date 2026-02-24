import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';
import 'package:branding_engine/branding_engine.dart';

/// The visual variant of the dashboard chrome.
enum DashboardShellVariant {
  /// Full sidebar (desktop ≥ 1024 px).
  sidebar,

  /// Navigation rail (tablet 600–1023 px).
  rail,

  /// Drawer (mobile < 600 px).
  drawer,
}

/// A destination entry in the dashboard navigation.
class DashboardDestination {
  const DashboardDestination({
    required this.label,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final Widget icon;
  final Widget? selectedIcon;
}

/// The adaptive dashboard shell.
///
/// * Mobile  → drawer navigation
/// * Tablet  → navigation rail
/// * Desktop → collapsible sidebar
class DashboardShell extends StatefulWidget {
  const DashboardShell({
    super.key,
    required this.destinations,
    required this.body,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.appBarTitle,
  });

  final List<DashboardDestination> destinations;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final Widget? appBarTitle;

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell>
    with SingleTickerProviderStateMixin {
  bool _sidebarCollapsed = false;

  late final AnimationController _collapseController;
  late final Animation<double> _collapseAnimation;

  @override
  void initState() {
    super.initState();
    _collapseController = AnimationController(
      vsync: this,
      duration: MotionTokens.instance.normal,
    );
    _collapseAnimation = CurvedAnimation(
      parent: _collapseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _collapseController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _sidebarCollapsed = !_sidebarCollapsed;
      if (_sidebarCollapsed) {
        _collapseController.forward();
      } else {
        _collapseController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final brand = BrandResolver.maybeOf(context)?.brand;
    final layout = brand?.layoutConfig ?? const LayoutConfig();

    if (Breakpoints.isMobile(width)) {
      return _buildDrawerVariant(colors, layout);
    } else if (Breakpoints.isTablet(width)) {
      return _buildRailVariant(colors);
    } else {
      return _buildSidebarVariant(colors, layout);
    }
  }

  // ── Mobile: drawer ──────────────────────────────────────────────────────────

  Widget _buildDrawerVariant(ColorTokens colors, LayoutConfig layout) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        title: widget.appBarTitle,
        elevation: 0,
      ),
      drawer: Drawer(
        backgroundColor: colors.surface,
        child: _buildDestinationList(colors, expanded: true),
      ),
      body: widget.body,
    );
  }

  // ── Tablet: rail ────────────────────────────────────────────────────────────

  Widget _buildRailVariant(ColorTokens colors) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        title: widget.appBarTitle,
        elevation: 0,
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: colors.surface,
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: widget.onDestinationSelected,
            selectedIconTheme: IconThemeData(color: colors.primary),
            unselectedIconTheme: IconThemeData(color: colors.textSecondary),
            selectedLabelTextStyle: TextStyle(color: colors.primary),
            unselectedLabelTextStyle: TextStyle(color: colors.textSecondary),
            destinations: widget.destinations
                .map(
                  (d) => NavigationRailDestination(
                    icon: d.icon,
                    selectedIcon: d.selectedIcon ?? d.icon,
                    label: Text(d.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.body),
        ],
      ),
    );
  }

  // ── Desktop: sidebar ────────────────────────────────────────────────────────

  Widget _buildSidebarVariant(ColorTokens colors, LayoutConfig layout) {
    return Scaffold(
      backgroundColor: colors.background,
      body: Row(
        children: [
          AnimatedBuilder(
            animation: _collapseAnimation,
            builder: (context, _) {
              final width = _sidebarCollapsed
                  ? layout.collapsedSidebarWidth
                  : layout.sidebarWidth;
              return AnimatedContainer(
                duration: MotionTokens.instance.normal,
                curve: Curves.easeInOut,
                width: width,
                color: colors.surface,
                child: Column(
                  children: [
                    SizedBox(height: layout.headerHeight),
                    Expanded(
                      child: _buildDestinationList(
                        colors,
                        expanded: !_sidebarCollapsed,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _sidebarCollapsed
                            ? Icons.chevron_right
                            : Icons.chevron_left,
                        color: colors.textSecondary,
                      ),
                      onPressed: _toggleSidebar,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: layout.headerHeight,
                  child: AppBar(
                    backgroundColor: colors.surface,
                    foregroundColor: colors.textPrimary,
                    title: widget.appBarTitle,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                  ),
                ),
                Expanded(child: widget.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationList(ColorTokens colors, {required bool expanded}) {
    return ListView.builder(
      itemCount: widget.destinations.length,
      itemBuilder: (context, index) {
        final dest = widget.destinations[index];
        final isSelected = index == widget.selectedIndex;
        return ListTile(
          selected: isSelected,
          selectedTileColor: colors.primary.withAlpha(30),
          leading: IconTheme(
            data: IconThemeData(
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            child: dest.selectedIcon != null && isSelected
                ? dest.selectedIcon!
                : dest.icon,
          ),
          title: expanded ? Text(dest.label) : null,
          textColor: isSelected ? colors.primary : colors.textSecondary,
          onTap: () => widget.onDestinationSelected?.call(index),
        );
      },
    );
  }
}
