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