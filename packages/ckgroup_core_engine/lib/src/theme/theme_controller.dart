import 'package:flutter/foundation.dart';
import '../tokens/adaptive_token_set.dart';
import '../tokens/color_tokens.dart';

/// A [ChangeNotifier] that manages the active theme mode and exposes
/// the resolved [ColorTokens] for the current mode.
///
/// ```dart
/// final controller = ThemeController();
/// controller.toggleDark();
/// ```
class ThemeController extends ChangeNotifier {
  ThemeController({
    AdaptiveTokenSet tokenSet = AdaptiveTokenSet.defaultSet,
    bool initialDark = false,
  })  : _tokenSet = tokenSet,
        _isDark = initialDark;

  AdaptiveTokenSet _tokenSet;
  bool _isDark;

  bool get isDark => _isDark;

  ColorTokens get colors => _tokenSet.resolve(isDark: _isDark);

  AdaptiveTokenSet get tokenSet => _tokenSet;

  /// Switches to dark mode.
  void setDark() {
    if (!_isDark) {
      _isDark = true;
      notifyListeners();
    }
  }

  /// Switches to light mode.
  void setLight() {
    if (_isDark) {
      _isDark = false;
      notifyListeners();
    }
  }

  /// Toggles between light and dark mode.
  void toggleDark() {
    _isDark = !_isDark;
    notifyListeners();
  }

  /// Replaces the active [AdaptiveTokenSet] and notifies listeners.
  void updateTokenSet(AdaptiveTokenSet tokenSet) {
    if (_tokenSet != tokenSet) {
      _tokenSet = tokenSet;
      notifyListeners();
    }
  }
}
