import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

/// A compact token-driven chip that pairs an icon with a short label.
///
/// Useful for displaying status summaries, metadata tags, or quick-reference
/// values. The optional [color] parameter lets callers supply a semantic
/// colour (e.g. success green, warning amber); when omitted the chip adopts
/// the active brand's primary colour from the nearest [TokenResolver].
///
/// All typography, spacing, and radius values are sourced from [TokenResolver].
///
/// ```dart
/// AdaptiveInfoChip(
///   label: '\$25,000',
///   icon: Icons.attach_money,
/// )
///
/// AdaptiveInfoChip(
///   label: 'Approved',
///   icon: Icons.check_circle_outline,
///   color: Colors.green,
/// )
/// ```
class AdaptiveInfoChip extends StatelessWidget {
  const AdaptiveInfoChip({
    super.key,
    required this.label,
    required this.icon,
    this.color,
  });

  /// The text displayed inside the chip.
  final String label;

  /// The icon displayed to the left of [label].
  final IconData icon;

  /// Optional semantic colour override.
  ///
  /// Defaults to the active brand's primary colour when `null`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;
    final chipColor = color ?? colors.primary;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          SizedBox(width: spacing.xs),
          Text(
            label,
            style: typography.labelSmall.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
