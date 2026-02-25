import 'package:flutter/widgets.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

/// Signature for a builder that receives the current [ScreenSize].
typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  ScreenSize screenSize,
  double width,
);

/// The resolved screen-size category.
enum ScreenSize { mobile, tablet, desktop, largeDesktop }

/// Builds its child by calling [builder] with the resolved [ScreenSize].
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final ResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ScreenSize size;

    if (Breakpoints.isMobile(width)) {
      size = ScreenSize.mobile;
    } else if (Breakpoints.isTablet(width)) {
      size = ScreenSize.tablet;
    } else if (Breakpoints.isLargeDesktop(width)) {
      size = ScreenSize.largeDesktop;
    } else {
      size = ScreenSize.desktop;
    }

    return builder(context, size, width);
  }
}
