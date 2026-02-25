import 'package:flutter/foundation.dart';
import 'user_role.dart';

/// A named dashboard preset that lists module IDs visible to a given role.
@immutable
class DashboardPreset {
  const DashboardPreset({
    required this.presetId,
    required this.displayName,
    required this.role,
    required this.moduleIds,
  });

  /// Unique identifier for this preset.
  final String presetId;

  /// Human-readable name.
  final String displayName;

  /// The [UserRole] this preset targets.
  final UserRole role;

  /// Ordered list of module IDs to display.
  final List<String> moduleIds;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardPreset &&
          runtimeType == other.runtimeType &&
          presetId == other.presetId;

  @override
  int get hashCode => presetId.hashCode;
}
