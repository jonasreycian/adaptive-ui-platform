/// CKGroup Core Engine — unified core for the Adaptive UI Platform.
///
/// Includes design tokens, theming, branding, adaptive components,
/// dashboard framework, and plugin/module system.
library ckgroup_core_engine;

// ── Tokens ──────────────────────────────────────────────────────────────────
export 'src/tokens/color_tokens.dart';
export 'src/tokens/spacing_tokens.dart';
export 'src/tokens/typography_tokens.dart';
export 'src/tokens/radius_tokens.dart';
export 'src/tokens/elevation_tokens.dart';
export 'src/tokens/motion_tokens.dart';
export 'src/tokens/breakpoints.dart';
export 'src/tokens/adaptive_token_set.dart';

// ── Theme ───────────────────────────────────────────────────────────────────
export 'src/theme/token_resolver.dart';
export 'src/theme/theme_controller.dart';

// ── Branding ────────────────────────────────────────────────────────────────
export 'src/branding/brand_config.dart';
export 'src/branding/layout_config.dart';
export 'src/branding/brand_registry.dart';
export 'src/branding/brand_resolver.dart';
export 'src/branding/default_brand.dart';

// ── Platform ────────────────────────────────────────────────────────────────
export 'src/platform/adaptive_platform.dart';
export 'src/platform/adaptive_render.dart';

// ── Components ──────────────────────────────────────────────────────────────
export 'src/components/adaptive_button.dart';
export 'src/components/adaptive_text_field.dart';
export 'src/components/adaptive_dialog.dart';
export 'src/components/adaptive_scaffold.dart';
export 'src/components/adaptive_navigation_bar.dart';
export 'src/components/adaptive_table.dart';
export 'src/components/adaptive_step_indicator.dart';
export 'src/components/adaptive_info_chip.dart';

// ── Layout ──────────────────────────────────────────────────────────────────
export 'src/layout/adaptive_layout.dart';
export 'src/layout/responsive_builder.dart';

// ── Shell ───────────────────────────────────────────────────────────────────
export 'src/shell/dashboard_shell.dart';

// ── Grid ────────────────────────────────────────────────────────────────────
export 'src/grid/dashboard_grid.dart';

// ── Roles ───────────────────────────────────────────────────────────────────
export 'src/roles/user_role.dart';
export 'src/roles/dashboard_preset.dart';
export 'src/roles/preset_registry.dart';

// ── Plugins ─────────────────────────────────────────────────────────────────
export 'src/plugins/adaptive_module.dart';
export 'src/plugins/module_registry.dart';

// ── Registry ────────────────────────────────────────────────────────────────
export 'src/registry/page_entry.dart';
export 'src/registry/dynamic_page_module.dart';
export 'src/registry/page_registry_service.dart';
