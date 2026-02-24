# Loan Origination System — Demo App

A working demo application built on the **Adaptive UI Platform** that demonstrates a full loan application workflow. Customers can fill out a multi-step form to apply for a loan.

---

## Features

- **Multi-step form** with animated transitions and progress tracking
- **Responsive layout**: sidebar navigation on tablet/desktop, linear flow on mobile
- **4 Form Steps**:
  1. Personal Information (name, DOB, gender, contact & address)
  2. Employment Details (type, employer, income)
  3. Loan Details (purpose, amount, tenure, collateral) with live EMI estimate
  4. Review & Submit with declaration checkboxes
- **Success screen** with reference number and next-steps guide
- **Platform brand tokens**: Primary `#04382F`, Accent `#EABC3D`
- **Animated UI**: step transitions, sidebar highlights, payment calculator card

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.10+ |
| State Management | `provider` |
| Theme | Custom `AppTheme` (platform design tokens) |
| Navigation | In-page step navigation (no routing needed) |

---

## Getting Started

```bash
# From the apps/loan_origination_system directory
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
├── main.dart                     # App entry point
├── app.dart                      # Root widget + responsive shell
├── theme/
│   └── app_theme.dart            # Platform design tokens
├── models/
│   └── loan_application.dart     # Data model + ChangeNotifier state
├── widgets/
│   └── common_widgets.dart       # Reusable UI components
└── screens/
    ├── step1_personal_info.dart  # Step 1 — Personal Information
    ├── step2_employment.dart     # Step 2 — Employment Details
    ├── step3_loan_details.dart   # Step 3 — Loan Details
    ├── step4_review_submit.dart  # Step 4 — Review & Submit
    └── success_screen.dart       # Post-submission success screen

test/
└── loan_application_test.dart    # Unit tests for model & state
```

---

## Design System Alignment

All visual tokens are sourced from the Adaptive UI Platform brand spec:

| Token | Value |
|-------|-------|
| `primary` | `#04382F` |
| `primaryLight` | `#0A5445` |
| `primaryDark` | `#021D18` |
| `accent` | `#EABC3D` |
| `background` | `#F4F6F5` |
| `surface` | `#FFFFFF` |
| Spacing scale | 4, 8, 12, 16, 24, 32, 48 px |
| Radius | 4, 8, 12, 20 px |
| Motion | 150ms, 300ms, 500ms |

---

## Screenshots

| Mobile — Step 1 | Wide — Step 3 | Success |
|:---:|:---:|:---:|
| _Personal Info form_ | _Loan Details with EMI estimate_ | _Submission confirmed_ |

---

## Consuming Platform Packages (Future)

Once the platform packages are published, replace the inline theme with:

```yaml
dependencies:
  core_engine:
    git:
      url: git@github.com:jonasreycian/adaptive-ui-platform.git
      path: packages/core_engine
      ref: v0.1.0
  branding_engine:
    git:
      url: git@github.com:jonasreycian/adaptive-ui-platform.git
      path: packages/branding_engine
      ref: v0.1.0
```
