import 'package:file_picker/file_picker.dart';
import 'package:frontend/servicies/upload_service.dart';

import 'package:get/get.dart';

import '../models/upload_model.dart';

class UploadController extends GetxController {
  final UploadService _service;

  UploadController(this._service);

  /// Uploaded files
  final RxList<UploadModel> uploads = <UploadModel>[].obs;

  /// Upload progress (0.0 - 1.0)
  final RxDouble progress = 0.0.obs;

  /// Loading
  final RxBool isUploading = false.obs;

  /// Error
  final RxString error = "".obs;

  /// Upload File
  Future<UploadModel?> pickAndUpload() async {
    try {
      error.value = "";

      final result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: [
          "jpg",
          "jpeg",
          "png",
          "webp",
          "pdf",
          "doc",
          "docx",
        ],
      );

      if (result == null) {
        return null;
      }

      final file = result.files.single;

      isUploading.value = true;
      progress.value = 0;

      final upload = await _service.uploadPlatformFile(
        file,
        onSendProgress: (sent, total) {
          if (total > 0) {
            progress.value = sent / total;
          }
        },
      );

      uploads.insert(0, upload);

      progress.value = 1;

      Get.snackbar(
        "Success",
        "File uploaded successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );

      return upload;
    } catch (e) {
      error.value = e.toString();

      Get.snackbar(
        "Upload Failed",
        error.value,
        snackPosition: SnackPosition.BOTTOM,
      );

      return null;
    } finally {
      isUploading.value = false;
    }
  }

  /// Delete Upload
  Future<void> deleteUpload(String id) async {
    try {
      await _service.deleteUpload(id);

      uploads.removeWhere(
        (upload) => upload.id == id,
      );

      Get.snackbar(
        "Deleted",
        "File deleted successfully.",
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

  /// Clear List
  void clearUploads() {
    uploads.clear();
  }
}
