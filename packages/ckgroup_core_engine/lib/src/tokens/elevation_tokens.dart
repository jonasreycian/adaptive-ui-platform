import 'package:flutter/foundation.dart';

/// Elevation (shadow depth) tokens.
@immutable
class ElevationTokens {
  const ElevationTokens();

  double get none => 0;
  double get xs => 1;
  double get sm => 2;
  double get md => 4;
  double get lg => 8;
  double get xl => 16;

  static const ElevationTokens instance = ElevationTokens();
}
