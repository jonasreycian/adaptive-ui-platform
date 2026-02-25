import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

import '../models/loan_application.dart';

// ---------------------------------------------------------------------------
// LoanFormViewModel — central ViewModel for the entire multi-step form.
//
// Extends BaseViewModel (from stacked), which provides:
//   - notifyListeners() for reactive UI rebuilds via ViewModelBuilder
//   - setBusy() / isBusy for loading states
//   - setError() / hasError for error handling
// ---------------------------------------------------------------------------
class LoanFormViewModel extends BaseViewModel {
  final LoanApplicationModel application = LoanApplicationModel();

  int _currentStep = 0;
  bool _submitted = false;
  String _referenceNumber = '';

  // ──────────────────────────────────────────────────────────────────
  // Accessors
  // ──────────────────────────────────────────────────────────────────

  int get currentStep => _currentStep;
  bool get submitted => _submitted;
  String get referenceNumber => _referenceNumber;

  static const int totalSteps = 4;

  // ──────────────────────────────────────────────────────────────────
  // Navigation
  // ──────────────────────────────────────────────────────────────────

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // ──────────────────────────────────────────────────────────────────
  // Submit
  // ──────────────────────────────────────────────────────────────────

  void submit() {
    _submitted = true;
    _referenceNumber = 'LOS-${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────
  // Reset
  // ──────────────────────────────────────────────────────────────────

  void reset() {
    _currentStep = 0;
    _submitted = false;
    _referenceNumber = '';
    final a = application;
    a.firstName = a.lastName = a.dateOfBirth = a.gender = a.nationalId = '';
    a.email = a.phone = a.address = a.city = a.state = a.postalCode = '';
    a.employmentType = a.employerName = a.jobTitle = '';
    a.monthlyIncome = a.yearsEmployed = '';
    a.loanPurpose = a.loanAmount = a.loanTenure = a.collateralType = '';
    notifyListeners();
  }

  // ──────────────────────────────────────────────────────────────────
  // Derived helpers
  // ──────────────────────────────────────────────────────────────────

  double get progressFraction => (_currentStep + 1) / totalSteps;

  String get stepLabel {
    switch (_currentStep) {
      case 0:
        return 'Personal Information';
      case 1:
        return 'Employment Details';
      case 2:
        return 'Loan Details';
      case 3:
        return 'Review & Submit';
      default:
        return '';
    }
  }

  String get formattedLoanAmount {
    if (application.loanAmount.isEmpty) return '—';
    final amount = double.tryParse(application.loanAmount);
    if (amount == null) return application.loanAmount;
    return '\$${amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        )}';
  }

  // ──────────────────────────────────────────────────────────────────
  // Confirmation dialog helper (used by Step 4)
  // ──────────────────────────────────────────────────────────────────

  Future<void> confirmAndSubmit(BuildContext context) async {
    final confirmed = await AdaptiveDialog.show<bool>(
      context: context,
      title: 'Submit Application?',
      content: const Text(
        'Once submitted, your loan application will be reviewed '
        'by our team. You will receive a confirmation email within '
        '1-2 business days.\n\nDo you wish to proceed?',
      ),
      actions: [
        AdaptiveButton(
          label: 'Cancel',
          variant: AdaptiveButtonVariant.outlined,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        AdaptiveButton(
          label: 'Submit',
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );
    if (confirmed == true) submit();
  }
}
