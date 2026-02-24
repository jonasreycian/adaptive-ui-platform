# Changelog

All notable changes to the Adaptive UI Platform are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- `docs/DEVELOPMENT_LIFECYCLE.md` — full lifecycle guide from discovery through CI/CD and release.
- `docs/TESTING_STRATEGY.md` — widget, unit, and E2E test standards with code examples.
- `docs/FLUTTER_BEST_PRACTICES.md` — Flutter coding rules for all packages and demo apps.
- `docs/STACKED_AND_BLOC_INTEGRATION.md` — integration guides for Stacked and BLoC architectures.
- `.github/pull_request_template.md` — PR checklist enforcing test requirements.
- `README.md` — documentation index table and **Copilot Guidelines** section.
- Updated `CONTRIBUTING.md` to reference new docs and clarify test requirements.
- `packages/design_system_showcase/test/showcase_test.dart` — widget tests for `ShowcaseApp`.

### Fixed
- `dashboard_framework` — `page_registry_widget_test.dart`: relaxed `Center` assertion from `findsOneWidget` to `findsAtLeastNWidgets(1)` to be resilient against internal Flutter framework widgets.
- `.github/pull_request_template.md` — corrected relative link path for `TESTING_STRATEGY.md`.

---

## [0.1.0] — Initial Bootstrap

### Added

#### `core_engine` (v0.1.0)
- `ColorTokens` — immutable light and dark palettes with brand seed
  (`primary=#04382f`, `accent=#eabc3d`).
- `SpacingTokens` — scale from `xs` (4 dp) to `xxxl` (48 dp).
- `TypographyTokens` — display, headline, title, body, and label scales.
- `RadiusTokens` — `sm` (4) → `xl` (20).
- `ElevationTokens` — `none` → `xl`.
- `MotionTokens` — `fast` (150 ms), `normal` (300 ms), `slow` (500 ms) with
  `easeInOut` and `easeOutCubic` curves.
- `Breakpoints` — mobile < 600, tablet 600–1023, desktop 1024–1439,
  largeDesktop ≥ 1440.
- `AdaptiveTokenSet` — light/dark token pair with `resolve(isDark:)` helper.
- `TokenResolver` — `InheritedWidget` distributing all token groups.
- `ThemeController` — `ChangeNotifier` for runtime dark/light toggling.

#### `branding_engine` (v0.1.0)
- `BrandConfig` — per-brand token overrides, layout config, and feature flags.
- `LayoutConfig` — sidebar width, collapsed sidebar width, header height.
- `BrandRegistry` — process-scoped singleton; throws `StateError` on duplicate.
- `BrandResolver` — `InheritedWidget` providing the active `BrandConfig`.
- `defaultBrand` — built-in default brand (`brandId: internal_default`).

#### `adaptive_components` (v0.1.0)
- `AdaptivePlatform` enum and `AdaptivePlatformDetector`.
- `AdaptiveRender` — render different children per platform.
- `AdaptiveButton` — primary / secondary / outlined / ghost variants.
- `AdaptiveTextField` — label, hint, error, prefix/suffix icon support.
- `AdaptiveDialog` — modal dialog with token-driven styles.
- `AdaptiveScaffold` — scaffold wired to token background color.
- `AdaptiveNavigationBar` — token-driven bottom navigation bar.

#### `dashboard_framework` (v0.1.0)
- `AdaptiveLayout` — mobile / tablet / desktop switching widget.
- `ResponsiveBuilder` — builder callback with `ScreenSize` enum.
- `DashboardShell` — drawer (mobile), rail (tablet), animated sidebar (desktop).
- `DashboardGrid` — responsive column grid driven by breakpoints.
- `UserRole` enum — `admin`, `user`, `viewer`, `guest`.
- `DashboardPreset` + `PresetRegistry` — role-based preset management.
- `AdaptiveModule` — abstract base for pluggable dashboard modules.
- `ModuleRegistry` — singleton; throws on duplicate or empty module ID.

#### `design_system_showcase` (v1.0.0+1)
- Full demo app with `HomeScreen`, `TokenInspectorScreen`,
  `ComponentDemoScreen`, `DashboardDemoScreen`, and `BrandSwitcherScreen`.

#### CI / Governance
- GitHub Actions workflow (`ci.yml`) — `flutter analyze` + `flutter test`
  for every package on push and pull-request to `main`.
- `CONTRIBUTING.md`, `CODEOWNERS`, `CHANGELOG.md`.
- `docs/BOOTSTRAP_EXECUTION_PLAN.md`, `docs/MULTI_APP_CONSUMPTION.md`.
