class ApiConstants {
  ApiConstants._();

  // ==========================
  // Base URL
  // ==========================

  /// Android Emulator
  // static const String baseUrl = "http://10.0.2.2:5000/api/";

  /// Flutter Web
  static const String baseUrl = "http://localhost:5000/api/";

  /// Physical Device
  // static const String baseUrl = "http://192.168.1.100:5000/api/";

  static const Duration timeout = Duration(seconds: 30);

  // ==========================
  // Auth
  // ==========================

  static const String login = "auth/login";
  static const String register = "auth/register";
  static const String adminLogin = "auth/admin-login";

  // ==========================
  // Dashboard
  // ==========================

  static const String dashboard = "dashboard";

  // ==========================
  // Users
  // ==========================

  static const String users = "users";

  // ==========================
  // Tickets
  // ==========================

  static const String tickets = "tickets";
  static const String myTickets = "tickets/my";
}