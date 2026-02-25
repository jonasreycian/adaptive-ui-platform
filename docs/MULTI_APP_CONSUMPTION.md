# Multi-App Consumption Guide

This guide explains how a host application consumes the `adaptive-ui-platform` packages via Git.

---

## Option A — Git Dependency (recommended for private monorepos)

Add the packages to your app's `pubspec.yaml`:

```yaml
dependencies:
  ckgroup_core_engine:
    git:
      url: https://github.com/your-org/adaptive-ui-platform.git
      path: packages/ckgroup_core_engine
      ref: main   # pin to a tag or SHA in production
```

Then run:

```bash
flutter pub get
```

---

## Option B — Path Dependency (local development / monorepo sibling)

If your host app lives in the same repository or a sibling directory:

```yaml
dependencies:
  ckgroup_core_engine:
    path: ../adaptive-ui-platform/packages/ckgroup_core_engine
```

---

## Wiring Up in Your App

### 1. Register your brand at startup

```dart
// lib/main.dart
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

void main() {
  BrandRegistry.instance.register(
    const BrandConfig(
      brandId: 'my_app',
      displayName: 'My App',
      lightTokens: ColorTokens.light,   // or your custom tokens
      darkTokens: ColorTokens.dark,
    ),
  );
  runApp(const MyApp());
}
```

### 2. Wrap your widget tree

```dart
// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _themeController = ThemeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        final brand = BrandRegistry.instance.find('my_app')!;
        final colors = brand.resolveColors(isDark: _themeController.isDark);

        return BrandResolver(
          brand: brand,
          child: TokenResolver(
            colors: colors,
            spacing: SpacingTokens.instance,
            typography: TypographyTokens.instance,
            radius: RadiusTokens.instance,
            elevation: ElevationTokens.instance,
            motion: MotionTokens.instance,
            child: MaterialApp(
              // ...
            ),
          ),
        );
      },
    );
  }
}
```

### 3. Consume tokens in your widgets

```dart
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'package:flutter/widgets.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);

    return Container(
      padding: EdgeInsets.all(tokens.spacing.lg),
      decoration: BoxDecoration(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.radius.md),
      ),
      child: Text(
        'Hello',
        style: tokens.typography.bodyLarge
            .copyWith(color: tokens.colors.textPrimary),
      ),
    );
  }
}
```

---

## Registering a Plugin Module

```dart
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'package:flutter/widgets.dart';

class AnalyticsModule extends AdaptiveModule {
  const AnalyticsModule();

  @override
  String get moduleId => 'analytics';

  @override
  String get displayName => 'Analytics';

  @override
  List<UserRole> get allowedRoles => [UserRole.admin, UserRole.user];

  @override
  Widget buildContent(BuildContext context) => const AnalyticsView();

  @override
  Widget? buildIcon(BuildContext context) =>
      const Icon(Icons.bar_chart_outlined);
}

// In main():
ModuleRegistry.instance.register(const AnalyticsModule());
```

---

## Pinning to a Specific Version

For production stability, pin to a Git tag:

```yaml
  ckgroup_core_engine:
    git:
      url: https://github.com/your-org/adaptive-ui-platform.git
      path: packages/ckgroup_core_engine
      ref: v0.1.0
```

See [CHANGELOG.md](../CHANGELOG.md) for available versions.
