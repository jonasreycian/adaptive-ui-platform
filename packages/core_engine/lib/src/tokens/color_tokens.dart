import 'package:flutter/material.dart';

/// Immutable set of semantic color tokens.
///
/// Light-mode defaults:
///   primary    = #04382f
///   accent     = #eabc3d
///   background = #f4f6f5
///   surface    = #ffffff
///   textPrimary = #04382f
///
/// Dark-mode defaults:
///   primary    = #eabc3d
///   background = #021d18
///   surface    = #04382f
///   textPrimary = #ffffff
@immutable
class ColorTokens {
  const ColorTokens({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
    required this.onPrimary,
    required this.onAccent,
  });

  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;
  final Color onPrimary;
  final Color onAccent;

  // ── Built-in light palette ──────────────────────────────────────────────────
  static const ColorTokens light = ColorTokens(
    primary: Color(0xFF04382F),
    accent: Color(0xFFEABC3D),
    background: Color(0xFFF4F6F5),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF04382F),
    textSecondary: Color(0xFF5A7A74),
    error: Color(0xFFB00020),
    onPrimary: Color(0xFFFFFFFF),
    onAccent: Color(0xFF04382F),
  );

  // ── Built-in dark palette ───────────────────────────────────────────────────
  static const ColorTokens dark = ColorTokens(
    primary: Color(0xFFEABC3D),
    accent: Color(0xFF04382F),
    background: Color(0xFF021D18),
    surface: Color(0xFF04382F),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFB0C4C0),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF04382F),
    onAccent: Color(0xFFEABC3D),
  );

  /// Returns a copy of this token set with specific values replaced.
  ColorTokens copyWith({
    Color? primary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? error,
    Color? onPrimary,
    Color? onAccent,
  }) {
    return ColorTokens(
      primary: primary ?? this.primary,
      accent: accent ?? this.accent,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onAccent: onAccent ?? this.onAccent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorTokens &&
          runtimeType == other.runtimeType &&
          primary == other.primary &&
          accent == other.accent &&
          background == other.background &&
          surface == other.surface &&
          textPrimary == other.textPrimary &&
          textSecondary == other.textSecondary &&
          error == other.error &&
          onPrimary == other.onPrimary &&
          onAccent == other.onAccent;

  @override
  int get hashCode => Object.hash(
        primary,
        accent,
        background,
        surface,
        textPrimary,
        textSecondary,
        error,
        onPrimary,
        onAccent,
      );
}
