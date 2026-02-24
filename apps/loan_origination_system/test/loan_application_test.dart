import 'package:flutter_test/flutter_test.dart';
import 'package:loan_origination_system/models/loan_application.dart';

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

  group('LoanApplicationState', () {
    test('starts at step 0', () {
      final state = LoanApplicationState();
      expect(state.currentStep, equals(0));
    });

    test('nextStep increments currentStep', () {
      final state = LoanApplicationState();
      state.nextStep();
      expect(state.currentStep, equals(1));
    });

    test('previousStep decrements currentStep', () {
      final state = LoanApplicationState();
      state.nextStep();
      state.nextStep();
      state.previousStep();
      expect(state.currentStep, equals(1));
    });

    test('previousStep does not go below 0', () {
      final state = LoanApplicationState();
      state.previousStep();
      expect(state.currentStep, equals(0));
    });

    test('nextStep does not exceed totalSteps - 1', () {
      final state = LoanApplicationState();
      for (int i = 0; i < LoanApplicationState.totalSteps + 5; i++) {
        state.nextStep();
      }
      expect(
          state.currentStep, equals(LoanApplicationState.totalSteps - 1));
    });

    test('goToStep navigates to specified step', () {
      final state = LoanApplicationState();
      state.goToStep(2);
      expect(state.currentStep, equals(2));
    });

    test('submit sets submitted flag and reference number', () {
      final state = LoanApplicationState();
      expect(state.submitted, isFalse);
      state.submit();
      expect(state.submitted, isTrue);
      expect(state.referenceNumber, startsWith('LOS-'));
    });

    test('reset clears all state', () {
      final state = LoanApplicationState();
      state.application.firstName = 'Test';
      state.nextStep();
      state.submit();
      state.reset();
      expect(state.currentStep, equals(0));
      expect(state.submitted, isFalse);
      expect(state.referenceNumber, isEmpty);
      expect(state.application.firstName, isEmpty);
    });

    test('progressFraction reflects step progress', () {
      final state = LoanApplicationState();
      expect(state.progressFraction,
          closeTo(1 / LoanApplicationState.totalSteps, 0.001));
      state.nextStep();
      expect(state.progressFraction,
          closeTo(2 / LoanApplicationState.totalSteps, 0.001));
    });

    test('formattedLoanAmount returns dash when empty', () {
      final state = LoanApplicationState();
      expect(state.formattedLoanAmount, equals('—'));
    });

    test('formattedLoanAmount formats correctly', () {
      final state = LoanApplicationState();
      state.application.loanAmount = '25000';
      expect(state.formattedLoanAmount, contains('25,000'));
    });

    test('stepLabel returns correct label for each step', () {
      final state = LoanApplicationState();
      expect(state.stepLabel, equals('Personal Information'));
      state.goToStep(1);
      expect(state.stepLabel, equals('Employment Details'));
      state.goToStep(2);
      expect(state.stepLabel, equals('Loan Details'));
      state.goToStep(3);
      expect(state.stepLabel, equals('Review & Submit'));
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
