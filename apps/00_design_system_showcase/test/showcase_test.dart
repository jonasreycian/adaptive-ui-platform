import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:branding_engine/branding_engine.dart';
import 'package:design_system_showcase/src/app.dart';

void main() {
  setUp(() {
    BrandRegistry.instance.clear();
    BrandRegistry.instance.register(defaultBrand);
  });

  tearDown(() {
    BrandRegistry.instance.clear();
  });

  group('ShowcaseApp', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(const ShowcaseApp());
      await tester.pump();
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('HomeScreen shows expected demo titles', (tester) async {
      await tester.pumpWidget(const ShowcaseApp());
      await tester.pump();

      expect(find.text('Token Inspector'), findsOneWidget);
      expect(find.text('Components'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Brand Switcher'), findsOneWidget);
    });

    testWidgets('HomeScreen AppBar shows title', (tester) async {
      await tester.pumpWidget(const ShowcaseApp());
      await tester.pump();

      expect(find.text('Adaptive UI Showcase'), findsOneWidget);
    });

    testWidgets('HomeScreen has theme toggle button', (tester) async {
      await tester.pumpWidget(const ShowcaseApp());
      await tester.pump();

      expect(find.byType(IconButton), findsAtLeastNWidgets(1));
    });
  });
}
