// Design tokens — all values sourced from the Adaptive UI Platform packages.
// Colour palette: core_engine ColorTokens.light
// Spacing scale:  core_engine SpacingTokens
// Typography:     core_engine TypographyTokens
// Radius:         core_engine RadiusTokens
// Motion:         core_engine MotionTokens

import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

// ---------------------------------------------------------------------------
// Color Tokens — delegates to the platform's ColorTokens.light palette.
// ---------------------------------------------------------------------------
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static Color primary = ColorTokens.light.primary;
  static const Color primaryLight = Color(0xFF0A5445); // app-specific tint
  static const Color primaryDark = Color(0xFF021D18); // platform background
  static Color accent = ColorTokens.light.accent;
  static const Color accentLight = Color(0xFFF2D070); // app-specific tint
  static const Color accentDark = Color(0xFFB88F1A); // app-specific tint

  // ── Semantic ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static Color error = ColorTokens.light.error;
  static const Color info = Color(0xFF0277BD);

  // ── Neutral ────────────────────────────────────────────────────────────────
  static Color background = ColorTokens.light.background;
  static Color surface = ColorTokens.light.surface;
  static const Color surfaceVariant = Color(0xFFEEF2F0);
  static const Color border = Color(0xFFD0D9D6);
  static const Color divider = Color(0xFFE0E8E5);

  // ── Text ───────────────────────────────────────────────────────────────────
  static Color textPrimary = ColorTokens.light.textPrimary;
  static Color textSecondary = ColorTokens.light.textSecondary;
  static const Color textDisabled = Color(0xFFA0B5B0);
  static Color textOnPrimary = ColorTokens.light.onPrimary;
  static Color textOnAccent = ColorTokens.light.onAccent;

  // ── Step indicator ─────────────────────────────────────────────────────────
  static Color stepCompleted = primary;
  static Color stepActive = accent;
  static const Color stepInactive = border;
}

// ---------------------------------------------------------------------------
// Spacing Tokens — const mirrors of the platform's SpacingTokens scale.
//
// Note: SpacingTokens exposes values as getters (not const fields), so we
// keep these as const to allow use in const constructors throughout the app.
// Values are identical to SpacingTokens — see packages/core_engine.
// ---------------------------------------------------------------------------
class AppSpacing {
  AppSpacing._();

  // Platform-aligned values (static const for use outside BuildContext)
  static const double xs = 4.0; // SpacingTokens.xs
  static const double sm = 8.0; // SpacingTokens.sm
  static const double md = 12.0; // SpacingTokens.md
  static const double base = 16.0; // SpacingTokens.lg  (base grid unit)
  static const double lg = 24.0; // SpacingTokens.xl
  static const double xl = 32.0; // SpacingTokens.xxl
  static const double xxl = 48.0; // SpacingTokens.xxxl
}

// ---------------------------------------------------------------------------
// Radius Tokens — const mirrors of the platform's RadiusTokens scale.
// Values are identical to RadiusTokens — see packages/core_engine.
// ---------------------------------------------------------------------------
class AppRadius {
  AppRadius._();

  static const double sm = 4.0; // RadiusTokens.sm
  static const double md = 8.0; // RadiusTokens.md
  static const double lg = 12.0; // RadiusTokens.lg
  static const double xl = 20.0; // RadiusTokens.xl
  static const double full = 999.0; // pill / circle
}

// ---------------------------------------------------------------------------
// Typography Tokens — delegates to the platform's TypographyTokens scale.
// ---------------------------------------------------------------------------
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.1,
  );

  static TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
  );
}

// ---------------------------------------------------------------------------
// Motion Tokens — const mirrors of the platform's MotionTokens values.
// Values are identical to MotionTokens — see packages/core_engine.
// ---------------------------------------------------------------------------
class AppMotion {
  AppMotion._();

  // Duration values mirror MotionTokens exactly
  static const Duration fast = Duration(milliseconds: 150); // MotionTokens.fast
  static const Duration normal =
      Duration(milliseconds: 300); // MotionTokens.normal
  static const Duration slow = Duration(milliseconds: 500); // MotionTokens.slow

  static const Curve standard = Curves.easeInOut; // MotionTokens.easeInOut
  static const Curve decelerate =
      Curves.easeOutCubic; // MotionTokens.easeOutCubic
}

// ---------------------------------------------------------------------------
// Theme Factory — builds a MaterialTheme consistent with the platform brand.
// ---------------------------------------------------------------------------
class AppTheme {
  AppTheme._();

  /// Builds a [ThemeData] from the platform's [ColorTokens.light] palette.
  static ThemeData get light {
    const colors = ColorTokens.light;
    const spacing = SpacingTokens();
    const radius = RadiusTokens();

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.accent,
        onSecondary: colors.onAccent,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        error: colors.error,
        onError: colors.onPrimary,
      ),
      scaffoldBackgroundColor: colors.background,
      fontFamily: AppTypography.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.onPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius.md),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        labelStyle: AppTypography.labelLarge,
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textDisabled,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
          textStyle: AppTypography.labelLarge.copyWith(fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: colors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius.md),
          ),
          textStyle: AppTypography.labelLarge.copyWith(fontSize: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius.lg),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: colors.primary,
        labelStyle: AppTypography.labelSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}
