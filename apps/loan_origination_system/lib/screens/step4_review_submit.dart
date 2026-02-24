import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/loan_application.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ReviewSubmitStep extends StatefulWidget {
  const ReviewSubmitStep({super.key});

  @override
  State<ReviewSubmitStep> createState() => _ReviewSubmitStepState();
}

class _ReviewSubmitStepState extends State<ReviewSubmitStep> {
  bool _agreedToTerms = false;
  bool _confirmedAccuracy = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoanApplicationState>();
    final app = state.application;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Review & Submit',
          subtitle:
              'Please review your application before submitting',
          icon: Icons.fact_check_outlined,
        ),

        // ──── Personal Information ────────────────────────────
        _ReviewSection(
          title: 'Personal Information',
          icon: Icons.person_outline,
          stepIndex: 0,
          onEdit: () => state.goToStep(0),
          rows: [
            ReviewRow(
                label: 'Full Name',
                value: '${app.firstName} ${app.lastName}'),
            ReviewRow(
                label: 'Date of Birth',
                value: app.dateOfBirth),
            ReviewRow(label: 'Gender', value: app.gender),
            ReviewRow(
                label: 'National ID', value: app.nationalId),
            ReviewRow(label: 'Email', value: app.email),
            ReviewRow(label: 'Phone', value: app.phone),
            ReviewRow(
                label: 'Address',
                value: '${app.address}, ${app.city}, '
                    '${app.state} ${app.postalCode}'),
          ],
        ),
        const SizedBox(height: AppSpacing.base),

        // ──── Employment Details ──────────────────────────────
        _ReviewSection(
          title: 'Employment Details',
          icon: Icons.work_outline,
          stepIndex: 1,
          onEdit: () => state.goToStep(1),
          rows: [
            ReviewRow(
                label: 'Employment Type',
                value: app.employmentType),
            if (app.employerName.isNotEmpty)
              ReviewRow(
                  label: 'Employer', value: app.employerName),
            if (app.jobTitle.isNotEmpty)
              ReviewRow(
                  label: 'Job Title', value: app.jobTitle),
            if (app.yearsEmployed.isNotEmpty)
              ReviewRow(
                  label: 'Years Employed',
                  value: '${app.yearsEmployed} years'),
            ReviewRow(
                label: 'Monthly Income',
                value: '\$${app.monthlyIncome}'),
          ],
        ),
        const SizedBox(height: AppSpacing.base),

        // ──── Loan Details ────────────────────────────────────
        _ReviewSection(
          title: 'Loan Details',
          icon: Icons.account_balance_outlined,
          stepIndex: 2,
          onEdit: () => state.goToStep(2),
          rows: [
            ReviewRow(
                label: 'Purpose', value: app.loanPurpose),
            ReviewRow(
              label: 'Loan Amount',
              value: state.formattedLoanAmount,
              highlight: true,
            ),
            ReviewRow(label: 'Tenure', value: app.loanTenure),
            ReviewRow(
                label: 'Collateral',
                value: app.collateralType),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // ──── Declarations ────────────────────────────────────
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
              Text('Declarations',
                  style: AppTypography.titleMedium),
              const SizedBox(height: AppSpacing.md),
              _DeclarationCheckbox(
                value: _confirmedAccuracy,
                onChanged: (v) =>
                    setState(() => _confirmedAccuracy = v!),
                label:
                    'I confirm that all the information provided '
                    'in this application is true, accurate, and '
                    'complete to the best of my knowledge.',
              ),
              const SizedBox(height: AppSpacing.sm),
              _DeclarationCheckbox(
                value: _agreedToTerms,
                onChanged: (v) =>
                    setState(() => _agreedToTerms = v!),
                label:
                    'I have read and agree to the Terms & Conditions, '
                    'Privacy Policy, and consent to credit checks '
                    'as part of this loan application process.',
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        NavigationButtons(
          isFirstStep: false,
          isLastStep: true,
          onBack: state.previousStep,
          nextLabel: 'Submit Application',
          onNext: () {
            if (!_confirmedAccuracy || !_agreedToTerms) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Please accept all declarations before submitting.',
                  ),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.md),
                  ),
                ),
              );
              return;
            }
            _showConfirmDialog(context, state);
          },
        ),
      ],
    );
  }

  Future<void> _showConfirmDialog(
    BuildContext context,
    LoanApplicationState state,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: const Text('Submit Application?'),
        content: const Text(
          'Once submitted, your loan application will be reviewed '
          'by our team. You will receive a confirmation email within '
          '1-2 business days.\n\nDo you wish to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      state.submit();
    }
  }
}

// ---------------------------------------------------------------------------
// Review Section Card
// ---------------------------------------------------------------------------
class _ReviewSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final int stepIndex;
  final VoidCallback onEdit;
  final List<ReviewRow> rows;

  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.stepIndex,
    required this.onEdit,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.base),
            ...rows.map((r) => Column(
                  children: [
                    r,
                    if (rows.last != r)
                      const Divider(
                          height: 1, color: AppColors.divider),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Declaration Checkbox
// ---------------------------------------------------------------------------
class _DeclarationCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const _DeclarationCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(label, style: AppTypography.bodyMedium),
          ),
        ),
      ],
    );
  }
}
