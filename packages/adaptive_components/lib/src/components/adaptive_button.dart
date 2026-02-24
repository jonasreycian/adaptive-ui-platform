import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

/// Variants that control the visual style of [AdaptiveButton].
enum AdaptiveButtonVariant { primary, secondary, outlined, ghost }

/// A token-driven button that adapts its appearance to the active theme.
class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AdaptiveButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AdaptiveButtonVariant variant;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final radius = tokens.radius;
    final motion = tokens.motion;

    final borderRadius = BorderRadius.circular(radius.md);
    final padding = EdgeInsets.symmetric(
      horizontal: spacing.lg,
      vertical: spacing.md,
    );

    Widget child = isLoading
        ? SizedBox(
            width: spacing.lg,
            height: spacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _foregroundColor(colors),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: spacing.sm),
              ],
              Text(label, style: tokens.typography.labelLarge),
            ],
          );

    if (isFullWidth) {
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      );
    }

    return AnimatedContainer(
      duration: motion.fast,
      curve: motion.easeOutCubic,
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(
        child: child,
        padding: padding,
        borderRadius: borderRadius,
        colors: colors,
      ),
    );
  }

  Color _foregroundColor(ColorTokens colors) {
    switch (variant) {
      case AdaptiveButtonVariant.primary:
        return colors.onPrimary;
      case AdaptiveButtonVariant.secondary:
        return colors.onAccent;
      case AdaptiveButtonVariant.outlined:
      case AdaptiveButtonVariant.ghost:
        return colors.primary;
    }
  }

  Widget _buildButton({
    required Widget child,
    required EdgeInsets padding,
    required BorderRadius borderRadius,
    required ColorTokens colors,
  }) {
    switch (variant) {
      case AdaptiveButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );

      case AdaptiveButtonVariant.secondary:
        return ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.accent,
            foregroundColor: colors.onAccent,
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );

      case AdaptiveButtonVariant.outlined:
        return OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.primary,
            padding: padding,
            side: BorderSide(color: colors.primary),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );

      case AdaptiveButtonVariant.ghost:
        return TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.primary,
            padding: padding,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: child,
        );
    }
  }
}
