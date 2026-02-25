import 'package:flutter/foundation.dart';

/// Layout dimension tokens for a brand.
@immutable
class LayoutConfig {
  const LayoutConfig({
    this.sidebarWidth = 256,
    this.collapsedSidebarWidth = 72,
    this.headerHeight = 64,
  });

  /// Width of the expanded sidebar in logical pixels.
  final double sidebarWidth;

  /// Width of the collapsed sidebar in logical pixels.
  final double collapsedSidebarWidth;

  /// Height of the top app bar / header in logical pixels.
  final double headerHeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayoutConfig &&
          runtimeType == other.runtimeType &&
          sidebarWidth == other.sidebarWidth &&
          collapsedSidebarWidth == other.collapsedSidebarWidth &&
          headerHeight == other.headerHeight;

  @override
  int get hashCode =>
      Object.hash(sidebarWidth, collapsedSidebarWidth, headerHeight);
}
