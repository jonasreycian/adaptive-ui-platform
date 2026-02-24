import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/loan_application.dart';
import 'screens/step1_personal_info.dart';
import 'screens/step2_employment.dart';
import 'screens/step3_loan_details.dart';
import 'screens/step4_review_submit.dart';
import 'screens/success_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/common_widgets.dart';

// ---------------------------------------------------------------------------
// Application Entry
// ---------------------------------------------------------------------------
class LoanOriginationApp extends StatelessWidget {
  const LoanOriginationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoanApplicationState(),
      child: MaterialApp(
        title: 'Loan Origination System',
        theme: AppTheme.light,
        debugShowCheckedModeBanner: false,
        home: const _LoanApplicationShell(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Application Shell — Responsive Layout
// ---------------------------------------------------------------------------
class _LoanApplicationShell extends StatelessWidget {
  const _LoanApplicationShell();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoanApplicationState>();
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 768;

    if (state.submitted) {
      return Scaffold(
        appBar: _buildAppBar(context, showProgress: false),
        body: const SuccessScreen(),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, showProgress: true),
      body: isWide
          ? _WideLayout(state: state)
          : _NarrowLayout(state: state),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required bool showProgress,
  }) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Icon(
            Icons.account_balance,
            color: AppColors.textOnAccent,
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
            child: Consumer<LoanApplicationState>(
              builder: (_, state, __) => InfoChip(
                label: 'Step ${state.currentStep + 1} of '
                    '${LoanApplicationState.totalSteps}',
                icon: Icons.linear_scale,
                color: AppColors.accent,
              ),
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
  final LoanApplicationState state;

  const _WideLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        SizedBox(
          width: 240,
          child: _Sidebar(state: state),
        ),
        // Form Area
        Expanded(
          child: _FormArea(state: state),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Narrow Layout (Mobile) — Single Column
// ---------------------------------------------------------------------------
class _NarrowLayout extends StatelessWidget {
  final LoanApplicationState state;

  const _NarrowLayout({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress Bar
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.base,
            AppSpacing.md,
            AppSpacing.base,
            AppSpacing.base,
          ),
          child: StepProgressIndicator(
            currentStep: state.currentStep,
            totalSteps: LoanApplicationState.totalSteps,
            labels: const [
              'Personal',
              'Employment',
              'Loan',
              'Review',
            ],
          ),
        ),
        Expanded(child: _FormArea(state: state)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sidebar (Wide Only)
// ---------------------------------------------------------------------------
class _Sidebar extends StatelessWidget {
  final LoanApplicationState state;

  const _Sidebar({required this.state});

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
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
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
                    color: AppColors.accent,
                    borderRadius:
                        BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: AppColors.textOnAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Loan Application',
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
                Text(
                  'Complete all steps to apply',
                  style: AppTypography.labelSmall.copyWith(
                    color:
                        AppColors.textOnPrimary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          const Divider(
              height: 1,
              color: Color(0x33FFFFFF)),

          // Steps list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md),
              itemCount: _steps.length,
              itemBuilder: (_, index) {
                final step = _steps[index];
                final isCompleted = index < state.currentStep;
                final isActive = index == state.currentStep;
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
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textOnPrimary
                            .withOpacity(0.6),
                      ),
                    ),
                    Text(
                      '${((state.progressFraction) * 100).round()}%',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppRadius.full),
                  child: LinearProgressIndicator(
                    value: state.progressFraction,
                    backgroundColor:
                        AppColors.textOnPrimary.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent),
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
      {required this.label,
      required this.subtitle,
      required this.icon});
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
    return AnimatedContainer(
      duration: AppMotion.normal,
      curve: AppMotion.decelerate,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.textOnPrimary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isActive
            ? Border.all(
                color: AppColors.accent.withOpacity(0.5))
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
                ? AppColors.accent
                : isActive
                    ? AppColors.textOnPrimary.withOpacity(0.2)
                    : Colors.transparent,
            border: Border.all(
              color: isCompleted
                  ? AppColors.accent
                  : isActive
                      ? AppColors.accent
                      : AppColors.textOnPrimary
                          .withOpacity(0.3),
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check,
                    size: 14,
                    color: AppColors.textOnAccent)
                : Text(
                    '${index + 1}',
                    style: AppTypography.labelSmall.copyWith(
                      color: isActive
                          ? AppColors.textOnPrimary
                          : AppColors.textOnPrimary
                              .withOpacity(0.5),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        title: Text(
          step.label,
          style: AppTypography.labelLarge.copyWith(
            color: isActive
                ? AppColors.textOnPrimary
                : isCompleted
                    ? AppColors.textOnPrimary.withOpacity(0.8)
                    : AppColors.textOnPrimary.withOpacity(0.5),
          ),
        ),
        subtitle: Text(
          step.subtitle,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textOnPrimary.withOpacity(0.4),
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
  final LoanApplicationState state;

  const _FormArea({required this.state});

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
              key: ValueKey(state.currentStep),
              child: _buildStep(state.currentStep),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return const PersonalInfoStep();
      case 1:
        return const EmploymentDetailsStep();
      case 2:
        return const LoanDetailsStep();
      case 3:
        return const ReviewSubmitStep();
      default:
        return const PersonalInfoStep();
    }
  }
}
