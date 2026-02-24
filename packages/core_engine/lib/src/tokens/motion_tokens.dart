import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// Motion (animation) tokens.
///
/// Durations:
///   fast   = 150 ms
///   normal = 300 ms
///   slow   = 500 ms
///
/// Curves:
///   easeInOut    = Curves.easeInOut
///   easeOutCubic = Curves.easeOutCubic
@immutable
class MotionTokens {
  const MotionTokens();

  Duration get fast => const Duration(milliseconds: 150);
  Duration get normal => const Duration(milliseconds: 300);
  Duration get slow => const Duration(milliseconds: 500);

  Curve get easeInOut => Curves.easeInOut;
  Curve get easeOutCubic => Curves.easeOutCubic;

  static const MotionTokens instance = MotionTokens();
}
