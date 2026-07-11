import 'dart:convert';

import 'package:frontend/servicies/auth_service.dart';
import 'package:frontend/servicies/storage_service.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;
  String _errorMessage = "";
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  void _setLoading(bool value) {
    _isLoading = value;
    update();
  }

  void _setError(String message) {
    _errorMessage = message;
    update();
  }

  Future<void> logout() async {
    await StorageService.clear();
    _user = null;
    _isLoggedIn = false;
    _errorMessage = "";
    update();
  }

  // ─── User Login ───────────────────────────────────────────────────────
  Future<bool> login({required String email, required String password}) async {
    if (_isLoading) return false;
    try {
      _setLoading(true);
      _errorMessage = "";

      final user = await _authService.login(email: email, password: password);

      _user = user;
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    }
  }

  // ─── Admin Login ──────────────────────────────────────────────────────
  Future<bool> adminLogin({
    required String email,
    required String password,
  }) async {
    if (_isLoading) return false;
    try {
      _setLoading(true);
      _errorMessage = "";

      final user = await _authService.adminLogin(
        email: email,
        password: password,
      );

      _user = user;
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    }
  }

  // ─── Register ────────────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (_isLoading) return false;
    try {
      _setLoading(true);
      _errorMessage = "";

      final user = await _authService.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      _user = user;
      _isLoggedIn = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(_friendlyError(e));
      return false;
    }
  }

  // ─── Auto Login (Splash screen) ──────────────────────────────────────
  Future<bool> autoLogin() async {
    try {
      final token = await StorageService.getToken();
      if (token == null) return false;

      if (JwtDecoder.isExpired(token)) {
        await logout();
        return false;
      }

      final userString = await StorageService.getUser();
      if (userString == null) return false;

      _user = UserModel.fromJson(
        jsonDecode(userString) as Map<String, dynamic>,
      );
      _isLoggedIn = true;
      _errorMessage = "";
      update();
      return true;
    } catch (_) {
      return false;
    }
  }

  

  // ─── Helper: extract readable message from Dio / generic errors ──────
  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains("DioException")) {
      final start = msg.indexOf('"message"');
      if (start != -1) return msg.substring(start);
    }
    return msg;
  }
}
