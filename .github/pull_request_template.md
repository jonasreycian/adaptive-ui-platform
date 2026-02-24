## Description

<!-- Explain the change: what problem does it solve? Link to the GitHub issue if applicable. -->

Closes #

---

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Refactor / code clean-up
- [ ] Documentation
- [ ] CI / DevOps
- [ ] Other: <!-- describe -->

---

## Packages / apps affected

- [ ] `core_engine`
- [ ] `branding_engine`
- [ ] `adaptive_components`
- [ ] `dashboard_framework`
- [ ] `design_system_showcase`
- [ ] `ckgroup_core_cli`
- [ ] `apps/loan_origination_system`
- [ ] docs only

---

## Tests

> Every PR that adds or modifies code **must** include all applicable test types.
> See [`docs/TESTING_STRATEGY.md`](docs/TESTING_STRATEGY.md) for guidance.

- [ ] **Unit tests** added / updated (`<package>/test/<class>_test.dart`)
- [ ] **Widget tests** added / updated (`<package>/test/<widget>_test.dart`)
- [ ] **E2E / integration tests** added / updated (`<app>/integration_test/`)
- [ ] N/A — this PR contains documentation or CI changes only

All new public APIs have at least one test.

---

## Flutter best practices

- [ ] No hardcoded `Color()`, `EdgeInsets()`, `BorderRadius()`, or `Duration()` values outside token definition files.
- [ ] Tokens consumed via `TokenResolver.of(context)`.
- [ ] `const` constructors used where possible.
- [ ] One primary class per file.
- [ ] Public APIs documented with `///` doc comments.

---

## Checklist

- [ ] `melos analyze` passes with no errors or warnings.
- [ ] `melos test` passes (all packages).
- [ ] `CHANGELOG.md` updated under `[Unreleased]`.
- [ ] Relevant documentation updated (`README.md`, `docs/`, etc.).
- [ ] No new dependencies added without justification.
