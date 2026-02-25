import 'dashboard_preset.dart';
import 'user_role.dart';

/// Registry for [DashboardPreset] instances.
class PresetRegistry {
  PresetRegistry._();

  static final PresetRegistry _instance = PresetRegistry._();
  static PresetRegistry get instance => _instance;

  final Map<String, DashboardPreset> _presets = {};

  /// All registered presets.
  Map<String, DashboardPreset> get presets => Map.unmodifiable(_presets);

  /// Registers [preset]. Throws [StateError] if [preset.presetId] is taken.
  void register(DashboardPreset preset) {
    if (_presets.containsKey(preset.presetId)) {
      throw StateError('Preset "${preset.presetId}" is already registered.');
    }
    _presets[preset.presetId] = preset;
  }

  /// Removes [presetId] from the registry.
  void unregister(String presetId) => _presets.remove(presetId);

  /// Returns all presets for [role].
  List<DashboardPreset> forRole(UserRole role) =>
      _presets.values.where((p) => p.role == role).toList();

  /// Clears all presets (useful in tests).
  void clear() => _presets.clear();
}
