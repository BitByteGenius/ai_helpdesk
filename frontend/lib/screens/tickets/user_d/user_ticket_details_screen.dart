import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:get/get.dart';

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
  State<UserTicketDetailsScreen> createState() => _UserTicketDetailsScreenState();
}

class _UserTicketDetailsScreenState extends State<UserTicketDetailsScreen> {
  late final TicketController ticketController;
  late final CommentController commentController;
  late final SocketController socketController;

  final ScrollController scrollController = ScrollController();

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
      final data = payload is Map<String, dynamic> ? payload : Map<String, dynamic>.from(payload);

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
    return UserLayout(
      title: "Ticket Details",
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          tooltip: 'Refresh',
          onPressed: _refresh,
        ),
        const SizedBox(width: 8),
      ],
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
                  Icons.error_outline_rounded,
                  size: 56,
                  color: AppColors.error,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Unable to load ticket details.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

              return SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Ticket Header ──
                        TicketHeader(ticket: ticket),

                        const SizedBox(height: 20),

                        // ── Attachments ──
                        AttachmentSection(ticket: ticket),

                        if (ticket.attachments.isNotEmpty) const SizedBox(height: 20),

                        // ── User Information Panel ──
                        UserPanel(ticket: ticket),

                        const SizedBox(height: 24),

                        const Text(
                          "Discussion & Activity",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const CommentsSection(),

                        const SizedBox(height: 16),

                        const CommentInput(),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}