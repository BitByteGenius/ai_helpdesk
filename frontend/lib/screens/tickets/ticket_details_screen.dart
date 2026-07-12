import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/layouts/admin_layout.dart';
import 'package:frontend/layouts/user_layout.dart';
import 'package:frontend/screens/tickets/widgets/comment_bubble.dart';
import 'package:frontend/screens/tickets/widgets/comment_input.dart';
import 'package:frontend/screens/ai/widget/ai_message_bubble.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/comment_controller.dart';
import 'package:frontend/controllers/ticket_controller.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:frontend/models/ai_model/chat_message_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    _commentController = Get.find<CommentController>();
    _ticketController = Get.find<TicketController>();
    _authController = Get.find<AuthController>();

    // Fetch ticket details and comment thread on init
    _commentController.loadComments(widget.ticketId);
    _ticketController.getTicket(widget.ticketId);

    // Fetch audits if current user is admin
    if (_authController.user?.role == 'admin') {
      Get.find<AuditController>().fetchTicketAudits(widget.ticketId);
    }
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
              return const Center(child: CircularProgressIndicator());
            }

            final ticket = _ticketController.selectedTicket.value;
            if (ticket == null) {
              return const Center(child: Text("Could not retrieve ticket details."));
            }

            return Scrollbar(
              child: SingleChildScrollView(
                controller: _commentController.scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTicketDetailsHeader(ticket, theme),
                    _buildAttachmentsSection(ticket, theme),
                    const SizedBox(height: 16),
                    if (isAdmin) ...[
                      _buildAICopilotInsights(context, ticket, theme),
                      const SizedBox(height: 16),
                      _buildAuditTimelineSection(theme),
                    ],
                    const Divider(height: 32),
                    Text(
                      "Discussion Thread",
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildCommentsList(_commentController, _authController),
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

    if (isAdmin) {
      return AdminLayout(
        title: 'Ticket Discussion',
        child: mainContent,
      );
    } else {
      return UserLayout(
        title: 'Ticket Discussion',
        child: mainContent,
      );
    }
  }

  Widget _buildTicketDetailsHeader(TicketModel ticket, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ticket #${ticket.id.substring(ticket.id.length - 6).toUpperCase()}",
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Row(
                  children: [
                    _buildChip(ticket.category, Colors.blue),
                    const SizedBox(width: 6),
                    _buildChip(ticket.priority, _getPriorityColor(ticket.priority)),
                    const SizedBox(width: 6),
                    _buildChip(ticket.status, _getStatusColor(ticket.status)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ticket.title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildUserTile(
                    label: "Created By",
                    name: ticket.createdBy.name,
                    email: ticket.createdBy.email,
                    avatarUrl: ticket.createdBy.profileImage,
                  ),
                ),
                Expanded(
                  child: _buildUserTile(
                    label: "Assigned To",
                    name: ticket.assignedTo?.name ?? "Unassigned",
                    email: ticket.assignedTo?.email ?? "No agent assigned",
                    avatarUrl: ticket.assignedTo?.profileImage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection(TicketModel ticket, ThemeData theme) {
    if (ticket.attachments.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Attachments",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ticket.attachments.map((attachment) {
            return InkWell(
              onTap: () async {
                if (attachment.url.isNotEmpty) {
                  final uri = Uri.tryParse(attachment.url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    Get.snackbar("Error", "Could not open attachment url");
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.insert_drive_file_outlined, size: 16),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        attachment.fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.underline,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
      default:
        return Colors.green;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.green;
      case 'assigned':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'resolved':
        return Colors.teal;
      case 'closed':
      default:
        return Colors.grey;
    }
  }

  Widget _buildUserTile({
    required String label,
    required String name,
    required String email,
    String? avatarUrl,
  }) {
    final theme = Theme.of(context);
    final bool hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: theme.colorScheme.secondaryContainer,
          backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
          child: !hasAvatar
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: theme.colorScheme.onSecondaryContainer),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 10),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.colorScheme.outline),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAICopilotInsights(BuildContext context, TicketModel ticket, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      color: theme.colorScheme.primaryContainer.withOpacity(0.2),
      child: ExpansionTile(
        leading: Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
        title: Text(
          "AI Support Copilot Insights",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInsightRow("Confidence Level", ticket.aiConfidence, isBadge: true),
                const SizedBox(height: 12),
                _buildInsightRow("AI Summary", ticket.aiSummary),
                const SizedBox(height: 12),
                _buildInsightRow("Suggested Root Cause", ticket.aiSuggestedRootCause),
                const SizedBox(height: 12),
                _buildInsightRow("Troubleshooting Attempted", ticket.aiTroubleshootingAttempted),
                const SizedBox(height: 12),
                if (ticket.suggestedReply.isNotEmpty) ...[
                  _buildInsightRow("AI Suggested Reply", ticket.suggestedReply, copyText: ticket.suggestedReply),
                  const SizedBox(height: 12),
                ],
                if (ticket.aiConversationTranscript.isNotEmpty) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showTranscriptDialog(context, ticket.aiConversationTranscript),
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text("View Full Chat Transcript"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightRow(String label, String value, {bool isBadge = false, String? copyText}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (copyText != null)
              IconButton(
                icon: const Icon(Icons.copy_all_outlined, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: copyText));
                  Get.snackbar(
                    "Copied",
                    "Suggested reply copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: theme.colorScheme.inverseSurface,
                    colorText: theme.colorScheme.onInverseSurface,
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 4),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _getConfidenceColor(value).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getConfidenceColor(value)),
            ),
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getConfidenceColor(value),
              ),
            ),
          )
        else
          Text(
            value.isNotEmpty ? value : "Not available",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
      ],
    );
  }

  Color _getConfidenceColor(String confidence) {
    switch (confidence.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
      default:
        return Colors.red;
    }
  }

  List<ChatMessageModel> _parseTranscript(String transcript) {
    final List<ChatMessageModel> parsed = [];
    final blocks = transcript.split("\n\n");
    for (final block in blocks) {
      if (block.startsWith("User: ")) {
        parsed.add(ChatMessageModel(
          id: UniqueKey().toString(),
          role: "user",
          message: block.substring("User: ".length).trim(),
          createdAt: DateTime.now(),
        ));
      } else if (block.startsWith("AI Assistant: ")) {
        parsed.add(ChatMessageModel(
          id: UniqueKey().toString(),
          role: "assistant",
          message: block.substring("AI Assistant: ".length).trim(),
          createdAt: DateTime.now(),
        ));
      }
    }
    return parsed;
  }

  void _showTranscriptDialog(BuildContext context, String transcript) {
    final parsedMessages = _parseTranscript(transcript);
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "Escalated Conversation Transcript",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: parsedMessages.isEmpty
                    ? SingleChildScrollView(child: SelectionArea(child: Text(transcript)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: parsedMessages.length,
                        itemBuilder: (_, index) {
                          return AIMessageBubble(
                            message: parsedMessages[index],
                            isLast: index == parsedMessages.length - 1,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuditTimelineSection(ThemeData theme) {
    final auditController = Get.find<AuditController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        Text(
          "Audit Timeline",
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (auditController.isLoadingTicketAudits.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (auditController.ticketAudits.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text("No audit records found for this ticket."),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: auditController.ticketAudits.length,
            itemBuilder: (_, index) {
              final audit = auditController.ticketAudits[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.history_toggle_off, size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            audit.description,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "By ${audit.user.name.isNotEmpty ? audit.user.name : 'System'} • ${audit.createdAt.toLocal().toString().substring(0, 16)}",
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildCommentsList(CommentController controller, AuthController auth) {
    if (controller.comments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text("No discussions yet. Start the conversation below!"),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.comments.length,
      itemBuilder: (_, index) {
        final comment = controller.comments[index];
        final isMine = comment.user.id == auth.user?.id;
        return CommentBubble(
          comment: comment,
          isMine: isMine,
        );
      },
    );
  }
}
