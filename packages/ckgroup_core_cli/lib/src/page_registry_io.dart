import 'dart:convert';
import 'dart:io';

/// Reads, mutates, and writes the `page_registry.json` file.
class PageRegistryIo {
  const PageRegistryIo({required this.registryPath});

  /// Absolute or relative path to `page_registry.json`.
  final String registryPath;

  // ── Read ─────────────────────────────────────────────────────────────────────

  /// Returns the parsed JSON map, or an empty registry if the file does not
  /// exist yet.
  Map<String, dynamic> read() {
    final file = File(registryPath);
    if (!file.existsSync()) {
      return {'version': '1', 'pages': <Map<String, dynamic>>[]};
    }
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  // ── Write ────────────────────────────────────────────────────────────────────

  /// Serialises [data] and writes it to [registryPath], creating parent
  /// directories as needed.
  void write(Map<String, dynamic> data) {
    final file = File(registryPath);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(data),
    );
  }

  // ── Mutation helpers ─────────────────────────────────────────────────────────

  /// Returns `true` if a page with [route] already exists in [data].
  static bool hasPage(Map<String, dynamic> data, String route) {
    final pages = _pages(data);
    return pages.any((p) => p['route'] == route);
  }

  /// Appends a new page entry to [data] and returns the updated map.
  ///
  /// Throws [ArgumentError] if a page with the same route already exists.
  static Map<String, dynamic> addPage(
    Map<String, dynamic> data, {
    required String pageName,
    required String route,
    required List<String> roles,
    String? iconName,
  }) {
    if (hasPage(data, route)) {
      throw ArgumentError(
        'A page with route "$route" already exists. '
        'Use a different route or remove the existing entry first.',
      );
    }

    final entry = <String, dynamic>{
      'pageName': pageName,
      'route': route,
      'roles': roles,
      if (iconName != null) 'iconName': iconName,
    };

    final pages = List<Map<String, dynamic>>.from(_pages(data))..add(entry);
    return {...data, 'pages': pages};
  }

  // ── Private ──────────────────────────────────────────────────────────────────

  static List<Map<String, dynamic>> _pages(Map<String, dynamic> data) {
    final raw = data['pages'];
    if (raw == null) return [];
    return (raw as List<dynamic>).cast<Map<String, dynamic>>();
  }
}
