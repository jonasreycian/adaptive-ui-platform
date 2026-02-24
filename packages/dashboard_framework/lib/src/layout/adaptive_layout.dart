import 'package:flutter/widgets.dart';
import 'package:core_engine/core_engine.dart';

/// A utility widget that renders [mobile], [tablet], or [desktop] based on
/// the available width, using [Breakpoints] thresholds.
class AdaptiveLayout extends StatelessWidget {
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  });

  final Widget mobile;
  final Widget desktop;
  final Widget? tablet;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (Breakpoints.isMobile(width)) return mobile;
    if (Breakpoints.isTablet(width)) return tablet ?? desktop;
    return desktop;
  }
}
