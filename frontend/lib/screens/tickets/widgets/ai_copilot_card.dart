import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:get/get.dart';
import '../../../../controllers/ticket_controller.dart';
import '../../../../models/ticket_model.dart';

class AICopilotCard extends StatelessWidget {
  final TicketModel? ticket;

  const AICopilotCard({
    super.key,
    this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final ticketController = Get.find<TicketController>();

    final activeTicket = ticket ?? ticketController.selectedTicket.value;
    if (activeTicket == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          title: const Text(
            "AI Copilot Insights",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            const Divider(color: AppColors.borderLight, height: 1),
            const SizedBox(height: 16),
            _item(
              "AI Summary",
              activeTicket.aiSummary,
            ),
            _item(
              "Suggested Root Cause",
              activeTicket.aiSuggestedRootCause,
            ),
            _item(
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text("Copy Reply", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text("Transcript", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
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

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : "—",
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.4,
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
        color = AppColors.success;
        break;
      case "medium":
        color = AppColors.warning;
        break;
      default:
        color = AppColors.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Confidence Score",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: confidence == "high"
              ? 1.0
              : confidence == "medium"
                  ? .65
                  : .35,
          color: color,
          backgroundColor: color.withValues(alpha: 0.15),
          minHeight: 6,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 6),
        Text(
          activeTicket.aiConfidence.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 11,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Conversation Transcript",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: SelectableText(
                activeTicket.aiConversationTranscript.isNotEmpty
                    ? activeTicket.aiConversationTranscript
                    : "No transcript available.",
                style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textPrimary),
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