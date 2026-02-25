import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'token_inspector_screen.dart';
import 'component_demo_screen.dart';
import 'dashboard_demo_screen.dart';
import 'brand_switcher_screen.dart';
import '../loan/screens/loan_origination_screen.dart';

/// The home screen showing navigation to all showcase demos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    final demos = [
      _DemoEntry(
        title: 'Token Inspector',
        subtitle: 'Browse all design tokens',
        icon: Icons.palette_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const TokenInspectorScreen(),
          ),
        ),
      ),
      _DemoEntry(
        title: 'Components',
        subtitle: 'Buttons, inputs, dialogs',
        icon: Icons.widgets_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const ComponentDemoScreen(),
          ),
        ),
      ),
      _DemoEntry(
        title: 'Dashboard',
        subtitle: 'Shell, grid, navigation',
        icon: Icons.dashboard_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const DashboardDemoScreen(),
          ),
        ),
      ),
      _DemoEntry(
        title: 'Brand Switcher',
        subtitle: 'Runtime brand switching',
        icon: Icons.swap_horiz,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const BrandSwitcherScreen(),
          ),
        ),
      ),
      _DemoEntry(
        title: 'Loan Application',
        subtitle: 'Multi-step loan origination workflow',
        icon: Icons.account_balance_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const LoanOriginationScreen(),
          ),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        title: Text('Adaptive UI Showcase', style: typography.titleLarge),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeController.isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: themeController.toggleDark,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(spacing.lg),
        itemCount: demos.length,
        separatorBuilder: (_, __) => SizedBox(height: spacing.md),
        itemBuilder: (context, index) {
          final demo = demos[index];
          return Card(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.radius.md),
            ),
            elevation: tokens.elevation.sm,
            child: ListTile(
              leading: Icon(demo.icon, color: colors.primary),
              title: Text(demo.title,
                  style: typography.titleMedium
                      .copyWith(color: colors.textPrimary)),
              subtitle: Text(demo.subtitle,
                  style: typography.bodySmall
                      .copyWith(color: colors.textSecondary)),
              trailing: Icon(Icons.chevron_right, color: colors.textSecondary),
              onTap: demo.onTap,
            ),
          );
        },
      ),
    );
  }
}

class _DemoEntry {
  const _DemoEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
}
