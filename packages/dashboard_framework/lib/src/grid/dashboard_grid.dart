import 'package:flutter/widgets.dart';
import 'package:core_engine/core_engine.dart';

/// A responsive grid that adjusts column count based on screen width.
class DashboardGrid extends StatelessWidget {
  const DashboardGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.largeDesktopColumns = 4,
  });

  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final int largeDesktopColumns;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final spacing = tokens.spacing;
    final width = MediaQuery.of(context).size.width;

    final columns = Breakpoints.isMobile(width)
        ? mobileColumns
        : Breakpoints.isTablet(width)
            ? tabletColumns
            : Breakpoints.isLargeDesktop(width)
                ? largeDesktopColumns
                : desktopColumns;

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing.lg,
          mainAxisSpacing: spacing.lg,
          childAspectRatio: 1.6,
        ),
        itemCount: children.length,
        itemBuilder: (_, i) => children[i],
      ),
    );
  }
}
