import 'package:flutter/material.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/tickets/widgets/comment_bubble.dart';
import 'package:frontend/screens/tickets/widgets/comment_input.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/comment_controller.dart';


class TicketDetailsScreen
    extends GetView<CommentController> {
  final String ticketId;

  const TicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    controller.loadComments(ticketId);

    final auth = Get.find<AuthController>();

    return UserLayout(
      title: 'Ticket Discussion',
      child: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                controller:
                    controller.scrollController,
                padding:
                    const EdgeInsets.all(15),
                itemCount:
                    controller.comments.length,
                itemBuilder: (_, index) {
                  final comment =
                      controller.comments[index];

                  final isMine =
                      comment.user.id ==
                          auth.user?.id;

                  return CommentBubble(
                    comment: comment,
                    isMine: isMine,
                  );
                },
              );
            }),
          ),

          const Divider(height: 1),

          const CommentInput(),
        ],
      ),
    );
  }
}
