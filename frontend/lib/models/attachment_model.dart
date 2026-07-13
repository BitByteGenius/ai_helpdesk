class AttachmentModel {
  final String url;
  final String fileName;
  final String fileType;
  final int fileSize;

  AttachmentModel({
    required this.url,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      url: json["url"] ?? "",
      fileName: json["fileName"] ?? "",
      fileType: json["fileType"] ?? "",
      fileSize: json["fileSize"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "fileName": fileName,
      "fileType": fileType,
      "fileSize": fileSize,
    };
  }
}