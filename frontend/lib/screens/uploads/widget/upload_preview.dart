import 'package:flutter/material.dart';
import 'package:frontend/models/upload_model.dart';

import 'package:url_launcher/url_launcher.dart';


class UploadPreview extends StatelessWidget {
  final UploadModel upload;

  const UploadPreview({
    super.key,
    required this.upload,
  });

  Future<void> _openFile() async {
    final uri = Uri.parse(upload.url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImage = upload.isImage;

    return Scaffold(
      appBar: AppBar(
        title: Text(upload.originalName),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: _openFile,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isImage
              ? InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Image.network(
                    upload.url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return const Text(
                        "Unable to load image.",
                      );
                    },
                  ),
                )
              : Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      upload.isPdf
                          ? Icons.picture_as_pdf
                          : Icons.description,
                      size: 90,
                      color: upload.isPdf
                          ? Colors.red
                          : Colors.blue,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      upload.originalName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      upload.formattedSize,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: _openFile,
                      icon: const Icon(Icons.open_in_new),
                      label: const Text("Open File"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}