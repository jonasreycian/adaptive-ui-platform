import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

/// A token-driven horizontal step progress indicator for multi-step flows.
///
/// Renders a row of numbered circles connected by lines, with optional labels
/// below each step. The active step uses the accent colour; completed steps use
/// the primary colour with a check-mark; inactive steps use a subdued style.
///
/// All colours, spacing, radius, and motion values are drawn from the nearest
/// [TokenResolver] in the widget tree.
///
/// ```dart
/// AdaptiveStepIndicator(
///   currentStep: 1,        // zero-indexed
///   totalSteps: 4,
///   labels: const ['Personal', 'Employment', 'Loan', 'Review'],
/// )
/// ```
class AdaptiveStepIndicator extends StatelessWidget {
  const AdaptiveStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  /// Zero-indexed index of the current (active) step.
  final int currentStep;

  /// Total number of steps in the flow.
  final int totalSteps;

  /// Label text shown below each step circle.
  ///
  /// Must have exactly [totalSteps] entries.
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep;
            return Expanded(
              child: Row(
                children: [
                  _StepCircle(
                    index: index + 1,
                    isCompleted: isCompleted,
                    isActive: isActive,
                  ),
                  if (index < totalSteps - 1)
                    Expanded(
                      child: AnimatedContainer(
                        duration: tokens.motion.normal,
                        curve: tokens.motion.easeOutCubic,
                        height: 2,
                        color: isCompleted
                            ? colors.primary
                            : colors.textSecondary.withOpacity(0.25),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: spacing.sm),
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep;
            return Expanded(
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: typography.labelSmall.copyWith(
                  color: isActive
                      ? colors.primary
                      : isCompleted
                          ? colors.primary.withOpacity(0.7)
                          : colors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.index,
    required this.isCompleted,
    required this.isActive,
  });

  final int index;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return AnimatedContainer(
      duration: tokens.motion.normal,
      curve: tokens.motion.easeOutCubic,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? colors.primary
            : isActive
                ? colors.accent
                : colors.surface,
        border: Border.all(
          color: isCompleted
              ? colors.primary
              : isActive
                  ? colors.accent
                  : colors.textSecondary.withOpacity(0.35),
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: colors.accent.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, size: 16, color: colors.onPrimary)
            : Text(
                '$index',
                style: typography.labelLarge.copyWith(
                  color: isActive ? colors.onAccent : colors.textSecondary,
                  fontSize: 13,
                ),
              ),
      ),
    );
  }
}
