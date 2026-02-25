import 'package:flutter/widgets.dart';
import 'adaptive_platform.dart';

/// A widget that renders different children based on the current platform.
///
/// Falls back to [defaultChild] when no specific platform builder is provided.
class AdaptiveRender extends StatelessWidget {
  const AdaptiveRender({
    super.key,
    required this.defaultChild,
    this.mobile,
    this.tablet,
    this.desktop,
    this.web,
  });

  final Widget defaultChild;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? web;

  @override
  Widget build(BuildContext context) {
    if (AdaptivePlatformDetector.isWeb && web != null) return web!;
    if (AdaptivePlatformDetector.isMobile && mobile != null) return mobile!;
    if (AdaptivePlatformDetector.isDesktop && desktop != null) return desktop!;
    return defaultChild;
  }
}
