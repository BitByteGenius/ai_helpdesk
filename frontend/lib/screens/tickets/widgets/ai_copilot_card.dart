import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/models/ticket_model.dart';

class AICopilotCard extends StatelessWidget {
  final TicketModel ticket;

  const AICopilotCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .3),
        ),
      ),
      child: ExpansionTile(
        leading: Icon(
          Icons.smart_toy,
          color: theme.colorScheme.primary,
        ),
        title: const Text(
          "AI Copilot Insights",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        childrenPadding: const EdgeInsets.all(20),
        children: [

          _item(
            "AI Summary",
            ticket.aiSummary,
          ),

          _item(
            "Suggested Root Cause",
            ticket.aiSuggestedRootCause,
          ),

          _item(
            "Troubleshooting Attempted",
            ticket.aiTroubleshootingAttempted,
          ),

          _confidence(),

          const SizedBox(height: 20),

          Row(
            children: [

              Expanded(
                child: FilledButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text("Copy Reply"),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: ticket.suggestedReply,
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Copied"),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text("Transcript"),
                  onPressed: () => _showTranscript(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(value),
        ],
      ),
    );
  }

  Widget _confidence() {
    final confidence =
        (ticket.aiConfidence.toLowerCase());

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
              ? 1
              : confidence == "medium"
                  ? .65
                  : .35,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(20),
        ),

        const SizedBox(height: 6),

        Text(
          ticket.aiConfidence,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showTranscript(BuildContext context) {
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
                ticket.aiConversationTranscript,
                ),
            ),
          ),
          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}