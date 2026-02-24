import 'dart:convert';

import '../plugins/module_registry.dart';
import 'dynamic_page_module.dart';
import 'page_entry.dart';

/// Parses and loads [PageEntry] definitions into [ModuleRegistry].
///
/// Usage — call once at app start-up after registering the default brand:
/// ```dart
/// final json = await rootBundle.loadString('page_registry.json');
/// PageRegistryService.loadFromJsonString(json);
/// ```
class PageRegistryService {
  PageRegistryService._();

  /// The JSON key that holds the pages array.
  static const String _pagesKey = 'pages';

  // ── Public API ───────────────────────────────────────────────────────────────

  /// Parses [jsonString] and registers every [PageEntry] with [registry].
  ///
  /// Entries whose [PageEntry.route] is already registered are skipped
  /// (idempotent — safe to call multiple times with the same data).
  ///
  /// Throws [FormatException] if [jsonString] is not valid JSON or lacks the
  /// expected structure.
  static void loadFromJsonString(
    String jsonString, {
    ModuleRegistry? registry,
  }) {
    final reg = registry ?? ModuleRegistry.instance;
    final entries = parseEntries(jsonString);
    for (final entry in entries) {
      if (!reg.modules.containsKey(entry.route)) {
        reg.register(DynamicPageModule(entry: entry));
      }
    }
  }

  /// Decodes [jsonString] and returns the list of [PageEntry] objects.
  ///
  /// Returns an empty list if the `"pages"` key is absent or empty.
  static List<PageEntry> parseEntries(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final raw = decoded[_pagesKey];
    if (raw == null) return const [];
    return (raw as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(PageEntry.fromJson)
        .toList();
  }

  /// Serialises [entries] to a JSON string suitable for writing to
  /// `page_registry.json`.
  ///
  /// Existing [version] metadata is preserved when [existing] is supplied.
  static String toJsonString(
    List<PageEntry> entries, {
    String version = '1',
  }) {
    return const JsonEncoder.withIndent('  ').convert({
      'version': version,
      _pagesKey: entries.map((e) => e.toJson()).toList(),
    });
  }
}
