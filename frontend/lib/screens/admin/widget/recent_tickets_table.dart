import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/ticket_model.dart';

class RecentTicketsTable extends StatelessWidget {
  final List<TicketModel> tickets;

  const RecentTicketsTable({
    super.key,
    required this.tickets,
  });

  Color _statusColor(String status) {
    switch (status) {
      case "Open":
        return Colors.orange;
      case "Assigned":
        return Colors.blue;
      case "In Progress":
        return Colors.purple;
      case "Resolved":
        return Colors.green;
      case "Closed":
        return Colors.grey;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.black54;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case "Critical":
        return Colors.red;
      case "High":
        return Colors.orange;
      case "Medium":
        return Colors.amber;
      case "Low":
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Tickets",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                if (tickets.isNotEmpty)
                  Text(
                    "${tickets.length} total",
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Empty State
            if (tickets.isEmpty)
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "No Tickets Found",
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              // Scrollable Responsive Container
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      // Ensures table spreads out properly on desktop but stays scrollable on small mobile
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth > 800 ? constraints.maxWidth : 800,
                      ),
                      child: Theme(
                        data: theme.copyWith(
                          dividerColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                        ),
                        child: DataTable(
                          columnSpacing: 24,
                          headingRowHeight: 48,
                          dataRowMinHeight: 56,
                          dataRowMaxHeight: 68,
                          horizontalMargin: 8,
                          headingTextStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          columns: const [
                            DataColumn(label: Text("Title")),
                            DataColumn(label: Text("User")),
                            DataColumn(label: Text("Category")),
                            DataColumn(label: Text("Priority")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Created")),
                          ],
                          rows: tickets.map((ticket) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      ticket.title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    ticket.createdBy.name,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    ticket.category,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  _badge(
                                    ticket.priority,
                                    _priorityColor(ticket.priority),
                                  ),
                                ),
                                DataCell(
                                  _badge(
                                    ticket.status,
                                    _statusColor(ticket.status),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    DateFormat("dd MMM yyyy").format(ticket.createdAt),
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}