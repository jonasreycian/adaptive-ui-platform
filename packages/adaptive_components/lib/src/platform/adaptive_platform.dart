import 'package:flutter/foundation.dart';

/// Enumerates the platforms supported by the adaptive UI platform.
enum AdaptivePlatform {
  android,
  ios,
  web,
  windows,
  macOS,
  linux,
  fuchsia,
  unknown,
}

/// Detects the current platform without accessing [dart:io] directly,
/// making it safe for web targets.
class AdaptivePlatformDetector {
  const AdaptivePlatformDetector._();

  /// Returns the [AdaptivePlatform] for the current runtime.
  static AdaptivePlatform get current {
    if (kIsWeb) return AdaptivePlatform.web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AdaptivePlatform.android;
      case TargetPlatform.iOS:
        return AdaptivePlatform.ios;
      case TargetPlatform.windows:
        return AdaptivePlatform.windows;
      case TargetPlatform.macOS:
        return AdaptivePlatform.macOS;
      case TargetPlatform.linux:
        return AdaptivePlatform.linux;
      case TargetPlatform.fuchsia:
        return AdaptivePlatform.fuchsia;
    }
  }

  static bool get isMobile {
    final p = current;
    return p == AdaptivePlatform.android || p == AdaptivePlatform.ios;
  }

  static bool get isDesktop {
    final p = current;
    return p == AdaptivePlatform.windows ||
        p == AdaptivePlatform.macOS ||
        p == AdaptivePlatform.linux;
  }

  static bool get isWeb => current == AdaptivePlatform.web;
}
