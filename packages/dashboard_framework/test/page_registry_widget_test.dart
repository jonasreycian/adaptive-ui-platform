import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_engine/core_engine.dart';
import 'package:branding_engine/branding_engine.dart';
import 'package:dashboard_framework/dashboard_framework.dart';

// ── Test helpers ─────────────────────────────────────────────────────────────

/// Wraps [child] in the full token + brand context that production widgets
/// expect, mirroring the existing test helper pattern.
Widget _buildUnderTest({required Widget child, double width = 800}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, 900)),
      child: TokenResolver(
        colors: ColorTokens.light,
        spacing: SpacingTokens.instance,
        typography: TypographyTokens.instance,
        radius: RadiusTokens.instance,
        elevation: ElevationTokens.instance,
        motion: MotionTokens.instance,
        child: BrandResolver(
          brand: defaultBrand,
          child: Scaffold(body: child),
        ),
      ),
    ),
  );
}

// Minimal JSON with one "Loans" page accessible to Admin, LoanSupervisor, Creditor.
const String _loansJson = '''
{
  "version": "1",
  "pages": [
    {
      "pageName": "Loans",
      "route": "/loans",
      "roles": ["Admin", "LoanSupervisor", "Creditor"],
      "iconName": "loans"
    }
  ]
}
''';

// JSON with multiple pages covering various role combinations.
const String _multiPageJson = '''
{
  "version": "1",
  "pages": [
    {
      "pageName": "Dashboard",
      "route": "/dashboard",
      "roles": ["Admin", "Viewer"],
      "iconName": "dashboard"
    },
    {
      "pageName": "Loans",
      "route": "/loans",
      "roles": ["Admin", "LoanSupervisor", "Creditor"],
      "iconName": "loans"
    },
    {
      "pageName": "Reports",
      "route": "/reports",
      "roles": ["Admin"],
      "iconName": "reports"
    }
  ]
}
''';

// ── PageEntry unit tests ─────────────────────────────────────────────────────

void main() {
  group('PageEntry', () {
    test('fromJson parses all fields', () {
      final entry = PageEntry.fromJson({
        'pageName': 'Loans',
        'route': '/loans',
        'roles': ['Admin', 'LoanSupervisor', 'Creditor'],
        'iconName': 'description',
      });

      expect(entry.pageName, 'Loans');
      expect(entry.route, '/loans');
      expect(entry.roles, ['Admin', 'LoanSupervisor', 'Creditor']);
      expect(entry.iconName, 'description');
    });

    test('fromJson works without optional iconName', () {
      final entry = PageEntry.fromJson({
        'pageName': 'Reports',
        'route': '/reports',
        'roles': ['Admin'],
      });

      expect(entry.iconName, isNull);
    });

    test('toJson round-trips all fields', () {
      const entry = PageEntry(
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin', 'LoanSupervisor'],
        iconName: 'description',
      );
      final map = entry.toJson();

      expect(map['pageName'], 'Loans');
      expect(map['route'], '/loans');
      expect(map['roles'], ['Admin', 'LoanSupervisor']);
      expect(map['iconName'], 'description');
    });

    test('toJson omits iconName when null', () {
      const entry = PageEntry(
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin'],
      );
      expect(entry.toJson().containsKey('iconName'), isFalse);
    });

    test('equality is based on pageName + route', () {
      const a = PageEntry(pageName: 'Loans', route: '/loans', roles: ['Admin']);
      const b = PageEntry(
        pageName: 'Loans',
        route: '/loans',
        roles: ['Viewer'],
        iconName: 'description',
      );
      expect(a, equals(b));
    });

    test('inequality when route differs', () {
      const a = PageEntry(pageName: 'Loans', route: '/loans', roles: ['Admin']);
      const b =
          PageEntry(pageName: 'Loans', route: '/other', roles: ['Admin']);
      expect(a, isNot(equals(b)));
    });
  });

  // ── PageRegistryService unit tests ──────────────────────────────────────────

  group('PageRegistryService.parseEntries', () {
    test('parses a single entry', () {
      final entries = PageRegistryService.parseEntries(_loansJson);

      expect(entries, hasLength(1));
      expect(entries.first.pageName, 'Loans');
      expect(entries.first.route, '/loans');
      expect(entries.first.roles, containsAll(['Admin', 'LoanSupervisor', 'Creditor']));
    });

    test('parses multiple entries', () {
      final entries = PageRegistryService.parseEntries(_multiPageJson);
      expect(entries, hasLength(3));
    });

    test('returns empty list when pages key is absent', () {
      const json = '{"version":"1"}';
      expect(PageRegistryService.parseEntries(json), isEmpty);
    });

    test('returns empty list when pages array is empty', () {
      const json = '{"version":"1","pages":[]}';
      expect(PageRegistryService.parseEntries(json), isEmpty);
    });

    test('throws FormatException for invalid JSON', () {
      expect(
        () => PageRegistryService.parseEntries('not json'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('PageRegistryService.toJsonString', () {
    test('produces valid JSON with correct structure', () {
      const entry = PageEntry(
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin'],
      );
      final json = PageRegistryService.toJsonString([entry]);
      final parsed = PageRegistryService.parseEntries(json);

      expect(parsed, hasLength(1));
      expect(parsed.first.pageName, 'Loans');
    });
  });

  // ── PageRegistryService.loadFromJsonString ───────────────────────────────────

  group('PageRegistryService.loadFromJsonString', () {
    late ModuleRegistry registry;

    setUp(() {
      registry = ModuleRegistry.instance..clear();
    });

    tearDown(() => registry.clear());

    test('registers DynamicPageModule for each page entry', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      expect(registry.modules, hasLength(1));
      expect(registry.modules.containsKey('/loans'), isTrue);
    });

    test('registered module is a DynamicPageModule', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      final module = registry.find('/loans');
      expect(module, isA<DynamicPageModule>());
    });

    test('module displayName matches pageName', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      expect(registry.find('/loans')!.displayName, 'Loans');
    });

    test('registers all pages from multi-page JSON', () {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);

      expect(registry.modules.keys,
          containsAll(['/dashboard', '/loans', '/reports']));
    });

    test('is idempotent — duplicate load does not throw', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      expect(
        () => PageRegistryService.loadFromJsonString(_loansJson,
            registry: registry),
        returnsNormally,
      );
      expect(registry.modules, hasLength(1));
    });

    test('does nothing for empty pages array', () {
      const json = '{"version":"1","pages":[]}';
      PageRegistryService.loadFromJsonString(json, registry: registry);

      expect(registry.modules, isEmpty);
    });
  });

  // ── DynamicPageModule unit tests ─────────────────────────────────────────────

  group('DynamicPageModule', () {
    const loansEntry = PageEntry(
      pageName: 'Loans',
      route: '/loans',
      roles: ['Admin', 'LoanSupervisor', 'Creditor'],
      iconName: 'loans',
    );
    const module = DynamicPageModule(entry: loansEntry);

    test('moduleId equals route', () {
      expect(module.moduleId, '/loans');
    });

    test('displayName equals pageName', () {
      expect(module.displayName, 'Loans');
    });

    test('allowedRoles is empty (string-based routing)', () {
      expect(module.allowedRoles, isEmpty);
    });

    test('allowedRoleNames are lowercased', () {
      expect(
        module.allowedRoleNames,
        containsAll(['admin', 'loansupervisor', 'creditor']),
      );
    });

    test('allowedRoleNames match case-insensitively for "Admin"', () {
      expect(module.allowedRoleNames.contains('admin'), isTrue);
    });

    test('entry is accessible on the module', () {
      expect(module.entry, same(loansEntry));
    });
  });

  // ── DynamicPageModule widget tests ───────────────────────────────────────────

  group('DynamicPageModule widget', () {
    testWidgets('buildContent renders page name as headline', (tester) async {
      const entry = PageEntry(
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin'],
      );
      const module = DynamicPageModule(entry: entry);

      await tester.pumpWidget(
        _buildUnderTest(
          child: Builder(builder: (ctx) => module.buildContent(ctx)),
        ),
      );

      expect(find.text('Loans'), findsOneWidget);
    });

    testWidgets('buildContent shows "Dynamically registered page" subtitle',
        (tester) async {
      const entry =
          PageEntry(pageName: 'Reports', route: '/reports', roles: ['Admin']);
      const module = DynamicPageModule(entry: entry);

      await tester.pumpWidget(
        _buildUnderTest(
          child: Builder(
            builder: (ctx) => module.buildContent(ctx),
          ),
        ),
      );

      expect(find.text('Dynamically registered page'), findsOneWidget);
    });

    testWidgets('buildContent is centred and contains an icon', (tester) async {
      const entry =
          PageEntry(pageName: 'Settings', route: '/settings', roles: ['Admin']);
      const module = DynamicPageModule(entry: entry);

      await tester.pumpWidget(
        _buildUnderTest(
          child: Builder(builder: (ctx) => module.buildContent(ctx)),
        ),
      );

      expect(find.byType(Icon), findsAtLeastNWidgets(1));
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('buildIcon returns a non-null widget', (tester) async {
      const entry =
          PageEntry(pageName: 'Dashboard', route: '/dashboard', roles: ['Admin']);
      const module = DynamicPageModule(entry: entry);

      await tester.pumpWidget(
        _buildUnderTest(
          child: Builder(
            builder: (ctx) {
              final icon = module.buildIcon(ctx);
              return icon ?? const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('buildIcon renders for unknown icon name', (tester) async {
      const entry = PageEntry(
        pageName: 'Custom',
        route: '/custom',
        roles: ['Admin'],
        iconName: 'unknowniconxyz',
      );
      const module = DynamicPageModule(entry: entry);

      await tester.pumpWidget(
        _buildUnderTest(
          child: Builder(
            builder: (ctx) => module.buildIcon(ctx) ?? const SizedBox.shrink(),
          ),
        ),
      );

      // Falls back to the default icon — still renders an Icon widget.
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('buildIcon renders for null icon name', (tester) async {
      const entry =
          PageEntry(pageName: 'NoIcon', route: '/no-icon', roles: ['Admin']);
      const module = DynamicPageModule(entry: entry);

      await tester.pumpWidget(
        _buildUnderTest(
          child: Builder(
            builder: (ctx) => module.buildIcon(ctx) ?? const SizedBox.shrink(),
          ),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
    });
  });

  // ── ModuleRegistry.forRoleNames widget-adjacent tests ────────────────────────

  group('ModuleRegistry.forRoleNames', () {
    late ModuleRegistry registry;

    setUp(() {
      registry = ModuleRegistry.instance..clear();
    });

    tearDown(() => registry.clear());

    test('returns dynamic module for matching custom role', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      final modules = registry.forRoleNames(['LoanSupervisor']);
      expect(modules, hasLength(1));
      expect(modules.first.moduleId, '/loans');
    });

    test('role matching is case-insensitive', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      expect(registry.forRoleNames(['admin']), hasLength(1));
      expect(registry.forRoleNames(['ADMIN']), hasLength(1));
      expect(registry.forRoleNames(['Admin']), hasLength(1));
    });

    test('returns empty list when no roles match', () {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      expect(registry.forRoleNames(['Viewer']), isEmpty);
    });

    test('returns correct subset for multi-page registry', () {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);

      // Viewer can only see Dashboard.
      final viewerModules = registry.forRoleNames(['Viewer']);
      expect(viewerModules.map((m) => m.moduleId), contains('/dashboard'));
      expect(viewerModules.map((m) => m.moduleId),
          isNot(contains('/loans')));
      expect(viewerModules.map((m) => m.moduleId),
          isNot(contains('/reports')));
    });

    test('Admin sees all pages', () {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);

      final adminModules = registry.forRoleNames(['Admin']);
      expect(adminModules, hasLength(3));
    });

    test('LoanSupervisor sees only Loans', () {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);

      final modules = registry.forRoleNames(['LoanSupervisor']);
      expect(modules.map((m) => m.moduleId), ['/loans']);
    });

    test('Creditor sees only Loans', () {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);

      final modules = registry.forRoleNames(['Creditor']);
      expect(modules.map((m) => m.moduleId), ['/loans']);
    });

    test('forRoleNames with multiple roles returns union', () {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);

      // Viewer + Creditor = Dashboard + Loans
      final modules = registry.forRoleNames(['Viewer', 'Creditor']);
      final ids = modules.map((m) => m.moduleId).toList();
      expect(ids, containsAll(['/dashboard', '/loans']));
      expect(ids, isNot(contains('/reports')));
    });

    test('built-in UserRole enum module also matched by forRoleNames', () {
      // Register a classic enum-based module.
      registry.register(_EnumModule('admin_only', UserRole.admin));

      // forRoleNames('admin') should find it via allowedRoleNames default impl.
      final modules = registry.forRoleNames(['admin']);
      expect(modules.map((m) => m.moduleId), contains('admin_only'));
    });

    test('forRoleNames does not return built-in module for wrong role', () {
      registry.register(_EnumModule('admin_only', UserRole.admin));

      expect(registry.forRoleNames(['viewer']), isEmpty);
    });

    test('mixed registry — dynamic + enum — filtered correctly', () {
      // Built-in module visible to admin only.
      registry.register(_EnumModule('admin_panel', UserRole.admin));

      // Dynamic module visible to LoanSupervisor and Admin.
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);

      final lsModules = registry.forRoleNames(['LoanSupervisor']);
      expect(lsModules.map((m) => m.moduleId), contains('/loans'));
      expect(lsModules.map((m) => m.moduleId),
          isNot(contains('admin_panel')));

      final adminModules = registry.forRoleNames(['admin']);
      expect(adminModules.map((m) => m.moduleId),
          containsAll(['admin_panel', '/loans']));
    });
  });

  // ── Integration: DynamicPageModule rendered inside DashboardShell ────────────

  group('DashboardShell with dynamic pages', () {
    late ModuleRegistry registry;

    setUp(() {
      registry = ModuleRegistry.instance..clear();
    });

    tearDown(() => registry.clear());

    testWidgets('sidebar shows dynamic page labels at desktop width',
        (tester) async {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);
      final adminModules = registry.forRoleNames(['Admin']);

      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: DashboardShell(
            destinations: adminModules
                .map((m) => DashboardDestination(
                      label: m.displayName,
                      icon: Builder(
                        builder: (ctx) =>
                            m.buildIcon(ctx) ?? const Icon(Icons.circle),
                      ),
                    ))
                .toList(),
            body: const Text('Content'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Loans'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);
    });

    testWidgets('LoanSupervisor only sees Loans in sidebar', (tester) async {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);
      final lsModules = registry.forRoleNames(['LoanSupervisor']);

      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: DashboardShell(
            destinations: lsModules
                .map((m) => DashboardDestination(
                      label: m.displayName,
                      icon: const Icon(Icons.circle),
                    ))
                .toList(),
            body: const Text('Content'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loans'), findsOneWidget);
      expect(find.text('Dashboard'), findsNothing);
      expect(find.text('Reports'), findsNothing);
    });

    testWidgets('Viewer only sees Dashboard in sidebar', (tester) async {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);
      final viewerModules = registry.forRoleNames(['Viewer']);

      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: DashboardShell(
            destinations: viewerModules
                .map((m) => DashboardDestination(
                      label: m.displayName,
                      icon: const Icon(Icons.circle),
                    ))
                .toList(),
            body: const Text('Content'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Loans'), findsNothing);
      expect(find.text('Reports'), findsNothing);
    });

    testWidgets('tapping a dynamic page destination triggers callback',
        (tester) async {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);
      final modules = registry.forRoleNames(['Admin']);

      int? selectedIndex;

      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: DashboardShell(
            destinations: [
              DashboardDestination(
                label: modules.first.displayName,
                icon: const Icon(Icons.circle),
              ),
            ],
            body: const Text('Body'),
            onDestinationSelected: (i) => selectedIndex = i,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Loans'));
      await tester.pump();

      expect(selectedIndex, 0);
    });

    testWidgets('dynamic page buildContent renders inside Shell body',
        (tester) async {
      PageRegistryService.loadFromJsonString(_loansJson, registry: registry);
      final module =
          registry.find('/loans')! as DynamicPageModule;

      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: DashboardShell(
            destinations: const [
              DashboardDestination(
                  label: 'Loans', icon: Icon(Icons.circle)),
            ],
            body: Builder(builder: (ctx) => module.buildContent(ctx)),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Loans'), findsAtLeastNWidgets(1));
      expect(find.text('Dynamically registered page'), findsOneWidget);
    });

    testWidgets('empty role produces empty sidebar', (tester) async {
      PageRegistryService.loadFromJsonString(_multiPageJson,
          registry: registry);
      final noModules = registry.forRoleNames(['UnknownRole']);

      await tester.pumpWidget(
        _buildUnderTest(
          width: 1200,
          child: DashboardShell(
            destinations: noModules
                .map((m) => DashboardDestination(
                      label: m.displayName,
                      icon: const Icon(Icons.circle),
                    ))
                .toList(),
            body: const Text('No access'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No access'), findsOneWidget);
      // None of the page labels appear.
      expect(find.text('Loans'), findsNothing);
      expect(find.text('Dashboard'), findsNothing);
    });
  });
}

// ── Helpers ───────────────────────────────────────────────────────────────────

/// A classic enum-role module used to verify backwards-compat with forRoleNames.
class _EnumModule extends AdaptiveModule {
  _EnumModule(this.moduleId, UserRole role) : allowedRoles = [role];

  @override
  final String moduleId;

  @override
  String get displayName => moduleId;

  @override
  final List<UserRole> allowedRoles;

  @override
  Widget buildContent(BuildContext context) => const SizedBox.shrink();
}
