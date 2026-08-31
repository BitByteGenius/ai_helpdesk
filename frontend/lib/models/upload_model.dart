class UploadModel {
  final String id;
  final String originalName;
  final String fileName;
  final String url;
  final String publicId;
  final String mimeType;
  final String fileType;
  final int fileSize;

  UploadModel({
    required this.id,
    required this.originalName,
    required this.fileName,
    required this.url,
    required this.publicId,
    required this.mimeType,
    required this.fileType,
    required this.fileSize,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory UploadModel.fromJson(Map<String, dynamic> json) {
    return UploadModel(
      id: _parseString(json["_id"]),
      originalName: _parseString(json["originalName"]),
      fileName: _parseString(json["fileName"]),
      url: _parseString(json["url"]),
      publicId: _parseString(json["publicId"]),
      mimeType: _parseString(json["mimeType"]),
      fileType: _parseString(json["fileType"]),
      fileSize: int.tryParse(json["fileSize"]?.toString() ?? "0") ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "originalName": originalName,
      "fileName": fileName,
      "url": url,
      "publicId": publicId,
      "mimeType": mimeType,
      "fileType": fileType,
      "fileSize": fileSize,
    };
  }

  /// Convert bytes to KB / MB
  String get formattedSize {
    if (fileSize >= 1024 * 1024) {
      return "${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB";
    }

    if (fileSize >= 1024) {
      return "${(fileSize / 1024).toStringAsFixed(2)} KB";
    }

    return "$fileSize B";
  }

  bool get isImage =>
      mimeType.startsWith("image/");

  bool get isPdf =>
      mimeType == "application/pdf";

  bool get isWord =>
      mimeType ==
          "application/msword" ||
      mimeType ==
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
}