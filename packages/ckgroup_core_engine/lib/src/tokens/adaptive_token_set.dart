import 'package:flutter/foundation.dart';
import 'color_tokens.dart';

/// Holds both the light and dark [ColorTokens] variants for a brand.
@immutable
class AdaptiveTokenSet {
  const AdaptiveTokenSet({
    required this.light,
    required this.dark,
  });

  final ColorTokens light;
  final ColorTokens dark;

  /// The default built-in token set.
  static const AdaptiveTokenSet defaultSet = AdaptiveTokenSet(
    light: ColorTokens.light,
    dark: ColorTokens.dark,
  );

  /// Returns [light] or [dark] based on [isDark].
  ColorTokens resolve({required bool isDark}) => isDark ? dark : light;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveTokenSet &&
          runtimeType == other.runtimeType &&
          light == other.light &&
          dark == other.dark;

  @override
  int get hashCode => Object.hash(light, dark);
}
