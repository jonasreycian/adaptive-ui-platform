import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
                            ? AppColors.primary
                            : AppColors.stepInactive,
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
                style: AppTypography.labelSmall.copyWith(
                  color: isActive
                      ? AppColors.primary
                      : isCompleted
                          ? AppColors.primaryLight
                          : AppColors.textDisabled,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w400,
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
    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.decelerate,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted
            ? AppColors.primary
            : isActive
                ? AppColors.accent
                : AppColors.surface,
        border: Border.all(
          color: isCompleted
              ? AppColors.primary
              : isActive
                  ? AppColors.accent
                  : AppColors.border,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, size: 16, color: AppColors.textOnPrimary)
            : Text(
                '$index',
                style: AppTypography.labelLarge.copyWith(
                  color: isActive
                      ? AppColors.textOnAccent
                      : AppColors.textDisabled,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleLarge),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppTypography.bodyMedium),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppTypography.labelLarge,
            children: isRequired
                ? [
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.error),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: AppTypography.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: highlight
                  ? AppTypography.titleMedium.copyWith(
                      color: AppColors.primary,
                    )
                  : AppTypography.bodyLarge,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Navigation Buttons Row
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
            child: OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back'),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: onNext,
            icon: Icon(
              isLastStep ? Icons.send_rounded : Icons.arrow_forward,
              size: 18,
            ),
            label: Text(nextLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isLastStep ? AppColors.success : AppColors.primary,
            ),
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
    final chipColor = color ?? AppColors.primary;
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
            style: AppTypography.labelSmall.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
