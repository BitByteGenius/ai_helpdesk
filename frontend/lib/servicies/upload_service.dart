import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:frontend/core/constant/api_constant.dart';
import 'package:get_storage/get_storage.dart';

import '../models/upload_model.dart';

class UploadService {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();

  UploadService() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = ApiConstants.timeout;
    _dio.options.receiveTimeout = ApiConstants.timeout;

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read("token");

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          return handler.next(options);
        },
      ),
    );
  }

  /// Upload File
  Future<UploadModel> uploadFile({
    required File file,
    ProgressCallback? onSendProgress,
  }) async {
    final fileName = file.path.split("/").last;

    final formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });

    final response = await _dio.post(
      "/uploads",
      data: formData,
      onSendProgress: onSendProgress,
    );

    return UploadModel.fromJson(response.data["data"]);
  }

  /// Delete Upload
  Future<void> deleteUpload(String uploadId) async {
    await _dio.delete(
      "/uploads/$uploadId",
    );
  }

  Future<UploadModel> uploadPlatformFile(
  PlatformFile file, {
  ProgressCallback? onSendProgress,
}) async {
  MultipartFile multipartFile;

  if (file.bytes != null) {
    // Flutter Web
    multipartFile = MultipartFile.fromBytes(
      file.bytes!,
      filename: file.name,
    );
  } else {
    // Android / iOS / Desktop
    multipartFile = await MultipartFile.fromFile(
      file.path!,
      filename: file.name,
    );
  }

  final formData = FormData.fromMap({
    "file": multipartFile,
  });

  final response = await _dio.post(
    "/uploads",
    data: formData,
    onSendProgress: onSendProgress,
  );

  return UploadModel.fromJson(
    response.data["data"],
  );
}
}