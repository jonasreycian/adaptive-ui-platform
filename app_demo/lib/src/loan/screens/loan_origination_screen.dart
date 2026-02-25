import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

import '../theme/loan_theme.dart';
import '../viewmodels/loan_form_viewmodel.dart';
import 'step1_personal_info.dart';
import 'step2_employment.dart';
import 'step3_loan_details.dart';
import 'step4_review_submit.dart';
import 'success_screen.dart';

// ---------------------------------------------------------------------------
// Loan Origination Screen — entry point within the combined app.
//
// Wraps the multi-step loan application shell in a ViewModelBuilder so it
// can be pushed onto the existing Navigator without a new MaterialApp.
// ---------------------------------------------------------------------------
class LoanOriginationScreen extends StatelessWidget {
  const LoanOriginationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoanFormViewModel>.reactive(
      viewModelBuilder: LoanFormViewModel.new,
      builder: (context, viewModel, child) =>
          _LoanApplicationShell(viewModel: viewModel),
    );
  }
}

// ---------------------------------------------------------------------------
// Application Shell — Responsive Layout
// ---------------------------------------------------------------------------
class _LoanApplicationShell extends StatelessWidget {
  final LoanFormViewModel viewModel;

  const _LoanApplicationShell({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 768;

    if (viewModel.submitted) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: _buildAppBar(context, showProgress: false),
        body: SuccessScreen(viewModel: viewModel),
      );
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _buildAppBar(context, showProgress: true),
      body: isWide
          ? _WideLayout(viewModel: viewModel)
          : _NarrowLayout(viewModel: viewModel),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required bool showProgress,
  }) {
    final colors = TokenResolver.of(context).colors;
    return AppBar(
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Container(
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(
            Icons.account_balance,
            color: colors.onAccent,
            size: 20,
          ),
        ),
      ),
      title: const Text('Loan Origination System'),
      actions: [
        if (showProgress)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.md,
            ),
            child: AdaptiveInfoChip(
              label: 'Step ${viewModel.currentStep + 1} of '
                  '${LoanFormViewModel.totalSteps}',
              icon: Icons.linear_scale,
              color: colors.accent,
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Wide Layout (Tablet / Desktop) — Sidebar + Form
// ---------------------------------------------------------------------------
class _WideLayout extends StatelessWidget {
  final LoanFormViewModel viewModel;

  const _WideLayout({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 240,
          child: _Sidebar(viewModel: viewModel),
        ),
        Expanded(
          child: _FormArea(viewModel: viewModel),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Narrow Layout (Mobile) — Single Column
// ---------------------------------------------------------------------------
class _NarrowLayout extends StatelessWidget {
  final LoanFormViewModel viewModel;

  const _NarrowLayout({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = TokenResolver.of(context).colors;

    return Column(
      children: [
        Container(
          color: colors.surface,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.md,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: AdaptiveStepIndicator(
            currentStep: viewModel.currentStep,
            totalSteps: LoanFormViewModel.totalSteps,
            labels: const [
              'Personal',
              'Employment',
              'Loan',
              'Review',
            ],
          ),
        ),
        Expanded(child: _FormArea(viewModel: viewModel)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sidebar (Wide Only)
// ---------------------------------------------------------------------------
class _Sidebar extends StatelessWidget {
  final LoanFormViewModel viewModel;

  const _Sidebar({required this.viewModel});

  static const _steps = [
    _StepMeta(
      label: 'Personal Information',
      subtitle: 'Basic & contact details',
      icon: Icons.person_outline,
    ),
    _StepMeta(
      label: 'Employment Details',
      subtitle: 'Income & employer',
      icon: Icons.work_outline,
    ),
    _StepMeta(
      label: 'Loan Details',
      subtitle: 'Amount, purpose & tenure',
      icon: Icons.account_balance_outlined,
    ),
    _StepMeta(
      label: 'Review & Submit',
      subtitle: 'Confirm and submit',
      icon: Icons.fact_check_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.primary,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Brand header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: colors.onAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Loan Application',
                  style: typography.titleLarge.copyWith(
                    color: colors.onPrimary,
                  ),
                ),
                Text(
                  'Complete all steps to apply',
                  style: typography.labelSmall.copyWith(
                    color: colors.onPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0x33FFFFFF)),

          // Steps list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              itemCount: _steps.length,
              itemBuilder: (_, index) {
                final step = _steps[index];
                final isCompleted = index < viewModel.currentStep;
                final isActive = index == viewModel.currentStep;
                return _SidebarStepTile(
                  step: step,
                  index: index,
                  isCompleted: isCompleted,
                  isActive: isActive,
                );
              },
            ),
          ),

          // Progress footer
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: typography.labelSmall.copyWith(
                        color: colors.onPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                    Text(
                      '${((viewModel.progressFraction) * 100).round()}%',
                      style: typography.labelLarge.copyWith(
                        color: colors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: viewModel.progressFraction,
                    backgroundColor: colors.onPrimary.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepMeta {
  final String label;
  final String subtitle;
  final IconData icon;
  const _StepMeta(
      {required this.label, required this.subtitle, required this.icon});
}

class _SidebarStepTile extends StatelessWidget {
  final _StepMeta step;
  final int index;
  final bool isCompleted;
  final bool isActive;

  const _SidebarStepTile({
    required this.step,
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
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? colors.onPrimary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isActive
            ? Border.all(color: colors.accent.withValues(alpha: 0.5))
            : null,
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: AnimatedContainer(
          duration: AppMotion.normal,
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? colors.accent
                : isActive
                    ? colors.onPrimary.withValues(alpha: 0.2)
                    : Colors.transparent,
            border: Border.all(
              color: isCompleted
                  ? colors.accent
                  : isActive
                      ? colors.accent
                      : colors.onPrimary.withValues(alpha: 0.3),
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 14, color: colors.onAccent)
                : Text(
                    '${index + 1}',
                    style: typography.labelSmall.copyWith(
                      color: isActive
                          ? colors.onPrimary
                          : colors.onPrimary.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        title: Text(
          step.label,
          style: typography.labelLarge.copyWith(
            color: isActive
                ? colors.onPrimary
                : isCompleted
                    ? colors.onPrimary.withValues(alpha: 0.8)
                    : colors.onPrimary.withValues(alpha: 0.5),
          ),
        ),
        subtitle: Text(
          step.subtitle,
          style: typography.labelSmall.copyWith(
            color: colors.onPrimary.withValues(alpha: 0.4),
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form Area (Scrollable Content)
// ---------------------------------------------------------------------------
class _FormArea extends StatelessWidget {
  final LoanFormViewModel viewModel;

  const _FormArea({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? AppSpacing.xl : AppSpacing.base,
        vertical: AppSpacing.lg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: AnimatedSwitcher(
            duration: AppMotion.normal,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: AppMotion.decelerate,
                  )),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey(viewModel.currentStep),
              child: _buildStep(viewModel.currentStep),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return PersonalInfoStep(viewModel: viewModel);
      case 1:
        return EmploymentDetailsStep(viewModel: viewModel);
      case 2:
        return LoanDetailsStep(viewModel: viewModel);
      case 3:
        return ReviewSubmitStep(viewModel: viewModel);
      default:
        return PersonalInfoStep(viewModel: viewModel);
    }
  }
}
