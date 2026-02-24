import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../viewmodels/loan_form_viewmodel.dart';
import '../widgets/common_widgets.dart';
import 'loan_applications_screen.dart';

class SuccessScreen extends StatelessWidget {
  final LoanFormViewModel viewModel;

  const SuccessScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final app = viewModel.application;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: AppMotion.slow,
              curve: AppMotion.decelerate,
              builder: (ctx, value, child) => Transform.scale(
                scale: value,
                child: child,
              ),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withOpacity(0.1),
                  border: Border.all(
                    color: AppColors.success,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 56,
                  color: AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            Text(
              'Application Submitted!',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.success,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Thank you, ${app.firstName}! Your loan application '
              'has been received and is under review.',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Reference Number Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Application Reference',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textOnPrimary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    viewModel.referenceNumber,
                    style: AppTypography.displayLarge.copyWith(
                      color: AppColors.accent,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Save this reference number for your records',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textOnPrimary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Summary chips
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                InfoChip(
                  label: viewModel.formattedLoanAmount,
                  icon: Icons.attach_money,
                  color: AppColors.primary,
                ),
                InfoChip(
                  label: app.loanPurpose,
                  icon: Icons.lightbulb_outline,
                  color: AppColors.primaryLight,
                ),
                InfoChip(
                  label: app.loanTenure,
                  icon: Icons.schedule,
                  color: AppColors.primaryLight,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // What's Next
            Container(
              padding: const EdgeInsets.all(AppSpacing.base),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("What's Next?",
                      style: AppTypography.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  _NextStep(
                    step: '01',
                    title: 'Application Review',
                    description:
                        'Our team will review your application within '
                        '1–2 business days.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NextStep(
                    step: '02',
                    title: 'Document Verification',
                    description:
                        'You may be contacted to provide additional '
                        'supporting documents.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NextStep(
                    step: '03',
                    title: 'Credit Assessment',
                    description:
                        'A credit check will be conducted based on '
                        'your consent.',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _NextStep(
                    step: '04',
                    title: 'Decision & Disbursement',
                    description:
                        'You will receive the decision via email. '
                        'Approved loans are disbursed within 3–5 '
                        'business days.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LoanApplicationsScreen(),
                  ),
                ),
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('View All Applications'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => viewModel.reset(),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Start New Application'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textOnAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Next Step Item
// ---------------------------------------------------------------------------
class _NextStep extends StatelessWidget {
  final String step;
  final String title;
  final String description;

  const _NextStep({
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              step,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.accentDark,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.labelLarge),
              Text(description,
                  style: AppTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
