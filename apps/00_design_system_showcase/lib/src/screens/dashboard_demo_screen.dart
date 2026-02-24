import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';
import 'package:branding_engine/branding_engine.dart';
import 'package:dashboard_framework/dashboard_framework.dart';

/// Demonstrates the adaptive dashboard shell with navigation.
class DashboardDemoScreen extends StatefulWidget {
  const DashboardDemoScreen({super.key});

  @override
  State<DashboardDemoScreen> createState() => _DashboardDemoScreenState();
}

class _DashboardDemoScreenState extends State<DashboardDemoScreen> {
  int _selectedIndex = 0;

  static const _destinations = [
    DashboardDestination(
      label: 'Overview',
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
    ),
    DashboardDestination(
      label: 'Analytics',
      icon: Icon(Icons.bar_chart_outlined),
      selectedIcon: Icon(Icons.bar_chart),
    ),
    DashboardDestination(
      label: 'Settings',
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    final bodies = [
      _OverviewBody(colors: colors, spacing: spacing, typography: typography),
      _AnalyticsBody(colors: colors, spacing: spacing, typography: typography),
      _SettingsBody(colors: colors, spacing: spacing, typography: typography),
    ];

    return BrandResolver(
      brand: BrandRegistry.instance.find('internal_default') ?? defaultBrand,
      child: DashboardShell(
        destinations: _destinations,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        appBarTitle: const Text('Dashboard Demo'),
        body: bodies[_selectedIndex],
      ),
    );
  }
}

class _OverviewBody extends StatelessWidget {
  const _OverviewBody(
      {required this.colors, required this.spacing, required this.typography});

  final ColorTokens colors;
  final SpacingTokens spacing;
  final TypographyTokens typography;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Overview',
              style: typography.headlineMedium
                  .copyWith(color: colors.textPrimary)),
          SizedBox(height: spacing.lg),
          DashboardGrid(
            children: List.generate(
              6,
              (i) => Card(
                color: colors.surface,
                child: Center(
                  child: Text('Widget ${i + 1}',
                      style: typography.titleMedium
                          .copyWith(color: colors.textPrimary)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  const _AnalyticsBody(
      {required this.colors, required this.spacing, required this.typography});

  final ColorTokens colors;
  final SpacingTokens spacing;
  final TypographyTokens typography;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Analytics (placeholder)',
          style: typography.bodyLarge.copyWith(color: colors.textSecondary)),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody(
      {required this.colors, required this.spacing, required this.typography});

  final ColorTokens colors;
  final SpacingTokens spacing;
  final TypographyTokens typography;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings (placeholder)',
          style: typography.bodyLarge.copyWith(color: colors.textSecondary)),
    );
  }
}
