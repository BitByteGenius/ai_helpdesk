import 'package:flutter/material.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/tickets/admin_d/admin_panel.dart';
import 'package:frontend/screens/tickets/user_d/user_panel.dart';
import 'package:frontend/screens/tickets/widgets/attachment_section.dart';
import 'package:frontend/screens/tickets/widgets/comment_input.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';
import 'package:frontend/screens/tickets/widgets/comments_section.dart';
import 'package:frontend/screens/tickets/widgets/ticket_header.dart';
import 'package:get/get.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  late final CommentController _commentController;
  late final TicketController _ticketController;
  late final AuthController _authController;
  late final SocketController _socketController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _commentController = Get.find<CommentController>();
    _ticketController = Get.find<TicketController>();
    _authController = Get.find<AuthController>();
    _socketController = Get.find<SocketController>();

    // Defer data fetching and socket setup to after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load comments and ticket details
      _commentController.loadComments(widget.ticketId);
      _ticketController.getTicket(widget.ticketId);

      // Join socket room and listen for updates
      _socketController.joinTicketRoom(widget.ticketId);
      _socketController.onTicketUpdated(_handleTicketUpdated);

      // Fetch audits for admin users
      if (_authController.user?.role == 'admin') {
  Get.find<AuditController>().fetchTicketAudits(widget.ticketId);
}
    });
  }

  void _handleTicketUpdated(dynamic data) {
    if (!mounted) return;
    final payload = data is Map<String, dynamic>
        ? data
        : Map<String, dynamic>.from(data as Map);

    if (payload["ticketId"]?.toString() == widget.ticketId) {
      _ticketController.getTicket(widget.ticketId);

      if (_authController.user?.role == 'admin') {
        Get.find<AuditController>().fetchTicketAudits(widget.ticketId);
      }
    }
  }

  @override
  void dispose() {
    _socketController.leaveTicketRoom(widget.ticketId);
    _socketController.remove("ticket:update");
    _socketController.remove("ticket:updated");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
    final isAdmin = _authController.user?.role == 'admin';

  final mainContent = Column(
    children: [
      Expanded(
        child: Obx(() {
          if (_ticketController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final ticket = _ticketController.selectedTicket.value;

          if (ticket == null) {
            return const Center(
              child: Text(
                "Could not retrieve ticket details.",
              ),
            );
          }

          return Scrollbar(
            child: SingleChildScrollView(
              controller: _commentController.scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  TicketHeader(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 20),

                  /// Attachments
                  AttachmentSection(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 20),

                  /// Admin/User Panel
                  if (isAdmin)
                    AdminPanel(
                      ticket: ticket,
                    )
                  else
                    UserPanel(
                      ticket: ticket,
                    ),

                  const SizedBox(height: 24),

                  /// Discussion
                  Text(
                    "Discussion Thread",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const CommentsSection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }),
      ),

      const Divider(height: 1),

      const CommentInput(),
    ],
  );

  return isAdmin
      ? AdminLayout(
          title: "Ticket Discussion",
          child: mainContent,
        )
      : UserLayout(
          title: "Ticket Discussion",
          padding: EdgeInsets.zero,
          child: mainContent,
        );
}
    }
