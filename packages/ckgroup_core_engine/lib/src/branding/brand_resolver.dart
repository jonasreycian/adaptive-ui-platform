import 'package:flutter/widgets.dart';
import 'brand_config.dart';

/// An [InheritedWidget] that provides the active [BrandConfig] to the tree.
///
/// Obtain via [BrandResolver.of(context)].
class BrandResolver extends InheritedWidget {
  const BrandResolver({
    super.key,
    required this.brand,
    required super.child,
  });

  final BrandConfig brand;

  /// Looks up the nearest [BrandResolver] in the widget tree.
  ///
  /// Throws a [FlutterError] if none is found.
  static BrandResolver of(BuildContext context) {
    final BrandResolver? result =
        context.dependOnInheritedWidgetOfExactType<BrandResolver>();
    assert(result != null, 'No BrandResolver found in context');
    return result!;
  }

  /// Returns null if no [BrandResolver] is in scope.
  static BrandResolver? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BrandResolver>();

  @override
  bool updateShouldNotify(BrandResolver oldWidget) => brand != oldWidget.brand;
}
