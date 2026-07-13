import 'package:dio/dio.dart';
import 'package:frontend/servicies/api_service.dart';
import '../models/profile_model.dart';

/// Profile service — uses the singleton ApiService Dio so auth token
/// from SharedPreferences is automatically injected on every request.
class ProfileService {
  final Dio _dio = ApiService.instance.dio;

  /// Get current user profile
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get("users/profile");

      return ProfileModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to fetch profile",
      );
    }
  }

  /// Update profile details
  Future<ProfileModel> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? profileImage,
  }) async {
    try {
      final response = await _dio.put(
        "users/profile",
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          ...?(profileImage != null
              ? {"profileImage": profileImage}
              : null),
        },
      );

      return ProfileModel.fromJson(response.data["data"]);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to update profile",
      );
    }
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.put(
        "users/change-password",
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Unable to change password",
      );
    }
  }
}
