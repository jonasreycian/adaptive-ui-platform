import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:ckgroup_core_cli/ckgroup_core_cli.dart';

void main() {
  // ── PageRegistryIo ──────────────────────────────────────────────────────────
  group('PageRegistryIo', () {
    late Directory tmpDir;

    setUp(() {
      tmpDir = Directory.systemTemp.createTempSync('page_registry_test_');
    });

    tearDown(() {
      tmpDir.deleteSync(recursive: true);
    });

    test('read returns empty registry when file does not exist', () {
      final io = PageRegistryIo(
        registryPath: '${tmpDir.path}/page_registry.json',
      );
      final data = io.read();
      expect(data['version'], '1');
      expect(data['pages'], isEmpty);
    });

    test('write creates the file and read round-trips it', () {
      final path = '${tmpDir.path}/page_registry.json';
      final io = PageRegistryIo(registryPath: path);

      final data = {'version': '1', 'pages': <Map<String, dynamic>>[]};
      io.write(data);

      expect(File(path).existsSync(), isTrue);
      final read = io.read();
      expect(read['version'], '1');
      expect(read['pages'], isEmpty);
    });

    test('addPage appends a new entry', () {
      final data = {'version': '1', 'pages': <Map<String, dynamic>>[]};
      final updated = PageRegistryIo.addPage(
        data,
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin', 'LoanSupervisor', 'Creditor'],
        iconName: 'description',
      );

      final pages =
          (updated['pages'] as List).cast<Map<String, dynamic>>();
      expect(pages, hasLength(1));
      expect(pages.first['pageName'], 'Loans');
      expect(pages.first['route'], '/loans');
      expect(pages.first['roles'], ['Admin', 'LoanSupervisor', 'Creditor']);
      expect(pages.first['iconName'], 'description');
    });

    test('addPage without iconName omits the key', () {
      final data = {'version': '1', 'pages': <Map<String, dynamic>>[]};
      final updated = PageRegistryIo.addPage(
        data,
        pageName: 'Reports',
        route: '/reports',
        roles: ['Admin'],
      );
      final pages =
          (updated['pages'] as List).cast<Map<String, dynamic>>();
      expect(pages.first.containsKey('iconName'), isFalse);
    });

    test('addPage throws ArgumentError on duplicate route', () {
      var data = {'version': '1', 'pages': <Map<String, dynamic>>[]};
      data = PageRegistryIo.addPage(
        data,
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin'],
      );

      expect(
        () => PageRegistryIo.addPage(
          data,
          pageName: 'Loans Again',
          route: '/loans',
          roles: ['Admin'],
        ),
        throwsArgumentError,
      );
    });

    test('hasPage returns false for unknown route', () {
      final data = {'version': '1', 'pages': <Map<String, dynamic>>[]};
      expect(PageRegistryIo.hasPage(data, '/loans'), isFalse);
    });

    test('hasPage returns true after addPage', () {
      var data = {'version': '1', 'pages': <Map<String, dynamic>>[]};
      data = PageRegistryIo.addPage(
        data,
        pageName: 'Loans',
        route: '/loans',
        roles: ['Admin'],
      );
      expect(PageRegistryIo.hasPage(data, '/loans'), isTrue);
    });
  });

  // ── AddCommand ──────────────────────────────────────────────────────────────
  group('AddCommand', () {
    late Directory tmpDir;

    setUp(() {
      tmpDir = Directory.systemTemp.createTempSync('add_command_test_');
    });

    tearDown(() {
      tmpDir.deleteSync(recursive: true);
    });

    String registryPath() => '${tmpDir.path}/page_registry.json';

    int runAdd(List<String> extraArgs) {
      final parser = AddCommand.buildParser();
      final results = parser.parse([
        '--output=${registryPath()}',
        ...extraArgs,
      ]);
      final messages = <String>[];
      return AddCommand.run(results, print: messages.add);
    }

    test('returns 0 and writes file on valid input', () {
      final code = runAdd(['--page=Loans', '--roles=Admin,LoanSupervisor,Creditor']);
      expect(code, 0);
      expect(File(registryPath()).existsSync(), isTrue);
    });

    test('JSON file contains the correct page entry', () {
      runAdd(['--page=Loans', '--roles=Admin,LoanSupervisor,Creditor']);
      final content = File(registryPath()).readAsStringSync();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final pages =
          (data['pages'] as List).cast<Map<String, dynamic>>();
      expect(pages, hasLength(1));
      expect(pages.first['pageName'], 'Loans');
      expect(pages.first['route'], '/loans');
      expect(
        pages.first['roles'],
        containsAll(['Admin', 'LoanSupervisor', 'Creditor']),
      );
    });

    test('derives route from page name by default', () {
      runAdd(['--page=My Page', '--roles=Admin']);
      final data =
          jsonDecode(File(registryPath()).readAsStringSync()) as Map<String, dynamic>;
      final pages =
          (data['pages'] as List).cast<Map<String, dynamic>>();
      expect(pages.first['route'], '/my_page');
    });

    test('respects explicit --route option', () {
      runAdd(['--page=Loans', '--roles=Admin', '--route=/custom-loans']);
      final data =
          jsonDecode(File(registryPath()).readAsStringSync()) as Map<String, dynamic>;
      final pages =
          (data['pages'] as List).cast<Map<String, dynamic>>();
      expect(pages.first['route'], '/custom-loans');
    });

    test('stores --icon when provided', () {
      runAdd(['--page=Reports', '--roles=Admin', '--icon=bar_chart']);
      final data =
          jsonDecode(File(registryPath()).readAsStringSync()) as Map<String, dynamic>;
      final pages =
          (data['pages'] as List).cast<Map<String, dynamic>>();
      expect(pages.first['iconName'], 'bar_chart');
    });

    test('returns 1 when page already exists', () {
      runAdd(['--page=Loans', '--roles=Admin']);
      final code = runAdd(['--page=Loans', '--roles=Viewer']);
      expect(code, 1);
    });

    test('multiple add calls accumulate pages', () {
      runAdd(['--page=Loans', '--roles=Admin']);
      runAdd(['--page=Reports', '--roles=Admin,Viewer']);
      final data =
          jsonDecode(File(registryPath()).readAsStringSync()) as Map<String, dynamic>;
      final pages = data['pages'] as List;
      expect(pages, hasLength(2));
    });
  });
}
