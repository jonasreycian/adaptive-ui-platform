import 'package:flutter/foundation.dart';

/// Spacing scale tokens (logical pixels).
///
/// xs   =  4 dp
/// sm   =  8 dp
/// md   = 12 dp
/// lg   = 16 dp
/// xl   = 24 dp
/// xxl  = 32 dp
/// xxxl = 48 dp
@immutable
class SpacingTokens {
  const SpacingTokens();

  double get xs => 4;
  double get sm => 8;
  double get md => 12;
  double get lg => 16;
  double get xl => 24;
  double get xxl => 32;
  double get xxxl => 48;

  static const SpacingTokens instance = SpacingTokens();
}
