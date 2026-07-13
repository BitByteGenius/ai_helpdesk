import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:frontend/layouts/user_layout.dart';

import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';

import 'package:frontend/screens/tickets/user_d/user_panel.dart';

import 'package:frontend/screens/tickets/widgets/attachment_section.dart';
import 'package:frontend/screens/tickets/widgets/comment_input.dart';
import 'package:frontend/screens/tickets/widgets/comments_section.dart';
import 'package:frontend/screens/tickets/widgets/ticket_header.dart';

class UserTicketDetailsScreen extends StatefulWidget {
  final String ticketId;

  const UserTicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<UserTicketDetailsScreen> createState() =>
      _UserTicketDetailsScreenState();
}

class _UserTicketDetailsScreenState
    extends State<UserTicketDetailsScreen> {
  late final TicketController ticketController;
  late final CommentController commentController;
  late final SocketController socketController;

  final ScrollController scrollController =
      ScrollController();

  @override
  void initState() {
    super.initState();

    ticketController = Get.find<TicketController>();
    commentController = Get.find<CommentController>();
    socketController = Get.find<SocketController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _load();

      socketController.joinTicketRoom(widget.ticketId);
      socketController.onTicketUpdated(_onTicketUpdated);
    });
  }

  Future<void> _load() async {
    await Future.wait([
      ticketController.getTicket(widget.ticketId),
      commentController.loadComments(widget.ticketId),
    ]);
  }

  void _onTicketUpdated(dynamic payload) {
    if (!mounted) return;

    try {
      final data = payload is Map<String, dynamic>
          ? payload
          : Map<String, dynamic>.from(payload);

      if (data["ticketId"]?.toString() != widget.ticketId) {
        return;
      }

      _load();
    } catch (_) {}
  }

  Future<void> _refresh() async {
    await _load();
  }

  @override
  void dispose() {
    socketController.leaveTicketRoom(widget.ticketId);

    socketController.remove("ticket:update");
    socketController.remove("ticket:updated");

    scrollController.dispose();

    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return UserLayout(
      title: "My Ticket",
      padding: EdgeInsets.zero,
      child: Obx(() {
        if (ticketController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final ticket = ticketController.selectedTicket.value;

        if (ticket == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 72,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Unable to load ticket.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// Ticket Header
                      TicketHeader(
                        ticket: ticket,
                      ),

                      const SizedBox(height: 20),

                      /// Attachments
                      AttachmentSection(
                        ticket: ticket,
                      ),

                      const SizedBox(height: 20),

                      /// User Information Panel
                      UserPanel(
                        ticket: ticket,
                      ),

                      const SizedBox(height: 28),

                      Text(
                        "Discussion",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 14),

                      const CommentsSection(),

                      const SizedBox(height: 20),

                      const CommentInput(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}