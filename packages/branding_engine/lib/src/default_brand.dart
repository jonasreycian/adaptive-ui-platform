import 'package:core_engine/core_engine.dart';
import 'brand_config.dart';
import 'layout_config.dart';

/// The built-in default brand used when no custom brand is active.
const BrandConfig defaultBrand = BrandConfig(
  brandId: 'internal_default',
  displayName: 'Default',
  lightTokens: ColorTokens.light,
  darkTokens: ColorTokens.dark,
  layoutConfig: LayoutConfig(),
  featureFlags: {},
);
