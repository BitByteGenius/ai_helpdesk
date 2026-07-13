import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../controllers/ticket_controller.dart';
import '../../../../models/ticket_model.dart';

/// Expandable card showing AI-generated insights for a ticket.
///
/// Reactivity is handled by the parent screen's top-level Obx, which rebuilds
/// this component when the ticket data changes. We do not use an internal Obx
/// here to avoid GetX improper use crashes when reading non-observable parameters.
class AICopilotCard extends StatelessWidget {
  final TicketModel? ticket;

  const AICopilotCard({
    super.key,
    this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ticketController = Get.find<TicketController>();

    // Fallback to controller's active ticket if not passed
    final activeTicket = ticket ?? ticketController.selectedTicket.value;
    if (activeTicket == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
        ),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            Icons.smart_toy,
            color: theme.colorScheme.primary,
          ),
          title: Text(
            "AI Copilot Insights",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          childrenPadding: const EdgeInsets.all(20),
          children: [
            _item(
              theme,
              "AI Summary",
              activeTicket.aiSummary,
            ),
            _item(
              theme,
              "Suggested Root Cause",
              activeTicket.aiSuggestedRootCause,
            ),
            _item(
              theme,
              "Troubleshooting Attempted",
              activeTicket.aiTroubleshootingAttempted,
            ),
            _confidence(activeTicket),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text("Copy Reply"),
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: activeTicket.suggestedReply,
                        ),
                      );
                      Get.snackbar(
                        "Copied",
                        "AI Suggested reply copied to clipboard.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.chat, size: 16),
                    label: const Text("Transcript"),
                    onPressed: () => _showTranscript(context, activeTicket),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(ThemeData theme, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value.isNotEmpty ? value : "—",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _confidence(TicketModel activeTicket) {
    final confidence = activeTicket.aiConfidence.toLowerCase();
    Color color;

    switch (confidence) {
      case "high":
        color = Colors.green;
        break;
      case "medium":
        color = Colors.orange;
        break;
      default:
        color = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confidence",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: confidence == "high"
              ? 1.0
              : confidence == "medium"
                  ? .65
                  : .35,
          color: color,
          backgroundColor: color.withValues(alpha: 0.15),
          minHeight: 8,
          borderRadius: BorderRadius.circular(20),
        ),
        const SizedBox(height: 6),
        Text(
          activeTicket.aiConfidence,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showTranscript(BuildContext context, TicketModel activeTicket) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Conversation Transcript",
          ),
          content: SizedBox(
            width: 700,
            child: SingleChildScrollView(
              child: SelectableText(
                activeTicket.aiConversationTranscript.isNotEmpty
                    ? activeTicket.aiConversationTranscript
                    : "No transcript available.",
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}