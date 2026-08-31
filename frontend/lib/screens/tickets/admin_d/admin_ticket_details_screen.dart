import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';

import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/chat_controller.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/controllers/socket_controller.dart';

import 'package:frontend/screens/tickets/widgets/admin_actions_card.dart';
import 'package:frontend/screens/tickets/widgets/ai_copilot_card.dart';
import 'package:frontend/screens/tickets/widgets/audit_timeline_card.dart';
import 'package:frontend/screens/tickets/widgets/ticket_header.dart';
import 'package:frontend/screens/tickets/widgets/attachment_section.dart';
import 'package:frontend/screens/tickets/widgets/chat_section_widget.dart';
import 'package:frontend/models/ticket_model.dart';

class AdminTicketDetailsScreen extends StatefulWidget {
  final String ticketId;

  const AdminTicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<AdminTicketDetailsScreen> createState() => _AdminTicketDetailsScreenState();
}

class _AdminTicketDetailsScreenState extends State<AdminTicketDetailsScreen> {
  late final TicketController ticketController;
  late final ChatController chatController;
  late final AuditController auditController;
  late final SocketController socketController;
  late final AuthController authController;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ticketController = Get.find<TicketController>();
    chatController = Get.find<ChatController>();
    auditController = Get.find<AuditController>();
    socketController = Get.find<SocketController>();
    authController = Get.find<AuthController>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadData();

      socketController.joinTicketRoom(widget.ticketId);
      socketController.onTicketUpdated(_onTicketUpdated);
    });
  }

  Future<void> _loadData() async {
    await Future.wait([
      ticketController.getTicket(widget.ticketId),
      chatController.loadMessages(widget.ticketId),
      auditController.fetchTicketAudits(widget.ticketId),
    ]);
  }

  void _onTicketUpdated(dynamic payload) {
    if (!mounted) return;

    try {
      final data = payload is Map<String, dynamic> ? payload : Map<String, dynamic>.from(payload);

      if (data["ticketId"]?.toString() != widget.ticketId) {
        return;
      }

      _loadData();
    } catch (_) {}
  }

  Future<void> _refresh() async {
    await _loadData();
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
    final ticketController = Get.find<TicketController>();
    final chatController = Get.find<ChatController>();
    final auditController = Get.find<AuditController>();

    return AdminLayout(
      title: "Ticket Details",
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 20),
          tooltip: 'Refresh',
          onPressed: _refresh,
        ),
        const SizedBox(width: 8),
      ],
      child: Stack(
        children: [
          Obx(() {
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
                    Text(
                      "Unable to load ticket details.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
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
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 1100;
                    final horizontalPadding = constraints.maxWidth >= 1200 ? 28.0 : 16.0;

                    return SingleChildScrollView(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1400),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Ticket Header ──
                              TicketHeader(ticket: ticket),

                              const SizedBox(height: 16),

                              // ── Responsive Layout ──
                              if (!isDesktop)
                                _buildMobileLayout(
                                  ticket,
                                  ticketController,
                                  chatController,
                                  auditController,
                                )
                              else
                                _buildDesktopLayout(
                                  ticket,
                                  ticketController,
                                  chatController,
                                  auditController,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),

          // Async Safety Loading Overlay
          Obx(() {
            final isUpdating = ticketController.isUpdating.value;
            if (isUpdating) {
              return Container(
                color: Colors.black.withValues(alpha: 0.35),
                child: Center(
                  child: Card(
                    elevation: 8,
                    color: context.cardBg,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            "Updating ticket status...",
                            style: TextStyle(fontWeight: FontWeight.w700, color: context.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(
    TicketModel ticket,
    TicketController ticketController,
    ChatController chatController,
    AuditController auditController,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Flex 7)
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AttachmentSection(ticket: ticket),
              if (ticket.attachments.isNotEmpty) const SizedBox(height: 16),
              AdminActionsCard(ticket: ticket),
              const SizedBox(height: 16),
              ChatSectionWidget(ticket: ticket),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Right Column (Flex 3)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AICopilotCard(ticket: ticket),
              const SizedBox(height: 16),
              _buildAuditTimeline(auditController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    TicketModel ticket,
    TicketController ticketController,
    ChatController chatController,
    AuditController auditController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AttachmentSection(ticket: ticket),
        if (ticket.attachments.isNotEmpty) const SizedBox(height: 16),
        AdminActionsCard(ticket: ticket),
        const SizedBox(height: 16),
        AICopilotCard(ticket: ticket),
        const SizedBox(height: 16),
        _buildAuditTimeline(auditController),
        const SizedBox(height: 16),
        ChatSectionWidget(ticket: ticket),
      ],
    );
  }

  Widget _buildAuditTimeline(AuditController auditController) {
    return Obx(() {
      if (auditController.isLoadingTicketAudits.value) {
        return Container(
          height: 120,
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      return AuditTimelineCard(
        audits: auditController.ticketAudits,
      );
    });
  }
}