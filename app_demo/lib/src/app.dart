import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';
import 'screens/home_screen.dart';

/// Root widget for the design-system showcase application.
class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  final ThemeController _themeController = ThemeController();

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _themeController,
      builder: (context, _) {
        final colors = _themeController.colors;

        return BrandResolver(
          brand:
              BrandRegistry.instance.find('internal_default') ?? defaultBrand,
          child: TokenResolver(
            colors: colors,
            spacing: SpacingTokens.instance,
            typography: TypographyTokens.instance,
            radius: RadiusTokens.instance,
            elevation: ElevationTokens.instance,
            motion: MotionTokens.instance,
            child: MaterialApp(
              title: 'Adaptive UI Showcase',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: colors.primary,
                  onPrimary: colors.onPrimary,
                  secondary: colors.accent,
                  onSecondary: colors.onAccent,
                  error: colors.error,
                  onError: colors.surface,
                  surface: colors.surface,
                  onSurface: colors.textPrimary,
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme(
                  brightness: Brightness.dark,
                  primary: ColorTokens.dark.primary,
                  onPrimary: ColorTokens.dark.onPrimary,
                  secondary: ColorTokens.dark.accent,
                  onSecondary: ColorTokens.dark.onAccent,
                  error: ColorTokens.dark.error,
                  onError: ColorTokens.dark.surface,
                  surface: ColorTokens.dark.surface,
                  onSurface: ColorTokens.dark.textPrimary,
                ),
              ),
              themeMode:
                  _themeController.isDark ? ThemeMode.dark : ThemeMode.light,
              home: HomeScreen(themeController: _themeController),
            ),
          ),
        );
      },
    );
  }
}
