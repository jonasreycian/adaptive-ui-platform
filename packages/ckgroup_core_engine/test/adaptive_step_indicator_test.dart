import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

Widget _buildUnderTest({required Widget child, bool isDark = false}) {
  final colors = isDark ? ColorTokens.dark : ColorTokens.light;
  return MaterialApp(
    home: TokenResolver(
      colors: colors,
      spacing: SpacingTokens.instance,
      typography: TypographyTokens.instance,
      radius: RadiusTokens.instance,
      elevation: ElevationTokens.instance,
      motion: MotionTokens.instance,
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('AdaptiveStepIndicator', () {
    testWidgets('renders all step labels', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveStepIndicator(
            currentStep: 0,
            totalSteps: 3,
            labels: ['Step A', 'Step B', 'Step C'],
          ),
        ),
      );
      expect(find.text('Step A'), findsOneWidget);
      expect(find.text('Step B'), findsOneWidget);
      expect(find.text('Step C'), findsOneWidget);
    });

    testWidgets('shows check icon for completed steps', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveStepIndicator(
            currentStep: 2,
            totalSteps: 3,
            labels: ['A', 'B', 'C'],
          ),
        ),
      );
      // Steps 0 and 1 are completed → two check icons
      expect(find.byIcon(Icons.check), findsNWidgets(2));
    });

    testWidgets('shows step numbers for non-completed steps', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveStepIndicator(
            currentStep: 0,
            totalSteps: 3,
            labels: ['A', 'B', 'C'],
          ),
        ),
      );
      // No steps completed → no check icons
      expect(find.byIcon(Icons.check), findsNothing);
      // Step numbers 1, 2, 3 rendered as text
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders correctly in dark mode', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          isDark: true,
          child: const AdaptiveStepIndicator(
            currentStep: 1,
            totalSteps: 2,
            labels: ['One', 'Two'],
          ),
        ),
      );
      expect(find.byType(AdaptiveStepIndicator), findsOneWidget);
    });
  });
}
