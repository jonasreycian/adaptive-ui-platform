# Development Lifecycle

## Adaptive UI Platform — From Discovery to Production

This document describes the full development lifecycle for the Adaptive UI Platform: how a feature moves from an idea through design, implementation, testing, and deployment.

---

## 1. Discovery

### Goal
Understand the problem, stakeholders, and constraints before any code is written.

### Activities

| Activity | Output |
|---|---|
| Stakeholder interviews | Functional requirements list |
| Competitive analysis | Feature gap document |
| Accessibility audit | A11y requirements |
| Platform targets (iOS, Android, Web, Desktop) | Platform matrix |
| Brand inventory | Brand token requirements |

### Outputs

- `docs/requirements/<feature>.md` — functional and non-functional requirements
- Updated `CHANGELOG.md` under `[Unreleased]`

---

## 2. Architecture & Design

### Decisions

1. **Package ownership** — identify which part of `ckgroup_core_engine` owns the feature (tokens, branding, components, dashboard), or whether a new package is needed.
2. **Token contract** — define any new design tokens needed (colours, spacing, motion).
3. **API surface** — sketch the public API before implementation begins.
4. **Dependency direction** — dependencies must flow downward:
   ```
   apps (design_system_showcase, loan_origination_system)
         ↓
   ckgroup_core_engine
   ```
   No circular dependencies are permitted.

### Outputs

- Architecture decision record (ADR) in `docs/adr/<nnnn>-<title>.md`
- Updated `docs/BOOTSTRAP_EXECUTION_PLAN.md` if phase status changes

---

## 3. Development

### Branching Strategy

```
main            ← protected; requires passing CI + 1 review
  └─ feat/<ticket>-<short-description>
  └─ fix/<ticket>-<short-description>
  └─ docs/<short-description>
  └─ chore/<short-description>
```

### Setup

```bash
git clone https://github.com/jonasreycian/adaptive-ui-platform.git
cd adaptive_ui_platform
dart pub global activate melos
melos bootstrap
```

### Daily workflow

```bash
# Analyse all packages
melos analyze

# Run all tests
melos test
melos test:dart   # pure-Dart packages only

# Run a single package
cd packages/ckgroup_core_engine
flutter test
```

### Coding rules (summary)

- No hardcoded `Color()`, `EdgeInsets()`, `BorderRadius()`, or `Duration()` values outside token definition files.
- Use `TokenResolver.of(context)` to consume tokens in widgets.
- Use `const` constructors wherever possible.
- One primary class per file.
- Public APIs must be documented with `///` doc comments.

See [`CONTRIBUTING.md`](../CONTRIBUTING.md) and [`docs/FLUTTER_BEST_PRACTICES.md`](FLUTTER_BEST_PRACTICES.md) for the full ruleset.

---

## 4. Testing

Every pull request **must** include:

| Test type | Tool | Where |
|---|---|---|
| **Unit tests** | `package:test` or `flutter_test` | `<package>/test/` |
| **Widget tests** | `flutter_test` | `<package>/test/` |
| **E2E / integration tests** | `integration_test` | `<app>/integration_test/` |

See [`docs/TESTING_STRATEGY.md`](TESTING_STRATEGY.md) for full details, examples, and coverage expectations.

---

## 5. Code Review

1. Open a Pull Request against `main`.
2. Fill in the **PR template** (`.github/pull_request_template.md`).
3. CI runs automatically: `flutter analyze` + `flutter test` for every package.
4. At least **one approval** is required before merge.
5. Squash-merge is the preferred merge strategy.

---

## 6. CI / CD Pipeline

### Current pipeline (`.github/workflows/ci.yml`)

| Job | Trigger | Steps |
|---|---|---|
| `ckgroup_core_engine` | push / PR to `main` | `flutter pub get` → `flutter analyze` → `flutter test` |
| `ckgroup_core_cli` | push / PR to `main` | `dart pub get` → `dart analyze` → `dart test` |
| `design_system_showcase` | push / PR to `main` | `flutter pub get` → `flutter analyze` → `flutter test` |
| `loan_origination_system` | push / PR to `main` | `flutter pub get` → `flutter analyze` → `flutter test` |

### Planned additions

| Stage | Tool | Status |
|---|---|---|
| Integration / E2E | `integration_test` on emulator | Planned |
| Golden tests | `golden_toolkit` | Planned |
| Coverage gate (≥ 80 %) | `lcov` + coverage action | Planned |
| Release tagging | `melos version` + GitHub Release | Planned |
| Pub publish | `dart pub publish` | Planned |

---

## 7. Release

1. Update `CHANGELOG.md` — move items from `[Unreleased]` to a new version section.
2. Bump package versions in each `pubspec.yaml` following [Semantic Versioning](https://semver.org/).
3. Tag the commit: `git tag v<major>.<minor>.<patch>`.
4. Push the tag to trigger the release workflow (when implemented).

---

## 8. Monitoring & Feedback

- Collect crash reports and performance traces from host apps.
- File issues in GitHub for regressions or new requirements.
- Restart the cycle from **Discovery**.
