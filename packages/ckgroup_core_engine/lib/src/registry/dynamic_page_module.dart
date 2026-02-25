import 'package:flutter/material.dart';

import '../plugins/adaptive_module.dart';
import '../roles/user_role.dart';
import 'page_entry.dart';

/// A concrete [AdaptiveModule] built from a [PageEntry].
///
/// Role membership is determined by string matching (case-insensitive) against
/// [PageEntry.roles], so custom roles such as `"LoanSupervisor"` work without
/// changes to the [UserRole] enum.
class DynamicPageModule extends AdaptiveModule {
  const DynamicPageModule({required this.entry});

  /// The [PageEntry] that describes this page.
  final PageEntry entry;

  // ── AdaptiveModule ──────────────────────────────────────────────────────────

  @override
  String get moduleId => entry.route;

  @override
  String get displayName => entry.pageName;

  /// For dynamic modules, [allowedRoles] is always empty — role access is
  /// governed entirely by [allowedRoleNames].
  @override
  List<UserRole> get allowedRoles => const [];

  /// Case-normalised role names from [PageEntry.roles].
  @override
  List<String> get allowedRoleNames =>
      entry.roles.map((r) => r.toLowerCase()).toList();

  @override
  Widget buildContent(BuildContext context) => _DynamicPagePlaceholder(
        pageName: entry.pageName,
      );

  @override
  Widget? buildIcon(BuildContext context) => Icon(_resolveIcon(entry.iconName));

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static IconData _resolveIcon(String? name) {
    switch (name?.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'dashboard':
        return Icons.dashboard_outlined;
      case 'settings':
        return Icons.settings_outlined;
      case 'person':
        return Icons.person_outlined;
      case 'analytics':
        return Icons.analytics_outlined;
      case 'payment':
      case 'payments':
        return Icons.payments_outlined;
      case 'description':
      case 'document':
        return Icons.description_outlined;
      case 'loan':
      case 'loans':
        return Icons.account_balance_outlined;
      case 'report':
      case 'reports':
        return Icons.bar_chart_outlined;
      default:
        return Icons.widgets_outlined;
    }
  }
}

// ── Placeholder widget ───────────────────────────────────────────────────────

class _DynamicPagePlaceholder extends StatelessWidget {
  const _DynamicPagePlaceholder({required this.pageName});

  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.widgets_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            pageName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Dynamically registered page',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
