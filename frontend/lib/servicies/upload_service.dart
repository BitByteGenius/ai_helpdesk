import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/servicies/api_service.dart';
import '../models/upload_model.dart';

/// Upload service — uses the singleton ApiService Dio so auth token
/// from SharedPreferences is automatically injected on every request.
class UploadService {
  final Dio _dio = ApiService.instance.dio;

  /// Upload a PlatformFile (works on Web, Android, iOS, Desktop)
  Future<UploadModel> uploadPlatformFile(
    PlatformFile file, {
    ProgressCallback? onSendProgress,
  }) async {
    final MultipartFile multipartFile;

    if (file.bytes != null) {
      // Flutter Web — bytes available directly
      multipartFile = MultipartFile.fromBytes(
        file.bytes!,
        filename: file.name,
      );
    } else if (file.path != null) {
      // Android / iOS / Desktop — file.path is available
      multipartFile = await MultipartFile.fromFile(
        file.path!,
        filename: file.name,
      );
    } else {
      throw Exception("Unable to read selected file. Please try again.");
    }

    final formData = FormData.fromMap({"file": multipartFile});

    final response = await _dio.post(
      "uploads",
      data: formData,
      onSendProgress: onSendProgress,
    );

    return UploadModel.fromJson(response.data["data"]);
  }

  /// Delete an uploaded file by its ID
  Future<void> deleteUpload(String uploadId) async {
    await _dio.delete("uploads/$uploadId");
  }
}
