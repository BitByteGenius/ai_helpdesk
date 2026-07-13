import 'package:flutter/material.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/screens/uploads/widget/upload_card.dart';
import 'package:frontend/screens/uploads/widget/upload_progress.dart';
import 'package:get/get.dart';

import '../../controllers/upload_controller.dart';


class UploadScreen extends GetView<UploadController> {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'File Upload',
      child: Stack(
        children: [
          Obx(() {
            return RefreshIndicator(
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Upload Attachments",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Supported formats: JPG, PNG, WEBP, PDF, DOC, DOCX",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton.icon(
                  onPressed: controller.pickAndUpload,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Choose File"),
                ),

                const SizedBox(height: 25),

                const UploadProgress(),

                const SizedBox(height: 20),

                if (controller.uploads.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No uploaded files",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: controller.uploads.length,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return UploadCard(
                        upload:
                            controller.uploads[index],
                      );
                    },
                  ),
              ],
            ),
          ),
        );
          }),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              onPressed: controller.pickAndUpload,
              icon: const Icon(Icons.upload),
              label: const Text("Upload"),
            ),
          ),
        ],
      ),
    );
  }
}
