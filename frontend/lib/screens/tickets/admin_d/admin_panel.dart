import 'package:flutter/material.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:frontend/screens/tickets/widgets/admin_actions_card.dart';

/// A thin layout wrapper whose only job is to render [AdminActionsCard].
///
/// This widget does NOT contain [AICopilotCard] or [AuditTimelineCard].
/// Those components live exclusively in the right-column (sidebar) of the
/// parent [AdminTicketDetailsScreen] to prevent layout duplication.
class AdminPanel extends StatelessWidget {
  final TicketModel ticket;

  const AdminPanel({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    // Pure pass-through — no Obx needed because `ticket` is already
    // provided reactively by the parent's Obx in AdminTicketDetailsScreen.
    return AdminActionsCard(
      ticket: ticket,
    );
  }
}