import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';
import 'package:adaptive_components/adaptive_components.dart';
import '../theme/loan_theme.dart';

// ---------------------------------------------------------------------------
// Step Progress Indicator
// ---------------------------------------------------------------------------
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
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
                        duration: AppMotion.normal,
                        curve: AppMotion.decelerate,
                        height: 2,
                        color: isCompleted
                            ? colors.primary
                            : LoanColors.border,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
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
                          ? LoanColors.primaryLight
                          : LoanColors.textDisabled,
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
  final int index;
  final bool isCompleted;
  final bool isActive;

  const _StepCircle({
    required this.index,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.decelerate,
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
                  : LoanColors.border,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: colors.accent.withValues(alpha: 50),
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
                  color: isActive
                      ? colors.onAccent
                      : LoanColors.textDisabled,
                  fontSize: 13,
                ),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section Header
// ---------------------------------------------------------------------------
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: colors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: typography.titleLarge
                        .copyWith(color: colors.textPrimary),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: typography.bodyMedium
                          .copyWith(color: colors.textSecondary),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.base),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Labeled Input Field Wrapper
// ---------------------------------------------------------------------------
class AppFormField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;

  const AppFormField({
    super.key,
    required this.label,
    this.isRequired = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: typography.labelLarge
                .copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: colors.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        child,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Review Row (key-value display)
// ---------------------------------------------------------------------------
class ReviewRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const ReviewRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: typography.bodyMedium
                  .copyWith(color: colors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: highlight
                  ? typography.titleMedium.copyWith(
                      color: colors.primary,
                    )
                  : typography.bodyLarge
                      .copyWith(color: colors.textPrimary),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation Buttons Row — uses AdaptiveButton from adaptive_components
// ---------------------------------------------------------------------------
class NavigationButtons extends StatelessWidget {
  final bool isFirstStep;
  final bool isLastStep;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String nextLabel;

  const NavigationButtons({
    super.key,
    required this.isFirstStep,
    required this.isLastStep,
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Continue',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isFirstStep) ...[
          Expanded(
            child: AdaptiveButton(
              label: 'Back',
              variant: AdaptiveButtonVariant.outlined,
              icon: const Icon(Icons.arrow_back, size: 18),
              onPressed: onBack,
              isFullWidth: true,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          flex: 2,
          child: AdaptiveButton(
            label: nextLabel,
            variant: AdaptiveButtonVariant.primary,
            icon: Icon(
              isLastStep ? Icons.send_rounded : Icons.arrow_forward,
              size: 18,
            ),
            onPressed: onNext,
            isFullWidth: true,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Info Chip
// ---------------------------------------------------------------------------
class InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? color;

  const InfoChip({
    super.key,
    required this.label,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = TokenResolver.of(context).colors;
    final typography = TokenResolver.of(context).typography;
    final chipColor = color ?? colors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: AppSpacing.xs),
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
