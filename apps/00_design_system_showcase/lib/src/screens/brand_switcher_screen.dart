import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';
import 'package:branding_engine/branding_engine.dart';
import 'package:adaptive_components/adaptive_components.dart';

/// Demonstrates runtime brand switching.
class BrandSwitcherScreen extends StatefulWidget {
  const BrandSwitcherScreen({super.key});

  @override
  State<BrandSwitcherScreen> createState() => _BrandSwitcherScreenState();
}

class _BrandSwitcherScreenState extends State<BrandSwitcherScreen> {
  late BrandConfig _activeBrand;

  // A secondary brand for demonstration purposes.
  static const BrandConfig _demoBrand = BrandConfig(
    brandId: 'demo_brand',
    displayName: 'Demo Brand',
    lightTokens: ColorTokens(
      primary: Color(0xFF1A237E),
      accent: Color(0xFFFFC107),
      background: Color(0xFFF5F5F5),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF1A237E),
      textSecondary: Color(0xFF5C6BC0),
      error: Color(0xFFB00020),
      onPrimary: Color(0xFFFFFFFF),
      onAccent: Color(0xFF1A237E),
    ),
    darkTokens: ColorTokens(
      primary: Color(0xFFFFC107),
      accent: Color(0xFF1A237E),
      background: Color(0xFF0D0D1A),
      surface: Color(0xFF1A1A2E),
      textPrimary: Color(0xFFFFFFFF),
      textSecondary: Color(0xFF9FA8DA),
      error: Color(0xFFCF6679),
      onPrimary: Color(0xFF1A237E),
      onAccent: Color(0xFFFFC107),
    ),
  );

  @override
  void initState() {
    super.initState();
    _activeBrand =
        BrandRegistry.instance.find('internal_default') ?? defaultBrand;
    // Register demo brand if not already registered.
    if (!BrandRegistry.instance.contains('demo_brand')) {
      BrandRegistry.instance.register(_demoBrand);
    }
  }

  void _switchTo(BrandConfig brand) {
    setState(() => _activeBrand = brand);
  }

  @override
  Widget build(BuildContext context) {
    final baseTokens = TokenResolver.of(context);
    final spacing = baseTokens.spacing;
    final typography = baseTokens.typography;
    final isDark = baseTokens.colors == ColorTokens.dark;
    final activeColors = _activeBrand.resolveColors(isDark: isDark);

    return BrandResolver(
      brand: _activeBrand,
      child: TokenResolver(
        colors: activeColors,
        spacing: spacing,
        typography: typography,
        radius: baseTokens.radius,
        elevation: baseTokens.elevation,
        motion: baseTokens.motion,
        child: Builder(builder: (context) {
          final colors = TokenResolver.of(context).colors;

          return Scaffold(
            backgroundColor: colors.background,
            appBar: AppBar(
              backgroundColor: colors.surface,
              foregroundColor: colors.textPrimary,
              title: Text('Brand Switcher', style: typography.titleLarge),
              elevation: 0,
            ),
            body: ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                Text('Active Brand: ${_activeBrand.displayName}',
                    style: typography.headlineSmall
                        .copyWith(color: colors.textPrimary)),
                SizedBox(height: spacing.lg),

                // Color preview
                Container(
                  padding: EdgeInsets.all(spacing.lg),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(baseTokens.radius.lg),
                  ),
                  child: Text(
                    'Primary color preview',
                    style: typography.bodyLarge
                        .copyWith(color: colors.onPrimary),
                  ),
                ),
                SizedBox(height: spacing.md),
                Container(
                  padding: EdgeInsets.all(spacing.lg),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(baseTokens.radius.lg),
                  ),
                  child: Text(
                    'Accent color preview',
                    style: typography.bodyLarge
                        .copyWith(color: colors.onAccent),
                  ),
                ),
                SizedBox(height: spacing.xl),

                // Brand buttons
                Text('Switch Brand',
                    style: typography.titleMedium
                        .copyWith(color: colors.textPrimary)),
                SizedBox(height: spacing.md),
                AdaptiveButton(
                  label: 'Default Brand',
                  onPressed: () => _switchTo(
                    BrandRegistry.instance.find('internal_default') ??
                        defaultBrand,
                  ),
                  variant: _activeBrand.brandId == 'internal_default'
                      ? AdaptiveButtonVariant.primary
                      : AdaptiveButtonVariant.outlined,
                ),
                SizedBox(height: spacing.md),
                AdaptiveButton(
                  label: 'Demo Brand',
                  onPressed: () => _switchTo(_demoBrand),
                  variant: _activeBrand.brandId == 'demo_brand'
                      ? AdaptiveButtonVariant.primary
                      : AdaptiveButtonVariant.outlined,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
