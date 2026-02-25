# Adaptive UI Platform — Combined Demo App

This is the **combined demo application** for the Adaptive UI Platform. It merges
the original design-system showcase and the Loan Origination System into a single
app that demonstrates both platform capabilities and a real-world use case, all
powered by the adaptive UI design tokens.

---

## Features

### Design System Showcase
- **Token Inspector** — Browse all design tokens (colours, spacing, radius, motion)
- **Components** — AdaptiveButton, AdaptiveTextField, AdaptiveDialog
- **Dashboard** — Responsive shell, grid layout, adaptive navigation
- **Brand Switcher** — Runtime brand switching with live token updates

### Loan Origination System
- **Multi-step loan application form** with animated transitions and progress tracking
- **Responsive layout**: sidebar navigation on tablet/desktop, linear flow on mobile
- **4 Form Steps**:
  1. Personal Information (name, DOB, gender, contact & address)
  2. Employment Details (type, employer, income)
  3. Loan Details (purpose, amount, tenure, collateral) with live EMI estimate
  4. Review & Submit with declaration checkboxes
- **Success screen** with reference number and next-steps guide
- **Applications dashboard** — searchable, sortable AdaptiveTable of loan records

---

## Adaptive UI Integration

All screens in this combined app use the Adaptive UI Platform tokens through
`TokenResolver.of(context)`. This means:

- **Reactive theming** — switching light/dark mode updates every screen instantly
- **Brand-aware** — all platform colours (`primary`, `accent`, `surface`, etc.) come
  from the active brand via `TokenResolver`
- **Single source of truth** — no duplicate colour or spacing constants for
  platform tokens; only loan-specific semantic colours (`success`, `warning`, etc.)
  are declared locally in `loan/theme/loan_theme.dart`

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.10+ |
| State Management | `stacked` (LoanFormViewModel) |
| Theming | `core_engine` TokenResolver + ThemeController |
| Branding | `branding_engine` BrandRegistry / BrandResolver |
| Components | `adaptive_components` AdaptiveButton, AdaptiveTable, etc. |
| Navigation | `dashboard_framework` DashboardShell |

---

## Getting Started

```bash
# From the apps/00_design_system_showcase directory
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

### Analyze

```bash
flutter analyze
```

---

## Project Structure

```
lib/
├── main.dart                        # App entry point
└── src/
    ├── app.dart                     # Root widget (ThemeController + TokenResolver)
    ├── screens/
    │   ├── home_screen.dart         # Home — links to all demos
    │   ├── token_inspector_screen.dart
    │   ├── component_demo_screen.dart
    │   ├── dashboard_demo_screen.dart
    │   └── brand_switcher_screen.dart
    └── loan/                        # Loan Origination System section
        ├── models/
        │   └── loan_application.dart
        ├── viewmodels/
        │   └── loan_form_viewmodel.dart
        ├── widgets/
        │   └── common_widgets.dart  # Adaptive UI widgets (TokenResolver)
        ├── theme/
        │   └── loan_theme.dart      # Non-platform colours + const token mirrors
        └── screens/
            ├── loan_origination_screen.dart  # Shell + responsive layout
            ├── step1_personal_info.dart
            ├── step2_employment.dart
            ├── step3_loan_details.dart
            ├── step4_review_submit.dart
            ├── success_screen.dart
            └── loan_applications_screen.dart

test/
├── showcase_test.dart               # Tests for ShowcaseApp & HomeScreen
└── loan_application_test.dart       # Tests for LoanApplicationModel & ViewModel
```

---

## Design Tokens

All adaptive platform tokens are consumed via `TokenResolver.of(context)`:

| Token | Light | Dark |
|-------|-------|------|
| `primary` | `#04382F` | `#EABC3D` |
| `accent` | `#EABC3D` | `#04382F` |
| `background` | `#F4F6F5` | `#021D18` |
| `surface` | `#FFFFFF` | `#04382F` |
| Spacing scale | 4, 8, 12, 16, 24, 32, 48 px | same |
| Radius | 4, 8, 12, 20 px | same |
| Motion | 150ms, 300ms, 500ms | same |

