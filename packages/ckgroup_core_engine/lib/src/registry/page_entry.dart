import 'package:flutter/foundation.dart';

/// An immutable descriptor for a dynamically registered sidebar page.
///
/// Produced by the `ckgroup-core add` CLI command and stored in
/// `page_registry.json`.
@immutable
class PageEntry {
  const PageEntry({
    required this.pageName,
    required this.route,
    required this.roles,
    this.iconName,
  });

  /// Human-readable page title shown in the sidebar (e.g. `"Loans"`).
  final String pageName;

  /// Navigation route path (e.g. `"/loans"`).
  final String route;

  /// Role names that may access this page (case-insensitive, e.g. `["Admin"]`).
  final List<String> roles;

  /// Optional Material icon name (e.g. `"description"`).
  final String? iconName;

  /// Creates a [PageEntry] from a JSON map (as decoded by `dart:convert`).
  factory PageEntry.fromJson(Map<String, dynamic> json) {
    return PageEntry(
      pageName: json['pageName'] as String,
      route: json['route'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
      iconName: json['iconName'] as String?,
    );
  }

  /// Converts this entry to a JSON-serialisable map.
  Map<String, dynamic> toJson() => {
        'pageName': pageName,
        'route': route,
        'roles': roles,
        if (iconName != null) 'iconName': iconName,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageEntry &&
          runtimeType == other.runtimeType &&
          pageName == other.pageName &&
          route == other.route;

  @override
  int get hashCode => Object.hash(pageName, route);

  @override
  String toString() =>
      'PageEntry(pageName: $pageName, route: $route, roles: $roles)';
}
