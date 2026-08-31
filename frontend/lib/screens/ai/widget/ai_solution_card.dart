import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ai_model/ai_chat_model.dart';
import 'package:frontend/screens/tickets/widgets/priority_chip.dart';
import 'package:frontend/screens/tickets/widgets/ticket_status_chip.dart';

class AISolutionCard extends StatelessWidget {
  final AIChatModel response;

  const AISolutionCard({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: context.primarySubtle,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.auto_awesome_rounded, size: 16, color: context.primaryColor),
              ),
              const SizedBox(width: 10),
              Text(
                "AI Analysis",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TicketStatusChip(status: response.category),
              PriorityChip(priority: response.priority),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            response.aiSummary,
            style: TextStyle(
              fontSize: 13,
              color: context.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: context.borderLight),
          const SizedBox(height: 14),
          Text(
            "Suggested Solution",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            response.reply,
            style: TextStyle(
              fontSize: 13,
              color: context.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
