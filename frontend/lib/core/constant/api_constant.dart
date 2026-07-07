
class ApiConstants {
  ApiConstants._();

  /// ─── Change this to switch environments ───────────────────────────────
  static const String baseUrl = "http://localhost:5000/api/";
  

  // Auth endpoints (relative to baseUrl)
  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String adminLogin = "auth/admin-login";


  static const Duration timeout = Duration(seconds: 30);
}
