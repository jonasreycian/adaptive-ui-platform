import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_engine/core_engine.dart';

import '../models/loan_application.dart';
import '../theme/loan_theme.dart';
import '../viewmodels/loan_form_viewmodel.dart';
import '../widgets/common_widgets.dart';

class LoanDetailsStep extends StatefulWidget {
  final LoanFormViewModel viewModel;

  const LoanDetailsStep({super.key, required this.viewModel});

  @override
  State<LoanDetailsStep> createState() => _LoanDetailsStepState();
}

class _LoanDetailsStepState extends State<LoanDetailsStep> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountCtrl;
  String? _selectedPurpose;
  String? _selectedTenure;
  String? _selectedCollateral;

  double get _estimatedMonthlyPayment {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) return 0;
    if (_selectedTenure == null) return 0;
    final months =
        int.tryParse(_selectedTenure!.replaceAll(' months', '')) ?? 0;
    if (months <= 0) return 0;
    const annualRate = 0.08;
    final monthlyRate = annualRate / 12;
    final pmt = amount *
        (monthlyRate * math.pow(1 + monthlyRate, months)) /
        (math.pow(1 + monthlyRate, months) - 1);
    return pmt;
  }

  String get _formattedEstimate {
    final p = _estimatedMonthlyPayment;
    if (p <= 0) return '—';
    return '\$${p.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  @override
  void initState() {
    super.initState();
    final app = widget.viewModel.application;
    _amountCtrl = TextEditingController(text: app.loanAmount);
    _selectedPurpose = app.loanPurpose.isEmpty ? null : app.loanPurpose;
    _selectedTenure = app.loanTenure.isEmpty ? null : app.loanTenure;
    _selectedCollateral =
        app.collateralType.isEmpty ? null : app.collateralType;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      final app = widget.viewModel.application;
      app.loanPurpose = _selectedPurpose ?? '';
      app.loanAmount = _amountCtrl.text.trim();
      app.loanTenure = _selectedTenure ?? '';
      app.collateralType = _selectedCollateral ?? '';
      widget.viewModel.nextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final typography = tokens.typography;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Loan Details',
            subtitle: 'Specify your loan requirements',
            icon: Icons.account_balance_outlined,
          ),

          // Loan Purpose
          AppFormField(
            label: 'Loan Purpose',
            isRequired: true,
            child: DropdownButtonFormField<String>(
              value: _selectedPurpose,
              hint: const Text('Why do you need this loan?'),
              isExpanded: true,
              items: loanPurposeOptions
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedPurpose = v),
              validator: (v) =>
                  v == null ? 'Loan purpose is required' : null,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.lightbulb_outline, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Loan Amount
          AppFormField(
            label: 'Requested Loan Amount (USD)',
            isRequired: true,
            child: TextFormField(
              controller: _amountCtrl,
              decoration: InputDecoration(
                hintText: '10,000.00',
                prefixIcon:
                    Icon(Icons.attach_money, color: colors.primary),
                prefixText: '\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              onChanged: (_) => setState(() {}),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Loan amount is required';
                }
                final amount = double.tryParse(value.trim());
                if (amount == null || amount <= 0) {
                  return 'Enter a valid loan amount';
                }
                if (amount < 1000) {
                  return 'Minimum loan amount is \$1,000';
                }
                if (amount > 10000000) {
                  return 'Maximum loan amount is \$10,000,000';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Tenure
          AppFormField(
            label: 'Loan Tenure',
            isRequired: true,
            child: DropdownButtonFormField<String>(
              value: _selectedTenure,
              hint: const Text('Select repayment period'),
              isExpanded: true,
              items: tenureOptions
                  .map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t),
                      ))
                  .toList(),
              onChanged: (v) {
                setState(() => _selectedTenure = v);
              },
              validator: (v) =>
                  v == null ? 'Loan tenure is required' : null,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.schedule_outlined, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          // Collateral
          AppFormField(
            label: 'Collateral Type',
            isRequired: true,
            child: DropdownButtonFormField<String>(
              value: _selectedCollateral,
              hint: const Text('Select collateral (if any)'),
              isExpanded: true,
              items: collateralOptions
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCollateral = v),
              validator: (v) =>
                  v == null ? 'Collateral type is required' : null,
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.security_outlined, color: colors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Estimated Payment Card
          AnimatedSize(
            duration: AppMotion.normal,
            curve: AppMotion.decelerate,
            child: _amountCtrl.text.isNotEmpty && _selectedTenure != null
                ? Container(
                    padding: const EdgeInsets.all(AppSpacing.base),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.primary,
                          LoanColors.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          color: colors.accent,
                          size: 40,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Monthly Payment',
                                style: typography.labelSmall.copyWith(
                                  color:
                                      colors.onPrimary.withOpacity(0.4),
                                ),
                              ),
                              Text(
                                _formattedEstimate,
                                style: typography.headlineMedium.copyWith(
                                  color: colors.accent,
                                ),
                              ),
                              Text(
                                'Based on ~8% annual interest rate',
                                style: typography.labelSmall.copyWith(
                                  color: colors.onPrimary
                                      .withOpacity(0.5),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.xl),

          NavigationButtons(
            isFirstStep: false,
            isLastStep: false,
            onBack: widget.viewModel.previousStep,
            onNext: _saveAndContinue,
          ),
        ],
      ),
    );
  }
}
