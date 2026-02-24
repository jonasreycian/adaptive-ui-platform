import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';
import 'package:adaptive_components/adaptive_components.dart';
import '../theme/loan_theme.dart';

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
            style: typography.labelLarge.copyWith(
                color: colors.textPrimary, fontWeight: FontWeight.w600),
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
                  : typography.bodyLarge.copyWith(color: colors.textPrimary),
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

