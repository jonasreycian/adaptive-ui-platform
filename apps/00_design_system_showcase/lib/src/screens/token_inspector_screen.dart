import 'package:flutter/material.dart';
import 'package:core_engine/core_engine.dart';

/// A screen that renders all active design tokens.
class TokenInspectorScreen extends StatelessWidget {
  const TokenInspectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = TokenResolver.of(context);
    final colors = tokens.colors;
    final spacing = tokens.spacing;
    final typography = tokens.typography;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        title: const Text('Token Inspector'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          _SectionHeader('Colors', typography, colors),
          _ColorRow('primary', colors.primary, colors, typography),
          _ColorRow('accent', colors.accent, colors, typography),
          _ColorRow('background', colors.background, colors, typography),
          _ColorRow('surface', colors.surface, colors, typography),
          _ColorRow('textPrimary', colors.textPrimary, colors, typography),
          _ColorRow('textSecondary', colors.textSecondary, colors, typography),
          _ColorRow('error', colors.error, colors, typography),
          SizedBox(height: spacing.xl),
          _SectionHeader('Spacing', typography, colors),
          ...[
            ('xs', spacing.xs),
            ('sm', spacing.sm),
            ('md', spacing.md),
            ('lg', spacing.lg),
            ('xl', spacing.xl),
            ('xxl', spacing.xxl),
            ('xxxl', spacing.xxxl),
          ].map((e) => _SpacingRow(e.$1, e.$2, colors, typography, spacing)),
          SizedBox(height: spacing.xl),
          _SectionHeader('Radius', typography, colors),
          ...[
            ('sm', tokens.radius.sm),
            ('md', tokens.radius.md),
            ('lg', tokens.radius.lg),
            ('xl', tokens.radius.xl),
          ].map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.sm),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(e.$2),
                    ),
                  ),
                  SizedBox(width: spacing.md),
                  Text('${e.$1} = ${e.$2}dp',
                      style: typography.bodyMedium
                          .copyWith(color: colors.textPrimary)),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.xl),
          _SectionHeader('Motion', typography, colors),
          ...[
            ('fast', tokens.motion.fast.inMilliseconds),
            ('normal', tokens.motion.normal.inMilliseconds),
            ('slow', tokens.motion.slow.inMilliseconds),
          ].map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              child: Text('${e.$1}: ${e.$2}ms',
                  style:
                      typography.bodyMedium.copyWith(color: colors.textPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title, this.typography, this.colors);

  final String title;
  final TypographyTokens typography;
  final ColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style: typography.headlineSmall.copyWith(color: colors.primary)),
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow(this.name, this.color, this.colors, this.typography);

  final String name;
  final Color color;
  final ColorTokens colors;
  final TypographyTokens typography;

  @override
  Widget build(BuildContext context) {
    final hex =
        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.textSecondary.withAlpha(80)),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: typography.labelMedium
                      .copyWith(color: colors.textPrimary)),
              Text(hex,
                  style: typography.bodySmall
                      .copyWith(color: colors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpacingRow extends StatelessWidget {
  const _SpacingRow(
      this.name, this.value, this.colors, this.typography, this.spacing);

  final String name;
  final double value;
  final ColorTokens colors;
  final TypographyTokens typography;
  final SpacingTokens spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Row(
        children: [
          Container(
            width: value,
            height: 24,
            color: colors.accent,
          ),
          SizedBox(width: spacing.md),
          Text('$name = ${value}dp',
              style:
                  typography.bodyMedium.copyWith(color: colors.textPrimary)),
        ],
      ),
    );
  }
}
