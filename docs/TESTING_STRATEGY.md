# Testing Strategy

## Adaptive UI Platform — Widget, Unit & E2E Tests

Every pull request must include all three test types for any code it adds or modifies.
This document explains *what* to test, *how* to write each test type, and *where* files belong.

---

## 1. Test Types at a Glance

| Type | Scope | Tool | Location |
|---|---|---|---|
| **Unit** | Pure logic, models, registries, token values | `package:test` / `flutter_test` | `<package>/test/` |
| **Widget** | Single widget rendering and interactions | `flutter_test` | `<package>/test/` |
| **E2E / Integration** | Full app flows across multiple screens | `integration_test` | `<app>/integration_test/` |

---

## 2. Unit Tests

### What to cover

- Token values (`ColorTokens`, `SpacingTokens`, `MotionTokens`, …)
- Registry behaviour (`BrandRegistry`, `ModuleRegistry`, `PresetRegistry`)
- ViewModel / controller logic (`LoanFormViewModel`, `ThemeController`)
- Model serialisation (`LoanApplicationModel.toJson`)
- Pure utility functions

### Example — token value test (`core_engine`)

```dart
// packages/core_engine/test/tokens_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:core_engine/core_engine.dart';

void main() {
  group('SpacingTokens', () {
    const spacing = SpacingTokens();

    test('xs is 4', () => expect(spacing.xs, 4.0));
    test('lg is 16', () => expect(spacing.lg, 16.0));
  });

  group('ThemeController', () {
    test('starts light by default', () {
      expect(ThemeController().isDark, isFalse);
    });

    test('toggleDark switches mode and notifies listeners', () {
      final ctrl = ThemeController();
      var notified = false;
      ctrl.addListener(() => notified = true);
      ctrl.toggleDark();
      expect(ctrl.isDark, isTrue);
      expect(notified, isTrue);
    });
  });
}
```

### Example — registry test (`branding_engine`)

```dart
// packages/branding_engine/test/brand_registry_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:branding_engine/branding_engine.dart';
import 'package:core_engine/core_engine.dart';

void main() {
  setUp(() => BrandRegistry.instance.clear());
  tearDown(() => BrandRegistry.instance.clear());

  test('register and find', () {
    const brand = BrandConfig(
      brandId: 'test_brand',
      displayName: 'Test',
      lightTokens: ColorTokens.light,
      darkTokens: ColorTokens.dark,
    );
    BrandRegistry.instance.register(brand);
    expect(BrandRegistry.instance.find('test_brand'), equals(brand));
  });

  test('throws StateError on duplicate brandId', () {
    const brand = BrandConfig(
      brandId: 'dup',
      displayName: 'Dup',
      lightTokens: ColorTokens.light,
      darkTokens: ColorTokens.dark,
    );
    BrandRegistry.instance.register(brand);
    expect(() => BrandRegistry.instance.register(brand), throwsStateError);
  });
}
```

---

## 3. Widget Tests

### What to cover

- Widget renders expected text / child widgets
- Correct Flutter widget type is used for each variant (e.g. `ElevatedButton` for primary)
- Loading/disabled states
- Interaction callbacks (tap, text input)
- Responsive behaviour at different screen widths

### Test harness helper

Wrap the widget under test in a minimal `MaterialApp` + `TokenResolver`:

```dart
// packages/adaptive_components/test/helpers/test_harness.dart
import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

Widget buildUnderTest({required Widget child, bool isDark = false}) {
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
```

### Example — `AdaptiveButton` widget test

```dart
// packages/adaptive_components/test/adaptive_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_components/adaptive_components.dart';
import 'helpers/test_harness.dart';

void main() {
  group('AdaptiveButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        buildUnderTest(
          child: AdaptiveButton(label: 'Click me', onPressed: () {}),
        ),
      );
      expect(find.text('Click me'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when isLoading', (tester) async {
      await tester.pumpWidget(
        buildUnderTest(
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
  });
}
```

### Example — responsive layout widget test

```dart
// packages/dashboard_framework/test/adaptive_layout_test.dart
testWidgets('shows mobile widget at 400px width', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(size: Size(400, 900)),
        child: const AdaptiveLayout(
          mobile: Text('mobile'),
          desktop: Text('desktop'),
        ),
      ),
    ),
  );
  expect(find.text('mobile'), findsOneWidget);
  expect(find.text('desktop'), findsNothing);
});
```

---

## 4. E2E / Integration Tests

### Setup

Add `integration_test` to the app's `pubspec.yaml`:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

Create `integration_test/app_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full loan application flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Step 1 — Personal Information
    await tester.enterText(find.byKey(const Key('firstName')), 'Jane');
    await tester.enterText(find.byKey(const Key('lastName')), 'Doe');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 2 — Employment Details
    await tester.enterText(find.byKey(const Key('employerName')), 'ACME Corp');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 3 — Loan Details
    await tester.enterText(find.byKey(const Key('loanAmount')), '50000');
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Step 4 — Review & Submit
    expect(find.text('Jane'), findsWidgets);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Success screen
    expect(find.textContaining('LOS-'), findsOneWidget);
  });
}
```

### Running E2E tests

```bash
# On a connected device or emulator
cd apps/loan_origination_system
flutter test integration_test/app_test.dart

# On Chrome (web)
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart \
  -d chrome
```

---

## 5. Coverage Expectations

| Package | Minimum line coverage |
|---|---|
| `core_engine` | 90 % |
| `branding_engine` | 85 % |
| `adaptive_components` | 80 % |
| `dashboard_framework` | 80 % |
| App demos | 70 % (unit + widget) |

Generate an HTML coverage report:

```bash
cd packages/core_engine
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 6. Test File Naming Conventions

| Pattern | Example |
|---|---|
| Unit test for a class | `<class_name>_test.dart` |
| Widget test for a widget | `<widget_name>_test.dart` |
| E2E test for a flow | `<flow_name>_test.dart` |
| Shared test helpers | `test/helpers/<name>.dart` |

---

## 7. CI Enforcement

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs `flutter test` for every package on every push and pull request to `main`. PRs will not be merged if any test fails.

Future enhancements:
- Coverage gate: fail the build if coverage drops below the thresholds above.
- Golden-image tests: pixel-perfect screenshots using `golden_toolkit`.
- E2E jobs on Android and iOS simulators using Firebase Test Lab.
