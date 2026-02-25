import 'package:flutter/foundation.dart';

/// Border-radius tokens (logical pixels).
///
/// sm =  4 dp
/// md =  8 dp
/// lg = 12 dp
/// xl = 20 dp
@immutable
class RadiusTokens {
  const RadiusTokens();

  double get sm => 4;
  double get md => 8;
  double get lg => 12;
  double get xl => 20;

  static const RadiusTokens instance = RadiusTokens();
}
