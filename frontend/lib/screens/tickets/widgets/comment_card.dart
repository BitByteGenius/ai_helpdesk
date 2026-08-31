import 'package:flutter/material.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/comment_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: context.primarySubtle,
                backgroundImage: comment.user.image.isNotEmpty ? NetworkImage(comment.user.image) : null,
                child: comment.user.image.isEmpty
                    ? Text(
                        comment.user.name.isNotEmpty ? comment.user.name[0].toUpperCase() : "?",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.primaryColor),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat("dd MMM, hh:mm a").format(comment.createdAt.toLocal()),
                      style: TextStyle(
                        color: context.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (comment.isEdited)
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.surfaceSubtle,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Edited",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: context.textMuted),
                  ),
                ),
              if (isMine)
                PopupMenuButton<String>(
                  color: context.cardBg,
                  icon: Icon(Icons.more_vert_rounded, size: 18, color: context.textMuted),
                  onSelected: (value) {
                    if (value == "edit") {
                      _showEditDialog(context, controller);
                    }
                    if (value == "delete") {
                      controller.deleteComment(comment.id);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: "edit",
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 16),
                          SizedBox(width: 8),
                          Text("Edit", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: "delete",
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.error),
                          SizedBox(width: 8),
                          Text("Delete", style: TextStyle(fontSize: 13, color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.message,
            style: TextStyle(
              fontSize: 13.5,
              color: context.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, CommentController controller) {
    final textController = TextEditingController(text: comment.message);

    Get.dialog(
      Dialog(
        backgroundColor: context.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 480,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Comment",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: context.textPrimary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                maxLines: 4,
                style: TextStyle(color: context.textPrimary, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: "Enter updated comment...",
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Get.back,
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () async {
                      await controller.updateComment(comment.id, textController.text.trim());
                      Get.back();
                    },
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}