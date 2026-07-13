import 'package:flutter/material.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/models/upload_model.dart';
import 'package:frontend/servicies/profile_service.dart';
import 'package:get/get.dart';

import '../models/profile_model.dart';

class ProfileController extends GetxController {
  final ProfileService _service;

  ProfileController(this._service);

  /// Loading
  final RxBool isLoading = false.obs;

  /// Error
  final RxString error = "".obs;

  /// Profile
  final Rxn<ProfileModel> profile = Rxn<ProfileModel>();

  /// Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Load Profile
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      final data = await _service.getProfile();

      profile.value = data;

      nameController.text = data.name;
      emailController.text = data.email;
      phoneController.text = data.phone;
    } catch (e) {
      error.value = e.toString();

      Get.snackbar(
        "Error",
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Profile
  Future<void> updateProfile({
    String? profileImage,
  }) async {
    try {
      isLoading.value = true;

      final updated = await _service.updateProfile(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        profileImage: profileImage,
      );

      profile.value = updated;

      Get.snackbar(
        "Success",
        "Profile updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;

      await _service.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      Get.snackbar(
        "Success",
        "Password changed successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }


  /// Upload Profile Image
Future<void> uploadProfileImage() async {
  try {
    final uploadController = Get.find<UploadController>();

    // Pick and upload file
    await uploadController.pickAndUpload();

    if (uploadController.uploads.isEmpty) {
      return;
    }

    final UploadModel image = uploadController.uploads.last;

    final updated = await _service.updateProfile(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      profileImage: image.url,
    );

    profile.value = updated;

    Get.snackbar(
      "Success",
      "Profile picture updated successfully.",
      snackPosition: SnackPosition.BOTTOM,
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  /// Refresh Profile
  Future<void> refreshProfile() async {
    await loadProfile();
  }
}