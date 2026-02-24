import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/loan_application.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class EmploymentDetailsStep extends StatefulWidget {
  const EmploymentDetailsStep({super.key});

  @override
  State<EmploymentDetailsStep> createState() =>
      _EmploymentDetailsStepState();
}

class _EmploymentDetailsStepState
    extends State<EmploymentDetailsStep> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _employerCtrl;
  late TextEditingController _jobTitleCtrl;
  late TextEditingController _incomeCtrl;
  late TextEditingController _yearsCtrl;
  String? _selectedEmploymentType;

  // Show / hide employer fields based on employment type
  bool get _showEmployerFields {
    return _selectedEmploymentType != null &&
        _selectedEmploymentType != 'Unemployed' &&
        _selectedEmploymentType != 'Retired';
  }

  @override
  void initState() {
    super.initState();
    final app =
        context.read<LoanApplicationState>().application;
    _employerCtrl =
        TextEditingController(text: app.employerName);
    _jobTitleCtrl =
        TextEditingController(text: app.jobTitle);
    _incomeCtrl =
        TextEditingController(text: app.monthlyIncome);
    _yearsCtrl =
        TextEditingController(text: app.yearsEmployed);
    _selectedEmploymentType =
        app.employmentType.isEmpty ? null : app.employmentType;
  }

  @override
  void dispose() {
    _employerCtrl.dispose();
    _jobTitleCtrl.dispose();
    _incomeCtrl.dispose();
    _yearsCtrl.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<LoanApplicationState>();
      final app = state.application;
      app.employmentType = _selectedEmploymentType ?? '';
      app.employerName = _employerCtrl.text.trim();
      app.jobTitle = _jobTitleCtrl.text.trim();
      app.monthlyIncome = _incomeCtrl.text.trim();
      app.yearsEmployed = _yearsCtrl.text.trim();
      state.nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoanApplicationState>();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Employment Details',
            subtitle: 'Tell us about your current employment',
            icon: Icons.work_outline,
          ),

          // Employment Type
          AppFormField(
            label: 'Employment Type',
            isRequired: true,
            child: DropdownButtonFormField<String>(
              value: _selectedEmploymentType,
              hint: const Text('Select employment type'),
              items: employmentTypeOptions
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() => _selectedEmploymentType = v);
              },
              validator: (v) =>
                  v == null ? 'Employment type is required' : null,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.business_center_outlined,
                    color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Conditional employer fields
          AnimatedCrossFade(
            duration: AppMotion.normal,
            firstCurve: AppMotion.decelerate,
            secondCurve: AppMotion.decelerate,
            crossFadeState: _showEmployerFields
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppFormField(
                        label: _selectedEmploymentType == 'Business Owner' ||
                                _selectedEmploymentType == 'Self-Employed'
                            ? 'Business / Company Name'
                            : 'Employer Name',
                        isRequired: _showEmployerFields,
                        child: TextFormField(
                          controller: _employerCtrl,
                          decoration: InputDecoration(
                            hintText: _selectedEmploymentType ==
                                        'Business Owner' ||
                                    _selectedEmploymentType == 'Self-Employed'
                                ? 'e.g. Acme Corp'
                                : 'e.g. ABC Company',
                            prefixIcon: const Icon(
                                Icons.corporate_fare_outlined,
                                color: AppColors.primary),
                          ),
                          textCapitalization:
                              TextCapitalization.words,
                          validator: _showEmployerFields
                              ? (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Employer name is required'
                                      : null
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 2,
                      child: AppFormField(
                        label: 'Years Employed',
                        isRequired: false,
                        child: TextFormField(
                          controller: _yearsCtrl,
                          decoration: const InputDecoration(
                              hintText: 'e.g. 3'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),
                AppFormField(
                  label: 'Job Title / Role',
                  isRequired: _showEmployerFields,
                  child: TextFormField(
                    controller: _jobTitleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Software Engineer',
                      prefixIcon: Icon(Icons.badge_outlined,
                          color: AppColors.primary),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: _showEmployerFields
                        ? (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Job title is required'
                                : null
                        : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.base),
              ],
            ),
            secondChild: const SizedBox.shrink(),
          ),

          // Monthly Income
          AppFormField(
            label: 'Monthly Net Income (USD)',
            isRequired: true,
            child: TextFormField(
              controller: _incomeCtrl,
              decoration: const InputDecoration(
                hintText: '0.00',
                prefixIcon: Icon(Icons.attach_money,
                    color: AppColors.primary),
                prefixText: '\$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[\d.]')),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Monthly income is required';
                }
                final amount = double.tryParse(value.trim());
                if (amount == null || amount <= 0) {
                  return 'Enter a valid income amount';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Income Notice
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                  color: AppColors.info.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline,
                    color: AppColors.info, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Your income information is used to determine '
                    'your loan eligibility and maximum loan amount. '
                    'All information is kept strictly confidential.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          NavigationButtons(
            isFirstStep: false,
            isLastStep: false,
            onBack: state.previousStep,
            onNext: _saveAndContinue,
          ),
        ],
      ),
    );
  }
}
