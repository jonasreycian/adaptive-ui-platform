import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_engine/core_engine.dart';

void main() {
  group('SpacingTokens', () {
    const spacing = SpacingTokens();

    test('xs is 4', () => expect(spacing.xs, 4.0));
    test('sm is 8', () => expect(spacing.sm, 8.0));
    test('md is 12', () => expect(spacing.md, 12.0));
    test('lg is 16', () => expect(spacing.lg, 16.0));
    test('xl is 24', () => expect(spacing.xl, 24.0));
    test('xxl is 32', () => expect(spacing.xxl, 32.0));
    test('xxxl is 48', () => expect(spacing.xxxl, 48.0));
  });

  group('RadiusTokens', () {
    const radius = RadiusTokens();

    test('sm is 4', () => expect(radius.sm, 4.0));
    test('md is 8', () => expect(radius.md, 8.0));
    test('lg is 12', () => expect(radius.lg, 12.0));
    test('xl is 20', () => expect(radius.xl, 20.0));
  });

  group('MotionTokens', () {
    const motion = MotionTokens();

    test('fast is 150ms', () => expect(motion.fast.inMilliseconds, 150));
    test('normal is 300ms', () => expect(motion.normal.inMilliseconds, 300));
    test('slow is 500ms', () => expect(motion.slow.inMilliseconds, 500));
  });

  group('Breakpoints', () {
    test('mobile width 375 is mobile', () {
      expect(Breakpoints.isMobile(375), isTrue);
      expect(Breakpoints.isTablet(375), isFalse);
    });

    test('tablet width 768 is tablet', () {
      expect(Breakpoints.isTablet(768), isTrue);
      expect(Breakpoints.isMobile(768), isFalse);
    });

    test('desktop width 1200 is desktop', () {
      expect(Breakpoints.isDesktop(1200), isTrue);
    });

    test('largeDesktop width 1440 is largeDesktop', () {
      expect(Breakpoints.isLargeDesktop(1440), isTrue);
      expect(Breakpoints.isDesktop(1440), isFalse);
    });
  });

  group('ColorTokens', () {
    test('light primary is #04382f', () {
      expect(ColorTokens.light.primary.toARGB32(), 0xFF04382F);
    });

    test('dark background is #021d18', () {
      expect(ColorTokens.dark.background.toARGB32(), 0xFF021D18);
    });

    test('copyWith replaces only specified fields', () {
      const updated = ColorTokens(
        primary: Color(0xFF000000),
        accent: Color(0xFF000000),
        background: Color(0xFF000000),
        surface: Color(0xFF000000),
        textPrimary: Color(0xFF000000),
        textSecondary: Color(0xFF000000),
        error: Color(0xFF000000),
        onPrimary: Color(0xFF000000),
        onAccent: Color(0xFF000000),
      );
      final copy = updated.copyWith(primary: const Color(0xFFFFFFFF));
      expect(copy.primary.toARGB32(), 0xFFFFFFFF);
      expect(copy.accent.toARGB32(), 0xFF000000);
    });
  });

  group('AdaptiveTokenSet', () {
    const set = AdaptiveTokenSet.defaultSet;

    test('resolve light', () {
      expect(set.resolve(isDark: false), ColorTokens.light);
    });

    test('resolve dark', () {
      expect(set.resolve(isDark: true), ColorTokens.dark);
    });
  });

  group('ThemeController', () {
    test('starts light by default', () {
      final controller = ThemeController();
      expect(controller.isDark, isFalse);
    });

    test('toggleDark switches mode', () {
      final controller = ThemeController();
      controller.toggleDark();
      expect(controller.isDark, isTrue);
    });

    test('setDark / setLight', () {
      final controller = ThemeController();
      controller.setDark();
      expect(controller.isDark, isTrue);
      controller.setLight();
      expect(controller.isDark, isFalse);
    });

    test('notifies listeners on toggle', () {
      final controller = ThemeController();
      var notified = false;
      controller.addListener(() => notified = true);
      controller.toggleDark();
      expect(notified, isTrue);
    });
  });
}
