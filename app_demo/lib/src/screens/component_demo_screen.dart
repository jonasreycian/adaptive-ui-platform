import 'package:flutter/material.dart';
import 'package:ckgroup_core_engine/ckgroup_core_engine.dart';

/// Demonstrates all adaptive UI components.
class ComponentDemoScreen extends StatefulWidget {
  const ComponentDemoScreen({super.key});

  @override
  State<ComponentDemoScreen> createState() => _ComponentDemoScreenState();
}

class _ComponentDemoScreenState extends State<ComponentDemoScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
        title: const Text('Components'),
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          // ── Buttons ─────────────────────────────────────────────────────────
          Text('Buttons',
              style:
                  typography.headlineSmall.copyWith(color: colors.textPrimary)),
          SizedBox(height: spacing.md),
          Wrap(
            spacing: spacing.md,
            runSpacing: spacing.md,
            children: [
              AdaptiveButton(
                  label: 'Primary',
                  onPressed: () {},
                  variant: AdaptiveButtonVariant.primary),
              AdaptiveButton(
                  label: 'Secondary',
                  onPressed: () {},
                  variant: AdaptiveButtonVariant.secondary),
              AdaptiveButton(
                  label: 'Outlined',
                  onPressed: () {},
                  variant: AdaptiveButtonVariant.outlined),
              AdaptiveButton(
                  label: 'Ghost',
                  onPressed: () {},
                  variant: AdaptiveButtonVariant.ghost),
              const AdaptiveButton(
                  label: 'Loading', onPressed: null, isLoading: true),
              const AdaptiveButton(label: 'Disabled', onPressed: null),
            ],
          ),
          SizedBox(height: spacing.xl),

          // ── Text Fields ──────────────────────────────────────────────────────
          Text('Text Fields',
              style:
                  typography.headlineSmall.copyWith(color: colors.textPrimary)),
          SizedBox(height: spacing.md),
          AdaptiveTextField(
            controller: _textController,
            label: 'Full name',
            hint: 'Enter your name',
          ),
          SizedBox(height: spacing.md),
          const AdaptiveTextField(
            label: 'Password',
            hint: 'Enter password',
            obscureText: true,
          ),
          SizedBox(height: spacing.md),
          const AdaptiveTextField(
            label: 'Error state',
            hint: 'This field has an error',
            errorText: 'This field is required',
          ),
          SizedBox(height: spacing.xl),

          // ── Dialog ───────────────────────────────────────────────────────────
          Text('Dialog',
              style:
                  typography.headlineSmall.copyWith(color: colors.textPrimary)),
          SizedBox(height: spacing.md),
          AdaptiveButton(
            label: 'Show Dialog',
            onPressed: () => AdaptiveDialog.show<void>(
              context: context,
              title: 'Confirm Action',
              content: Text(
                'Are you sure you want to proceed?',
                style:
                    typography.bodyMedium.copyWith(color: colors.textSecondary),
              ),
              actions: [
                AdaptiveButton(
                  label: 'Cancel',
                  variant: AdaptiveButtonVariant.ghost,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                AdaptiveButton(
                  label: 'Confirm',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
