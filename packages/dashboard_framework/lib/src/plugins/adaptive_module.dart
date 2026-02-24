import 'package:flutter/widgets.dart';
import '../roles/user_role.dart';

/// Abstract base class for pluggable dashboard modules.
///
/// Implement this to create a self-contained feature module that can be
/// registered with [ModuleRegistry] and mounted in a dashboard.
abstract class AdaptiveModule {
  const AdaptiveModule();

  /// Unique machine-readable identifier (e.g. `'analytics_overview'`).
  String get moduleId;

  /// Human-readable title shown in navigation and headers.
  String get displayName;

  /// The roles that are allowed to see this module.
  List<UserRole> get allowedRoles;

  /// Builds the primary content widget for this module.
  Widget buildContent(BuildContext context);

  /// Optional icon shown in navigation.
  Widget? buildIcon(BuildContext context) => null;
}
