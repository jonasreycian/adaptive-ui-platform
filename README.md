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