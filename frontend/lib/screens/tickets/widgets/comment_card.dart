import 'package:flutter/material.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/models/comment_model.dart';
import 'package:get/get.dart';



class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isMine;

  const CommentCard({
    super.key,
    required this.comment,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CommentController>();

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// Header
            Row(
              children: [

                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage:
                      comment.user.image.isNotEmpty
                          ? NetworkImage(
                              comment.user.image,
                            )
                          : null,
                  child:
                      comment.user.image.isEmpty
                          ? Text(
                              comment.user.name.isNotEmpty
                                  ? comment.user.name[0]
                                      .toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        comment.user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        comment.createdAt
                            .toLocal()
                            .toString()
                            .substring(0, 16),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                if (comment.isEdited)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Edited",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),

                if (isMine)
                  PopupMenuButton<String>(
                    onSelected: (value) {

                      if (value == "edit") {
                        _showEditDialog(
                          context,
                          controller,
                        );
                      }

                      if (value == "delete") {
                        controller.deleteComment(
                          comment.id,
                        );
                      }
                    },
                    itemBuilder: (_) => const [

                      PopupMenuItem(
                        value: "edit",
                        child: Text("Edit"),
                      ),

                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              comment.message,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    CommentController controller,
  ) {
    final textController =
        TextEditingController(
      text: comment.message,
    );

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Comment"),

        content: TextField(
          controller: textController,
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),

        actions: [

          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {

              await controller.updateComment(
                comment.id,
                textController.text.trim(),
              );

              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}