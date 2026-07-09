import 'package:flutter/material.dart';
import 'package:frontend/controllers/upload_controller.dart';
import 'package:frontend/models/upload_model.dart';
import 'package:get/get.dart';


class UploadCard extends StatelessWidget {
  final UploadModel upload;

  const UploadCard({
    super.key,
    required this.upload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            /// File Icon / Preview
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: upload.isImage
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12),
                      child: Image.network(
                        upload.url,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, _, _) =>
                                const Icon(
                          Icons.image,
                          size: 32,
                        ),
                      ),
                    )
                  : Icon(
                      upload.isPdf
                          ? Icons.picture_as_pdf
                          : Icons.description,
                      size: 34,
                      color: upload.isPdf
                          ? Colors.red
                          : Colors.blue,
                    ),
            ),

            const SizedBox(width: 16),

            /// File Info
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    upload.originalName,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    upload.fileType,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    upload.formattedSize,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// View Button
            IconButton(
              tooltip: "Preview",
              icon: const Icon(
                Icons.visibility,
                color: Colors.blue,
              ),
              onPressed: () {
                Get.toNamed(
                  "/upload-preview",
                  arguments: upload,
                );
              },
            ),

            /// Delete Button
            IconButton(
              tooltip: "Delete",
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete File",
                  middleText:
                      "Delete this uploaded file?",
                  textCancel: "Cancel",
                  textConfirm: "Delete",
                  confirmTextColor:
                      Colors.white,
                  onConfirm: () {
                    Get.back();

                    Get.find<UploadController>()
                        .deleteUpload(upload.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}