import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_engine/core_engine.dart';
import 'package:adaptive_components/adaptive_components.dart';

Widget _buildUnderTest({
  required Widget child,
  bool isDark = false,
}) {
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
  group('AdaptiveButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveButton(
            label: 'Click me',
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('primary variant uses ElevatedButton', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveButton(
            label: 'Primary',
            onPressed: () {},
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('outlined variant uses OutlinedButton', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveButton(
            label: 'Outlined',
            onPressed: () {},
            variant: AdaptiveButtonVariant.outlined,
          ),
        ),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('ghost variant uses TextButton', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: AdaptiveButton(
            label: 'Ghost',
            onPressed: () {},
            variant: AdaptiveButtonVariant.ghost,
          ),
        ),
      );
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveButton(
            label: 'Loading',
            onPressed: null,
            isLoading: true,
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          child: const AdaptiveButton(
            label: 'Disabled',
            onPressed: null,
          ),
        ),
      );
      final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(btn.onPressed, isNull);
    });
  });
}
