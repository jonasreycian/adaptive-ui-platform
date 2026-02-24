import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Loan Application Data Model
// ---------------------------------------------------------------------------
class LoanApplicationModel {
  // Step 1 – Personal Information
  String firstName;
  String lastName;
  String dateOfBirth;
  String gender;
  String nationalId;
  String email;
  String phone;
  String address;
  String city;
  String state;
  String postalCode;

  // Step 2 – Employment Details
  String employmentType;
  String employerName;
  String jobTitle;
  String monthlyIncome;
  String yearsEmployed;

  // Step 3 – Loan Details
  String loanPurpose;
  String loanAmount;
  String loanTenure;
  String collateralType;

  LoanApplicationModel({
    this.firstName = '',
    this.lastName = '',
    this.dateOfBirth = '',
    this.gender = '',
    this.nationalId = '',
    this.email = '',
    this.phone = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.employmentType = '',
    this.employerName = '',
    this.jobTitle = '',
    this.monthlyIncome = '',
    this.yearsEmployed = '',
    this.loanPurpose = '',
    this.loanAmount = '',
    this.loanTenure = '',
    this.collateralType = '',
  });

  Map<String, dynamic> toJson() => {
        'personalInfo': {
          'firstName': firstName,
          'lastName': lastName,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
          'nationalId': nationalId,
          'email': email,
          'phone': phone,
          'address': address,
          'city': city,
          'state': state,
          'postalCode': postalCode,
        },
        'employmentDetails': {
          'employmentType': employmentType,
          'employerName': employerName,
          'jobTitle': jobTitle,
          'monthlyIncome': monthlyIncome,
          'yearsEmployed': yearsEmployed,
        },
        'loanDetails': {
          'loanPurpose': loanPurpose,
          'loanAmount': loanAmount,
          'loanTenure': loanTenure,
          'collateralType': collateralType,
        },
      };
}

// ---------------------------------------------------------------------------
// Application State Notifier
// ---------------------------------------------------------------------------
class LoanApplicationState extends ChangeNotifier {
  final LoanApplicationModel application = LoanApplicationModel();
  int _currentStep = 0;
  bool _submitted = false;
  String _referenceNumber = '';

  int get currentStep => _currentStep;
  bool get submitted => _submitted;
  String get referenceNumber => _referenceNumber;

  static const int totalSteps = 4;

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

  void submit() {
    _submitted = true;
    _referenceNumber = 'LOS-${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    notifyListeners();
  }

  void reset() {
    _currentStep = 0;
    _submitted = false;
    _referenceNumber = '';
    // Reset all fields
    final a = application;
    a.firstName = a.lastName = a.dateOfBirth = a.gender = a.nationalId = '';
    a.email = a.phone = a.address = a.city = a.state = a.postalCode = '';
    a.employmentType = a.employerName = a.jobTitle = '';
    a.monthlyIncome = a.yearsEmployed = '';
    a.loanPurpose = a.loanAmount = a.loanTenure = a.collateralType = '';
    notifyListeners();
  }

  // Computed helper
  double get progressFraction =>
      (_currentStep + 1) / totalSteps;

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
}

// ---------------------------------------------------------------------------
// Loan Purpose Options
// ---------------------------------------------------------------------------
const List<String> loanPurposeOptions = [
  'Home Purchase',
  'Home Renovation',
  'Auto Loan',
  'Education',
  'Business Capital',
  'Debt Consolidation',
  'Medical Expenses',
  'Personal/Travel',
  'Other',
];

const List<String> employmentTypeOptions = [
  'Full-Time Employee',
  'Part-Time Employee',
  'Self-Employed',
  'Freelancer / Contractor',
  'Business Owner',
  'Retired',
  'Unemployed',
];

const List<String> genderOptions = [
  'Male',
  'Female',
  'Non-binary',
  'Prefer not to say',
];

const List<String> collateralOptions = [
  'None (Unsecured)',
  'Real Estate',
  'Vehicle',
  'Savings Account',
  'Investment Portfolio',
  'Other',
];

const List<String> tenureOptions = [
  '6 months',
  '12 months',
  '18 months',
  '24 months',
  '36 months',
  '48 months',
  '60 months',
  '84 months',
  '120 months',
  '180 months',
  '240 months',
  '360 months',
];
