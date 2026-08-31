import 'package:flutter/material.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecentTicketsTable extends StatelessWidget {
  final List<TicketModel> tickets;

  const RecentTicketsTable({
    super.key,
    required this.tickets,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "open":
        return AppColors.warning;
      case "assigned":
        return AppColors.info;
      case "in progress":
        return AppColors.purple;
      case "resolved":
        return AppColors.success;
      case "closed":
        return const Color(0xFF64748B);
      case "rejected":
        return AppColors.error;
      default:
        return AppColors.secondary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "critical":
        return AppColors.error;
      case "high":
        return const Color(0xFFF97316);
      case "medium":
        return AppColors.warning;
      case "low":
        return AppColors.success;
      default:
        return AppColors.secondary;
    }
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Tickets",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              if (tickets.isNotEmpty)
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.tickets),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("View All", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 14),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (tickets.isEmpty)
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  "No tickets found",
                  style: TextStyle(color: context.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth > 700 ? constraints.maxWidth : 700,
                    ),
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowHeight: 40,
                      dataRowMinHeight: 52,
                      dataRowMaxHeight: 60,
                      horizontalMargin: 0,
                      headingTextStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: context.textSecondary,
                        letterSpacing: 0.2,
                      ),
                      columns: const [
                        DataColumn(label: Text("TITLE")),
                        DataColumn(label: Text("REQUESTER")),
                        DataColumn(label: Text("CATEGORY")),
                        DataColumn(label: Text("PRIORITY")),
                        DataColumn(label: Text("STATUS")),
                        DataColumn(label: Text("DATE")),
                      ],
                      rows: tickets.map((ticket) {
                        return DataRow(
                          cells: [
                            DataCell(
                              SizedBox(
                                width: 180,
                                child: Text(
                                  ticket.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: context.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                ticket.createdBy.name,
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: context.surfaceSubtle,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  ticket.category,
                                  style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(_badge(ticket.priority, _priorityColor(ticket.priority))),
                            DataCell(_badge(ticket.status, _statusColor(ticket.status))),
                            DataCell(
                              Text(
                                DateFormat("dd MMM yyyy").format(ticket.createdAt),
                                style: TextStyle(
                                  color: context.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}