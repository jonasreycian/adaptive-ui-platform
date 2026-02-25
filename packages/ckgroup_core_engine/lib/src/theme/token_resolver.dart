import 'package:flutter/widgets.dart';
import '../tokens/color_tokens.dart';
import '../tokens/spacing_tokens.dart';
import '../tokens/typography_tokens.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/elevation_tokens.dart';
import '../tokens/motion_tokens.dart';

/// An [InheritedWidget] that exposes resolved design tokens to the widget tree.
///
/// Obtain via [TokenResolver.of(context)].
class TokenResolver extends InheritedWidget {
  const TokenResolver({
    super.key,
    required this.colors,
    required this.spacing,
    required this.typography,
    required this.radius,
    required this.elevation,
    required this.motion,
    required super.child,
  });

  final ColorTokens colors;
  final SpacingTokens spacing;
  final TypographyTokens typography;
  final RadiusTokens radius;
  final ElevationTokens elevation;
  final MotionTokens motion;

  /// Looks up the nearest [TokenResolver] in the widget tree.
  ///
  /// Throws a [FlutterError] if no [TokenResolver] is found.
  static TokenResolver of(BuildContext context) {
    final TokenResolver? result =
        context.dependOnInheritedWidgetOfExactType<TokenResolver>();
    assert(result != null, 'No TokenResolver found in context');
    return result!;
  }

  /// Returns null if no [TokenResolver] is found in the tree.
  static TokenResolver? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<TokenResolver>();

  @override
  bool updateShouldNotify(TokenResolver oldWidget) =>
      colors != oldWidget.colors ||
      spacing != oldWidget.spacing ||
      typography != oldWidget.typography ||
      radius != oldWidget.radius ||
      elevation != oldWidget.elevation ||
      motion != oldWidget.motion;
}
