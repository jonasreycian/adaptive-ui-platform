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
  group('AdaptiveInfoChip', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveInfoChip(
            label: 'Approved',
            icon: Icons.check_circle_outline,
          ),
        ),
      );
      expect(find.text('Approved'), findsOneWidget);
    });

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveInfoChip(
            label: 'Info',
            icon: Icons.info_outline,
          ),
        ),
      );
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('accepts optional color override', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveInfoChip(
            label: 'Warning',
            icon: Icons.warning_outlined,
            color: Colors.orange,
          ),
        ),
      );
      expect(find.text('Warning'), findsOneWidget);
      expect(find.byIcon(Icons.warning_outlined), findsOneWidget);
    });

    testWidgets('renders without explicit color (uses primary)', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveInfoChip(
            label: 'Default',
            icon: Icons.label_outline,
          ),
        ),
      );
      expect(find.byType(AdaptiveInfoChip), findsOneWidget);
    });

    testWidgets('renders correctly in dark mode', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          isDark: true,
          child: const AdaptiveInfoChip(
            label: 'Dark chip',
            icon: Icons.nights_stay_outlined,
          ),
        ),
      );
      expect(find.text('Dark chip'), findsOneWidget);
    });
  });
}
