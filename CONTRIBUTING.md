# Contributing to Adaptive UI Platform

Thank you for your interest in contributing! This guide will help you get started.

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- [Melos](https://melos.invertase.dev/) (`dart pub global activate melos`)

### Setup

```bash
git clone https://github.com/your-org/adaptive-ui-platform.git
cd adaptive-ui-platform
melos bootstrap
```

---

## Repository Structure

```
adaptive-ui-platform/
├── app/
│   ├── 00_design_system_showcase/      # Demo app showcasing components and tokens
│   └── 01_loan_origination_system/     # Example feature app using the design system
├── packages/
│   ├── core_engine/           # Design tokens + theme
│   ├── branding_engine/       # Brand config + registry
│   ├── adaptive_components/   # Token-driven widgets
│   ├── dashboard_framework/   # Shell, grid, roles, plugins
│   └── design_system_showcase/ # Demo app
├── docs/
├── .github/workflows/
├── melos.yaml
└── pubspec.yaml
```

---

## Workflow

1. **Fork** the repository.
2. **Create a branch** from `main`:
   ```bash
   git checkout -b feat/your-feature-name
   ```
3. **Make changes** following the coding standards below.
4. **Run analysis and tests** before pushing:
   ```bash
   melos analyze
   melos test
   ```
5. **Open a Pull Request** targeting `main`.

---

## Coding Standards

For the full set of Flutter coding rules, patterns, and examples, see [`docs/FLUTTER_BEST_PRACTICES.md`](docs/FLUTTER_BEST_PRACTICES.md).

For integration patterns with Stacked and BLoC architectures, see [`docs/STACKED_AND_BLOC_INTEGRATION.md`](docs/STACKED_AND_BLOC_INTEGRATION.md).

### General

- Use null safety everywhere (`sdk: '>=3.0.0 <4.0.0'`).
- Use `const` constructors where possible.
- Annotate immutable value classes with `@immutable`.
- Keep files focused; one primary class per file.

### Token Rules

- **No hardcoded values** outside token definition files.
  - ✅ `EdgeInsets.all(tokens.spacing.lg)`
  - ❌ `EdgeInsets.all(16)`
- `Color()` constructors are only permitted in `color_tokens.dart`.
- `Duration()` constructors are only permitted in `motion_tokens.dart`.

### Widgets

- Always obtain tokens via `TokenResolver.of(context)`.
- Use `AdaptiveButtonVariant`, not raw Flutter button styles.
- Prefer `AdaptiveScaffold` over raw `Scaffold` in feature code.

### Tests

Every pull request that adds or modifies code **must** include all applicable test types:

- **Unit tests** — pure Dart logic, models, registries (`package:test` or `flutter_test`)
- **Widget tests** — widget rendering and interactions (`flutter_test`)
- **E2E / integration tests** — full app flows (`integration_test`)

Every new public API must have at least one test.

See [`docs/TESTING_STRATEGY.md`](docs/TESTING_STRATEGY.md) for detailed examples and coverage expectations.

---

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(core_engine): add SemanticColorTokens
fix(branding_engine): throw on duplicate brand ID
docs: update MULTI_APP_CONSUMPTION.md
test(adaptive_components): add AdaptiveTextField widget test
```

---

## Changelog

Update `CHANGELOG.md` for every user-facing change under the `[Unreleased]` section.

---

## Code of Conduct

Be respectful, inclusive, and constructive in all interactions.
