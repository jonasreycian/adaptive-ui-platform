import 'package:flutter_test/flutter_test.dart';
import 'package:core_engine/core_engine.dart';
import 'package:branding_engine/branding_engine.dart';

void main() {
  late BrandRegistry registry;

  setUp(() {
    registry = BrandRegistry.instance..clear();
  });

  tearDown(() => registry.clear());

  group('BrandRegistry', () {
    const brand = BrandConfig(
      brandId: 'test_brand',
      displayName: 'Test Brand',
      lightTokens: ColorTokens.light,
      darkTokens: ColorTokens.dark,
    );

    test('register and find', () {
      registry.register(brand);
      expect(registry.find('test_brand'), equals(brand));
    });

    test('contains returns true after register', () {
      registry.register(brand);
      expect(registry.contains('test_brand'), isTrue);
    });

    test('throws on duplicate registration', () {
      registry.register(brand);
      expect(() => registry.register(brand), throwsStateError);
    });

    test('unregister removes brand', () {
      registry.register(brand);
      registry.unregister('test_brand');
      expect(registry.contains('test_brand'), isFalse);
    });

    test('find returns null for unknown brand', () {
      expect(registry.find('unknown'), isNull);
    });
  });

  group('BrandConfig', () {
    const brand = BrandConfig(
      brandId: 'brand_a',
      displayName: 'Brand A',
      lightTokens: ColorTokens.light,
      darkTokens: ColorTokens.dark,
    );

    test('resolveColors light', () {
      expect(brand.resolveColors(isDark: false), equals(ColorTokens.light));
    });

    test('resolveColors dark', () {
      expect(brand.resolveColors(isDark: true), equals(ColorTokens.dark));
    });

    test('equality based on brandId', () {
      const same = BrandConfig(
        brandId: 'brand_a',
        displayName: 'Different Display',
        lightTokens: ColorTokens.light,
        darkTokens: ColorTokens.dark,
      );
      expect(brand, equals(same));
    });
  });

  group('defaultBrand', () {
    test('has expected brandId', () {
      expect(defaultBrand.brandId, 'internal_default');
    });

    test('uses built-in light tokens', () {
      expect(defaultBrand.lightTokens, equals(ColorTokens.light));
    });
  });
}
