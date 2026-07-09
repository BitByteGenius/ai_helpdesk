import 'package:dio/dio.dart';

import '../models/profile_model.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  /// Get Profile
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get(
        "users/profile",
      );

      return ProfileModel.fromJson(
        response.data["data"],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to fetch profile",
      );
    }
  }

  /// Update Profile
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
          "profileImage": ?profileImage,
        },
      );

      return ProfileModel.fromJson(
        response.data["data"],
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Unable to update profile",
      );
    }
  }

  /// Change Password
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
        e.response?.data["message"] ??
            "Unable to change password",
      );
    }
  }
}