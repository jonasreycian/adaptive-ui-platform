/// Roles that determine which modules and presets are available.
enum UserRole {
  /// Full system access.
  admin,

  /// Standard authenticated user.
  user,

  /// Read-only observer.
  viewer,

  /// External partner or customer.
  guest,
}
