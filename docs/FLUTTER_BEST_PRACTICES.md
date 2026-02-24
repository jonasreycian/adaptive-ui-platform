# Flutter Best Practices

## Adaptive UI Platform

This document captures Flutter-specific best practices that **all packages and demo apps** in this monorepo must follow.

---

## 1. Dart / Flutter Fundamentals

### Null safety

- Use sound null safety everywhere (`sdk: '>=3.0.0 <4.0.0'`).
- Prefer non-nullable types; use `?` only when `null` is a meaningful state.
- Avoid the `!` bang operator; handle `null` explicitly.

```dart
// ✅ Correct
final String? name = user.displayName;
final label = name ?? 'Anonymous';

// ❌ Avoid
final label = user.displayName!;
```

### `const` constructors

- Use `const` wherever the object is compile-time constant.
- Annotate immutable value classes with `@immutable`.

```dart
// ✅ Correct
@immutable
class SpacingTokens {
  const SpacingTokens();
  final double lg = 16.0;
}

// Widget usage
const SizedBox(height: 16)
```

---

## 2. Widget Guidelines

### Keep widgets small and focused

Split widgets by responsibility. A widget that exceeds ~100 lines is usually doing too much.

```
// ✅ Separate concerns
LoanFormScreen
  └─ StepIndicator
  └─ PersonalInfoStep
  └─ NavigationButtons
```

### Prefer `StatelessWidget`

Only use `StatefulWidget` when you need local lifecycle state. Move business logic to a ViewModel or ChangeNotifier.

### Use `const` widget trees

Flutter can skip rebuild for `const` subtrees, improving performance.

```dart
// ✅ const subtree
return const Column(
  children: [
    Icon(Icons.home),
    Text('Home'),
  ],
);
```

### Keys

- Use `Key` only when Flutter needs help identifying widgets in a list or when writing widget tests.
- Use `ValueKey` or `ObjectKey` instead of `UniqueKey` when the key carries semantic meaning.

---

## 3. Token-Driven Design

No raw visual constants outside token definition files.

| ✅ Allowed | ❌ Forbidden |
|---|---|
| `tokens.spacing.lg` | `16.0` |
| `tokens.radius.md` | `BorderRadius.circular(8)` |
| `tokens.colors.primary` | `Color(0xFF04382F)` |
| `tokens.motion.normal` | `Duration(milliseconds: 300)` |

Always resolve tokens via `TokenResolver.of(context)`:

```dart
@override
Widget build(BuildContext context) {
  final tokens = TokenResolver.of(context);
  return Container(
    padding: EdgeInsets.all(tokens.spacing.lg),
    color: tokens.colors.surface,
  );
}
```

---

## 4. Performance

### `ListView.builder` over `ListView`

Use the lazy builder when the item count is large or unknown.

```dart
// ✅ Lazy builder
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)
```

### Avoid rebuilds

- Wrap expensive subtrees in `RepaintBoundary` if they update independently.
- Use `AnimatedBuilder` rather than calling `setState` for animations.
- Provide stable keys to animated list items.

### Image caching

- Use `cached_network_image` for remote images.
- Specify `cacheWidth` / `cacheHeight` for `Image.asset` to reduce memory.

---

## 5. Folder Structure (per package)

```
<package>/
├── lib/
│   ├── <package>.dart          # Barrel export file
│   └── src/
│       ├── <domain>/           # Feature folder (tokens/, components/, …)
│       │   ├── <class>.dart
│       │   └── …
│       └── …
├── test/
│   ├── helpers/                # Shared test helpers
│   │   └── test_harness.dart
│   └── <class>_test.dart
├── analysis_options.yaml
└── pubspec.yaml
```

Barrel export rule: `lib/<package>.dart` re-exports **only** the public API. Internal `src/` classes are not exported.

---

## 6. Accessibility

- Wrap interactive custom widgets in `Semantics`.
- Provide `tooltip` on `IconButton`.
- Ensure text contrast meets WCAG AA (4.5:1 for normal text, 3:1 for large text).
- Test with TalkBack (Android) and VoiceOver (iOS) before shipping.

```dart
// ✅ Accessible icon button
IconButton(
  tooltip: 'Toggle dark mode',
  icon: const Icon(Icons.brightness_6),
  onPressed: controller.toggleDark,
)
```

---

## 7. Error Handling

- Never swallow exceptions silently (`catch (e) {}`).
- Surfaces errors to the user with an `AdaptiveDialog` or `SnackBar`.
- Log errors via a structured logger (not `print()`).

```dart
// ✅ Handled gracefully
try {
  await repository.submit(application);
} on NetworkException catch (e) {
  _showError(context, e.message);
} catch (e, stackTrace) {
  logger.error('Unexpected error', e, stackTrace);
  _showError(context, 'Something went wrong. Please try again.');
}
```

---

## 8. Dependency Management

- Pin dependencies with `^` (caret syntax) in `pubspec.yaml`.
- Run `flutter pub upgrade --major-versions` only after reviewing changelogs.
- Do not add transitive dependencies directly; let packages manage their own deps.
- Review licences for new dependencies before adding them.

---

## 9. CI Checks

Every package enforces these rules automatically via `flutter analyze` with `analysis_options.yaml`:

```yaml
# analysis_options.yaml (package-level)
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_use_package_imports
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - sort_pub_dependencies
```

Run locally before pushing:

```bash
melos analyze
melos test
```
