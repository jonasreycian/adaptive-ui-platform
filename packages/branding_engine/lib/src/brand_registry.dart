import 'brand_config.dart';

/// A singleton registry that maps brand IDs to [BrandConfig] instances.
///
/// Throws a [StateError] when attempting to register a duplicate brand ID.
class BrandRegistry {
  BrandRegistry._();

  static final BrandRegistry _instance = BrandRegistry._();

  /// The singleton instance of [BrandRegistry].
  static BrandRegistry get instance => _instance;

  final Map<String, BrandConfig> _brands = {};

  /// All currently registered brands.
  Map<String, BrandConfig> get brands => Map.unmodifiable(_brands);

  /// Registers [config] under its [BrandConfig.brandId].
  ///
  /// Throws [StateError] if a brand with the same ID is already registered.
  void register(BrandConfig config) {
    if (_brands.containsKey(config.brandId)) {
      throw StateError(
        'Brand "${config.brandId}" is already registered. '
        'Call unregister() first if you intend to replace it.',
      );
    }
    _brands[config.brandId] = config;
  }

  /// Removes the brand with [brandId] from the registry.
  ///
  /// Does nothing if no brand with that ID is registered.
  void unregister(String brandId) => _brands.remove(brandId);

  /// Returns the [BrandConfig] for [brandId], or null if not registered.
  BrandConfig? find(String brandId) => _brands[brandId];

  /// Returns `true` if a brand with [brandId] is registered.
  bool contains(String brandId) => _brands.containsKey(brandId);

  /// Clears all registered brands (useful in tests).
  void clear() => _brands.clear();
}
