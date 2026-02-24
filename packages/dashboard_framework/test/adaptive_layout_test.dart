import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_engine/core_engine.dart';
import 'package:branding_engine/branding_engine.dart';
import 'package:dashboard_framework/dashboard_framework.dart';

Widget _buildUnderTest({required Widget child, double width = 800}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, 900)),
      child: TokenResolver(
        colors: ColorTokens.light,
        spacing: SpacingTokens.instance,
        typography: TypographyTokens.instance,
        radius: RadiusTokens.instance,
        elevation: ElevationTokens.instance,
        motion: MotionTokens.instance,
        child: BrandResolver(
          brand: defaultBrand,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('AdaptiveLayout', () {
    testWidgets('shows mobile widget at 400px', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          width: 400,
          child: const AdaptiveLayout(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      );
      expect(find.text('mobile'), findsOneWidget);
      expect(find.text('desktop'), findsNothing);
    });

    testWidgets('shows desktop widget at 1200px', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: const AdaptiveLayout(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      );
      expect(find.text('desktop'), findsOneWidget);
      expect(find.text('mobile'), findsNothing);
    });

    testWidgets('shows tablet widget at 800px when provided', (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          width: 800,
          child: const AdaptiveLayout(
            mobile: Text('mobile'),
            tablet: Text('tablet'),
            desktop: Text('desktop'),
          ),
        ),
      );
      expect(find.text('tablet'), findsOneWidget);
    });

    testWidgets('falls back to desktop at tablet width when no tablet',
        (tester) async {
      await tester.pumpWidget(
        _buildUnderTest(
          width: 800,
          child: const AdaptiveLayout(
            mobile: Text('mobile'),
            desktop: Text('desktop'),
          ),
        ),
      );
      expect(find.text('desktop'), findsOneWidget);
    });
  });

  group('ModuleRegistry', () {
    late ModuleRegistry registry;

    setUp(() {
      registry = ModuleRegistry.instance..clear();
    });

    tearDown(() => registry.clear());

    test('register and find', () {
      final module = _TestModule('mod_a');
      registry.register(module);
      expect(registry.find('mod_a'), equals(module));
    });

    test('throws on duplicate ID', () {
      registry.register(_TestModule('mod_a'));
      expect(() => registry.register(_TestModule('mod_a')), throwsStateError);
    });

    test('throws on empty ID', () {
      expect(() => registry.register(_TestModule('')), throwsStateError);
    });

    test('forRole filters correctly', () {
      registry.register(_TestModule('admin_mod', role: UserRole.admin));
      registry.register(_TestModule('user_mod', role: UserRole.user));
      final adminModules = registry.forRole(UserRole.admin);
      expect(adminModules.length, 1);
      expect(adminModules.first.moduleId, 'admin_mod');
    });
  });
}

class _TestModule extends AdaptiveModule {
  _TestModule(this.moduleId, {UserRole role = UserRole.user})
      : allowedRoles = [role];

  @override
  final String moduleId;

  @override
  String get displayName => moduleId;

  @override
  final List<UserRole> allowedRoles;

  @override
  Widget buildContent(BuildContext context) => const SizedBox.shrink();
}
