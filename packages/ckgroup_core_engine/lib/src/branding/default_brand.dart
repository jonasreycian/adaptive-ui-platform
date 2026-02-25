import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

/// The built-in default brand used when no custom brand is active.
const BrandConfig defaultBrand = BrandConfig(
  brandId: 'internal_default',
  displayName: 'Default',
  lightTokens: ColorTokens.light,
  darkTokens: ColorTokens.dark,
  layoutConfig: LayoutConfig(),
  featureFlags: {},
);
