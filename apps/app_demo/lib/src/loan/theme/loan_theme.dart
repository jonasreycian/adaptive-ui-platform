// Non-platform colours and const token mirrors for the Loan Origination
// section.  Platform tokens (primary, accent, surface, etc.) are always
// consumed via TokenResolver.of(context) so that the UI responds to theme
// and brand changes at runtime.

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Loan-specific semantic colours (not in the platform token set)
// ---------------------------------------------------------------------------
class LoanColors {
  LoanColors._();

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF0277BD);

  // App-specific tints that complement the platform primary/accent
  static const Color primaryLight = Color(0xFF0A5445);
  static const Color primaryDark = Color(0xFF021D18);
  static const Color accentLight = Color(0xFFF2D070);
  static const Color accentDark = Color(0xFFB88F1A);

  // Surface & border variants specific to the LOS screens
  static const Color surfaceVariant = Color(0xFFEEF2F0);
  static const Color border = Color(0xFFD0D9D6);
  static const Color divider = Color(0xFFE0E8E5);
  static const Color textDisabled = Color(0xFFA0B5B0);
}

// ---------------------------------------------------------------------------
// Spacing — const mirrors of platform SpacingTokens (for use in const ctors)
// ---------------------------------------------------------------------------
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

// ---------------------------------------------------------------------------
// Radius — const mirrors of platform RadiusTokens
// ---------------------------------------------------------------------------
class AppRadius {
  AppRadius._();

  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 20.0;
  static const double full = 999.0;
}

// ---------------------------------------------------------------------------
// Motion — const mirrors of platform MotionTokens
// ---------------------------------------------------------------------------
class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve standard = Curves.easeInOut;
  static const Curve decelerate = Curves.easeOutCubic;
}
