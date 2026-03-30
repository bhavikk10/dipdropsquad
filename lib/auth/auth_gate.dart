class AuthGate {
  /// Mock gate: user must accept platform rules before entering the app shell.
  /// Riverpod owns the UI toggle; this flag is used by the router.
  static bool termsAccepted = false;
}

