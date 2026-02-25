import 'package:flutter/foundation.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

/// Configuration for a single brand.
@immutable
class BrandConfig {
  const BrandConfig({
    required this.brandId,
    required this.displayName,
    required this.lightTokens,
    required this.darkTokens,
    this.logoAsset,
    this.layoutConfig = const LayoutConfig(),
    this.featureFlags = const {},
  });

  /// Unique identifier for this brand (e.g. `'internal_default'`).
  final String brandId;

  /// Human-readable brand name.
  final String displayName;

  /// Color tokens for light mode.
  final ColorTokens lightTokens;

  /// Color tokens for dark mode.
  final ColorTokens darkTokens;

  /// Optional path to a logo asset bundled with the consuming app.
  final String? logoAsset;

  /// Layout dimensions specific to this brand.
  final LayoutConfig layoutConfig;

  /// Arbitrary feature flags for conditional UI behaviour.
  final Map<String, bool> featureFlags;

  /// Returns [lightTokens] or [darkTokens] based on [isDark].
  ColorTokens resolveColors({required bool isDark}) =>
      isDark ? darkTokens : lightTokens;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandConfig &&
          runtimeType == other.runtimeType &&
          brandId == other.brandId;

  @override
  int get hashCode => brandId.hashCode;
}
