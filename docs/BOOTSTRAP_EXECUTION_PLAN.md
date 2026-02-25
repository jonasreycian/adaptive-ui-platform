# Bootstrap Execution Plan

## Adaptive UI Platform — Monorepo Foundation

### Overview

This document outlines the bootstrap execution plan for the `adaptive-ui-platform` Flutter monorepo.
The goal is to establish a layered, brand-agnostic, and role-aware UI foundation that can be consumed
by multiple host applications.

---

## Architecture Layers

```
┌──────────────────────────────────────────┐
│          design_system_showcase          │  Flutter app (demo)
├──────────────────────────────────────────┤
│          ckgroup_core_engine             │  Tokens, theme, branding,
│                                          │  components, shell, grid,
│                                          │  roles, plugins
└──────────────────────────────────────────┘
```

---

## Phase 1 — Token Foundation (`ckgroup_core_engine` — tokens layer)

**Goal:** Define the single source of truth for all visual constants.

| Deliverable | Status |
|---|---|
| `ColorTokens` (light + dark palettes) | ✅ |
| `SpacingTokens` (xs → xxxl) | ✅ |
| `TypographyTokens` (display → label scale) | ✅ |
| `RadiusTokens` (sm → xl) | ✅ |
| `ElevationTokens` (none → xl) | ✅ |
| `MotionTokens` (fast/normal/slow + curves) | ✅ |
| `Breakpoints` (mobile/tablet/desktop/large) | ✅ |
| `AdaptiveTokenSet` (light + dark pair) | ✅ |
| `TokenResolver` (InheritedWidget) | ✅ |
| `ThemeController` (ChangeNotifier) | ✅ |

**Design Decisions:**
- All token values are defined exactly once (no duplication across files).
- `Color()` constructors are allowed only inside `color_tokens.dart`.
- All other files consume tokens via `TokenResolver.of(context)`.

---

## Phase 2 — Brand System (`ckgroup_core_engine` — branding layer)

**Goal:** Allow multiple brands to coexist, each with its own token overrides and layout config.

| Deliverable | Status |
|---|---|
| `BrandConfig` (tokens + layout + feature flags) | ✅ |
| `LayoutConfig` (sidebar widths, header height) | ✅ |
| `BrandRegistry` (singleton, throws on duplicate) | ✅ |
| `BrandResolver` (InheritedWidget) | ✅ |
| `defaultBrand` constant | ✅ |

**Design Decisions:**
- `BrandRegistry` is a process-scoped singleton; consumers register brands at app startup.
- `BrandConfig.brandId` is the stable identity key (display name can change).

---

## Phase 3 — Adaptive Components (`ckgroup_core_engine` — components layer)

**Goal:** Provide a library of token-driven, platform-aware widgets.

| Deliverable | Status |
|---|---|
| `AdaptivePlatform` + `AdaptivePlatformDetector` | ✅ |
| `AdaptiveRender` (platform-switching widget) | ✅ |
| `AdaptiveButton` (primary/secondary/outlined/ghost) | ✅ |
| `AdaptiveTextField` | ✅ |
| `AdaptiveDialog` | ✅ |
| `AdaptiveScaffold` | ✅ |
| `AdaptiveNavigationBar` | ✅ |

**Design Decisions:**
- No hardcoded `Color()`, `EdgeInsets()`, `BorderRadius()`, or `Duration()` outside token definitions.
- Platform detection uses `kIsWeb` + `defaultTargetPlatform` (no `dart:io`).

---

## Phase 4 — Dashboard Framework (`ckgroup_core_engine` — dashboard layer)

**Goal:** Provide a composable, role-aware dashboard shell and plugin system.

| Deliverable | Status |
|---|---|
| `AdaptiveLayout` (mobile/tablet/desktop) | ✅ |
| `ResponsiveBuilder` | ✅ |
| `DashboardShell` (drawer/rail/sidebar) | ✅ |
| `DashboardGrid` (responsive columns) | ✅ |
| `UserRole` enum | ✅ |
| `DashboardPreset` + `PresetRegistry` | ✅ |
| `AdaptiveModule` (abstract) | ✅ |
| `ModuleRegistry` (throws on invalid/duplicate) | ✅ |

**Design Decisions:**
- `DashboardShell` animates sidebar collapse on desktop.
- Module and preset registries are process-scoped singletons.
- Role filtering is done at query time, not at registration time.

---

## Phase 5 — Showcase App (`design_system_showcase`)

| Deliverable | Status |
|---|---|
| `main.dart` with brand registration | ✅ |
| `ShowcaseApp` with `ThemeController` + `BrandResolver` | ✅ |
| `HomeScreen` with demo navigation | ✅ |
| `TokenInspectorScreen` | ✅ |
| `ComponentDemoScreen` | ✅ |
| `DashboardDemoScreen` | ✅ |
| `BrandSwitcherScreen` | ✅ |

---

## CI Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs:

1. `flutter analyze` on each package.
2. `flutter test` on each package.

Triggered on: `push` and `pull_request` to `main`.

---

## Next Steps (Post-Bootstrap)

1. **Asset pipeline** — add font and image asset management to `ckgroup_core_engine`.
2. **Localisation** — integrate `flutter_localizations` into `ckgroup_core_engine`.
3. **Accessibility** — add semantic labels to all interactive widgets.
4. **Golden tests** — establish pixel-perfect golden tests for all components.
5. **Storybook-style catalogue** — extend `design_system_showcase` with isolated
   component stories.
6. **Pub publishing** — configure `publish_to` and version management for open-source
   consumption.
