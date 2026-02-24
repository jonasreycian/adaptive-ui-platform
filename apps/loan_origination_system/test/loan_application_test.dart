import 'package:flutter_test/flutter_test.dart';
import 'package:loan_origination_system/models/loan_application.dart';
import 'package:loan_origination_system/viewmodels/loan_form_viewmodel.dart';

void main() {
  group('LoanApplicationModel', () {
    test('initialises with empty strings', () {
      final model = LoanApplicationModel();
      expect(model.firstName, isEmpty);
      expect(model.loanAmount, isEmpty);
      expect(model.loanPurpose, isEmpty);
    });

    test('toJson contains all three sections', () {
      final model = LoanApplicationModel(
        firstName: 'Jane',
        lastName: 'Doe',
        loanAmount: '25000',
        loanPurpose: 'Home Purchase',
      );
      final json = model.toJson();
      expect(json.containsKey('personalInfo'), isTrue);
      expect(json.containsKey('employmentDetails'), isTrue);
      expect(json.containsKey('loanDetails'), isTrue);
      expect(json['personalInfo']['firstName'], equals('Jane'));
      expect(json['loanDetails']['loanAmount'], equals('25000'));
    });
  });

  group('LoanFormViewModel', () {
    test('starts at step 0', () {
      final vm = LoanFormViewModel();
      expect(vm.currentStep, equals(0));
    });

    test('nextStep increments currentStep', () {
      final vm = LoanFormViewModel();
      vm.nextStep();
      expect(vm.currentStep, equals(1));
    });

    test('previousStep decrements currentStep', () {
      final vm = LoanFormViewModel();
      vm.nextStep();
      vm.nextStep();
      vm.previousStep();
      expect(vm.currentStep, equals(1));
    });

    test('previousStep does not go below 0', () {
      final vm = LoanFormViewModel();
      vm.previousStep();
      expect(vm.currentStep, equals(0));
    });

    test('nextStep does not exceed totalSteps - 1', () {
      final vm = LoanFormViewModel();
      for (int i = 0; i < LoanFormViewModel.totalSteps + 5; i++) {
        vm.nextStep();
      }
      expect(vm.currentStep, equals(LoanFormViewModel.totalSteps - 1));
    });

    test('goToStep navigates to specified step', () {
      final vm = LoanFormViewModel();
      vm.goToStep(2);
      expect(vm.currentStep, equals(2));
    });

    test('submit sets submitted flag and reference number', () {
      final vm = LoanFormViewModel();
      expect(vm.submitted, isFalse);
      vm.submit();
      expect(vm.submitted, isTrue);
      expect(vm.referenceNumber, startsWith('LOS-'));
    });

    test('reset clears all state', () {
      final vm = LoanFormViewModel();
      vm.application.firstName = 'Test';
      vm.nextStep();
      vm.submit();
      vm.reset();
      expect(vm.currentStep, equals(0));
      expect(vm.submitted, isFalse);
      expect(vm.referenceNumber, isEmpty);
      expect(vm.application.firstName, isEmpty);
    });

    test('progressFraction reflects step progress', () {
      final vm = LoanFormViewModel();
      expect(vm.progressFraction,
          closeTo(1 / LoanFormViewModel.totalSteps, 0.001));
      vm.nextStep();
      expect(vm.progressFraction,
          closeTo(2 / LoanFormViewModel.totalSteps, 0.001));
    });

    test('formattedLoanAmount returns dash when empty', () {
      final vm = LoanFormViewModel();
      expect(vm.formattedLoanAmount, equals('—'));
    });

    test('formattedLoanAmount formats correctly', () {
      final vm = LoanFormViewModel();
      vm.application.loanAmount = '25000';
      expect(vm.formattedLoanAmount, contains('25,000'));
    });

    test('stepLabel returns correct label for each step', () {
      final vm = LoanFormViewModel();
      expect(vm.stepLabel, equals('Personal Information'));
      vm.goToStep(1);
      expect(vm.stepLabel, equals('Employment Details'));
      vm.goToStep(2);
      expect(vm.stepLabel, equals('Loan Details'));
      vm.goToStep(3);
      expect(vm.stepLabel, equals('Review & Submit'));
    });
  });

  group('Loan options constants', () {
    test('loanPurposeOptions is non-empty', () {
      expect(loanPurposeOptions, isNotEmpty);
    });

    test('employmentTypeOptions is non-empty', () {
      expect(employmentTypeOptions, isNotEmpty);
    });

    test('tenureOptions contains expected durations', () {
      expect(tenureOptions.contains('12 months'), isTrue);
      expect(tenureOptions.contains('360 months'), isTrue);
    });
  });
}
