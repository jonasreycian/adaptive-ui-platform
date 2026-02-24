import 'package:args/args.dart';

import '../page_registry_io.dart';

/// Implements the `ckgroup-core add` sub-command.
///
/// Usage:
/// ```
/// ckgroup-core add --page=Loans --roles=Admin,LoanSupervisor,Creditor
/// ckgroup-core add --page=Reports --roles=Admin --icon=bar_chart --route=/reports
/// ckgroup-core add --page=Settings --roles=Admin --output=assets/page_registry.json
/// ```
class AddCommand {
  static const String name = 'add';
  static const String description =
      'Register a new sidebar page with role-based access.';

  /// Builds the [ArgParser] for the `add` sub-command.
  static ArgParser buildParser() {
    return ArgParser()
      ..addOption(
        'page',
        abbr: 'p',
        mandatory: true,
        help: 'Display name of the page (e.g. "Loans").',
      )
      ..addOption(
        'roles',
        abbr: 'r',
        mandatory: true,
        help: 'Comma-separated role names that may access this page '
            '(e.g. "Admin,LoanSupervisor,Creditor").',
      )
      ..addOption(
        'route',
        help: 'Navigation route path. '
            'Defaults to "/<lowercase-page-name>" (e.g. "/loans").',
      )
      ..addOption(
        'icon',
        help: 'Material icon name for the sidebar entry (e.g. "description").',
      )
      ..addOption(
        'output',
        abbr: 'o',
        defaultsTo: 'page_registry.json',
        help: 'Path to the page_registry.json file.',
      );
  }

  // ── Run ──────────────────────────────────────────────────────────────────────

  /// Executes the `add` command with [results].
  ///
  /// Returns `0` on success, `1` on validation error.
  static int run(ArgResults results, {void Function(String)? output}) {
    final out = output ?? stdout;

    final pageName = results['page'] as String;
    final rolesRaw = results['roles'] as String;
    final outputPath = results['output'] as String;
    final iconName = results['icon'] as String?;
    final routeOverride = results['route'] as String?;

    // ── Validate page name ────────────────────────────────────────────────────
    if (pageName.trim().isEmpty) {
      out('Error: --page must not be empty.');
      return 1;
    }

    // ── Parse roles ───────────────────────────────────────────────────────────
    final roles = rolesRaw
        .split(',')
        .map((r) => r.trim())
        .where((r) => r.isNotEmpty)
        .toList();

    if (roles.isEmpty) {
      out('Error: --roles must contain at least one role name.');
      return 1;
    }

    // ── Derive route ──────────────────────────────────────────────────────────
    final route =
        routeOverride?.trim().isNotEmpty == true
            ? routeOverride!
            : '/${pageName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';

    // ── Mutate registry ───────────────────────────────────────────────────────
    final io = PageRegistryIo(registryPath: outputPath);
    final current = io.read();

    Map<String, dynamic> updated;
    try {
      updated = PageRegistryIo.addPage(
        current,
        pageName: pageName.trim(),
        route: route,
        roles: roles,
        iconName: iconName?.trim().isNotEmpty == true ? iconName!.trim() : null,
      );
    } on ArgumentError catch (e) {
      out('Error: ${e.message}');
      return 1;
    }

    io.write(updated);

    out('✅  Page "${pageName.trim()}" added to $outputPath');
    out('   route : $route');
    out('   roles : ${roles.join(', ')}');
    if (iconName != null) out('   icon  : $iconName');

    return 0;
  }
}

// ignore: avoid_print
void stdout(String msg) => print(msg);
