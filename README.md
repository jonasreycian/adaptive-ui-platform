# adaptive-ui-platform

Enterprise-grade internal Flutter UI platform supporting multi-package monorepo architecture, design token system, dark mode, white-label branding, adaptive components, and responsive dashboards.

---

## Repository Structure

```
adaptive-ui-platform/
├── apps/                             # Demo applications
│   └── loan_origination_system/      # Loan Origination System demo
├── docs/                             # Planning & architecture docs
│   └── BOOTSTRAP_EXECUTION_PLAN.md
└── README.md
```

---

## Demo Apps

### Loan Origination System (`apps/loan_origination_system`)

A full-featured loan application form demo built with Flutter.  
Customers walk through a 4-step process to apply for a loan:

1. **Personal Information** — name, date of birth, contact & address
2. **Employment Details** — employer, type, monthly income
3. **Loan Details** — purpose, amount, tenure, collateral (with live EMI estimate)
4. **Review & Submit** — confirmation with reference number

**Run the app:**
```bash
cd apps/loan_origination_system
flutter pub get
flutter run
```

See [`apps/loan_origination_system/README.md`](apps/loan_origination_system/README.md) for full details.

---

## Platform Bootstrap Plan

See [`docs/BOOTSTRAP_EXECUTION_PLAN.md`](docs/BOOTSTRAP_EXECUTION_PLAN.md) for the full platform architecture and build roadmap.

---

## Documentation

| Document | Description |
|---|---|
| [`docs/BOOTSTRAP_EXECUTION_PLAN.md`](docs/BOOTSTRAP_EXECUTION_PLAN.md) | Platform architecture layers and bootstrap phase status |
| [`docs/DEVELOPMENT_LIFECYCLE.md`](docs/DEVELOPMENT_LIFECYCLE.md) | Full lifecycle: discovery → design → development → testing → CI/CD → release |
| [`docs/TESTING_STRATEGY.md`](docs/TESTING_STRATEGY.md) | Widget, unit, and E2E test standards with code examples |
| [`docs/FLUTTER_BEST_PRACTICES.md`](docs/FLUTTER_BEST_PRACTICES.md) | Flutter coding rules and patterns for all packages and demo apps |
| [`docs/STACKED_AND_BLOC_INTEGRATION.md`](docs/STACKED_AND_BLOC_INTEGRATION.md) | Integration guides for Stacked and BLoC architectures |
| [`docs/MULTI_APP_CONSUMPTION.md`](docs/MULTI_APP_CONSUMPTION.md) | How host apps consume platform packages via Git or path dependencies |
| [`CONTRIBUTING.md`](CONTRIBUTING.md) | Branching, coding standards, commit conventions |
| [`CHANGELOG.md`](CHANGELOG.md) | Version history |

---

## Copilot Guidelines

> These guidelines help GitHub Copilot (and other AI coding assistants) generate
> code that fits correctly into this monorepo.

### Package ownership

| Package | Responsibility |
|---|---|
| `core_engine` | Design tokens (`ColorTokens`, `SpacingTokens`, `MotionTokens`, …) and `TokenResolver` |
| `branding_engine` | `BrandConfig`, `BrandRegistry`, `BrandResolver`, `defaultBrand` |
| `adaptive_components` | Token-driven widgets — `AdaptiveButton`, `AdaptiveTextField`, `AdaptiveScaffold`, … |
| `dashboard_framework` | Layouts, shell, grid, role-based module registry, `DashboardShell` |
| `design_system_showcase` | Demo Flutter app wiring all packages together |
| `ckgroup_core_cli` | Pure-Dart CLI for managing `page_registry.json` |

Dependency direction (never reverse this):
```
apps / design_system_showcase
       ↓
dashboard_framework
       ↓
adaptive_components
       ↓
branding_engine
       ↓
core_engine
```

### Token rules (critical)

- **Never** use raw `Color()`, `EdgeInsets`, `BorderRadius`, or `Duration` literals in widget or feature code.
- All colors, spacing, radii, elevations, and motion values must be read via `TokenResolver.of(context)`:
  ```dart
  final tokens = TokenResolver.of(context);
  // ✅ correct
  padding: EdgeInsets.all(tokens.spacing.lg),
  color: tokens.colors.primary,
  // ❌ forbidden
  padding: EdgeInsets.all(16),
  color: Color(0xFF04382F),
  ```
- `Color()` constructors are allowed **only** inside `packages/core_engine/lib/src/tokens/color_tokens.dart`.
- `Duration()` constructors are allowed **only** inside `packages/core_engine/lib/src/tokens/motion_tokens.dart`.

### Widget guidelines

- Prefer `AdaptiveScaffold` over `Scaffold`.
- Use `AdaptiveButton` (with `AdaptiveButtonVariant`) instead of raw `ElevatedButton` / `TextButton`.
- Wrap custom widgets in a `TokenResolver` + `BrandResolver` in tests (see existing test helpers).
- Annotate immutable value classes with `@immutable` and use `const` constructors wherever possible.

### Test requirements

Every PR that introduces or modifies code must include **all three** of:

1. **Unit tests** — logic, registries, view-models (`<package>/test/<class>_test.dart`)
2. **Widget tests** — rendering and interactions (`<package>/test/<widget>_test.dart`)
3. **E2E / integration tests** — full app flows (`<app>/integration_test/<flow>_test.dart`)

Test helper pattern (copy from any existing test file):
```dart
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

### Commit message format

```
feat(adaptive_components): add AdaptiveCard widget
fix(dashboard_framework): correct sidebar collapse animation
test(core_engine): cover MotionTokens edge cases
docs: update MULTI_APP_CONSUMPTION.md
```

Follow [Conventional Commits](https://www.conventionalcommits.org/). Scope must match the affected package name.

### Running checks locally

```bash
# Analyze all packages
melos analyze
melos analyze:dart   # pure-Dart packages

# Test all packages
melos test
melos test:dart      # pure-Dart packages

# Single package
cd packages/<package_name>
flutter test
```

CI runs `flutter analyze` and `flutter test` on every package for every push and pull request to `main`.