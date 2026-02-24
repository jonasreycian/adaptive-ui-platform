import '../roles/user_role.dart';
import 'adaptive_module.dart';

/// Registry for [AdaptiveModule] instances.
///
/// Throws [StateError] on duplicate or invalid module IDs.
class ModuleRegistry {
  ModuleRegistry._();

  static final ModuleRegistry _instance = ModuleRegistry._();
  static ModuleRegistry get instance => _instance;

  final Map<String, AdaptiveModule> _modules = {};

  /// All registered modules.
  Map<String, AdaptiveModule> get modules => Map.unmodifiable(_modules);

  /// Registers [module].
  ///
  /// Throws [StateError] if:
  /// * A module with the same [AdaptiveModule.moduleId] is already registered.
  /// * [AdaptiveModule.moduleId] is empty.
  void register(AdaptiveModule module) {
    if (module.moduleId.isEmpty) {
      throw StateError('Module ID must not be empty.');
    }
    if (_modules.containsKey(module.moduleId)) {
      throw StateError(
        'Module "${module.moduleId}" is already registered. '
        'Call unregister() first if you intend to replace it.',
      );
    }
    _modules[module.moduleId] = module;
  }

  /// Removes the module with [moduleId].
  void unregister(String moduleId) => _modules.remove(moduleId);

  /// Returns the module for [moduleId], or null if not registered.
  AdaptiveModule? find(String moduleId) => _modules[moduleId];

  /// Returns all modules accessible to [role].
  List<AdaptiveModule> forRole(UserRole role) => _modules.values
      .where((m) => m.allowedRoles.contains(role))
      .toList();

  /// Clears all registered modules (useful in tests).
  void clear() => _modules.clear();
}
