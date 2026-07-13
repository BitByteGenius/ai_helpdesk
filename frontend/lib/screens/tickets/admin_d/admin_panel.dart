import 'package:flutter/material.dart';
import 'package:frontend/controllers/audit_controller.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:frontend/screens/tickets/widgets/admin_actions_card.dart';
import 'package:frontend/screens/tickets/widgets/ai_copilot_card.dart';
import 'package:frontend/screens/tickets/widgets/audit_timeline_card.dart';
import 'package:get/get.dart';



class AdminPanel extends StatelessWidget {
  final TicketModel ticket;

  const AdminPanel({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final auditController = Get.find<AuditController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Admin Actions
        AdminActionsCard(
          ticket: ticket,
        ),

        const SizedBox(height: 20),

        /// AI Copilot
        AICopilotCard(
          ticket: ticket,
        ),

        const SizedBox(height: 20),

        /// Audit Timeline
        Obx(
          () => AuditTimelineCard(
            audits: auditController.ticketAudits,
          ),
        ),
      ],
    );
  }
}