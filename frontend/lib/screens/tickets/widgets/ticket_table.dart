import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:intl/intl.dart';

import 'priority_chip.dart';
import 'ticket_status_chip.dart';

class TicketTable extends StatelessWidget {
  final List<TicketModel> tickets;

  final Function(TicketModel)? onView;
  final Function(TicketModel)? onDelete;

  const TicketTable({
    super.key,
    required this.tickets,
    this.onView,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: DataTable(
        headingRowHeight: 48,
        dataRowMinHeight: 56,
        dataRowMaxHeight: 68,
        columnSpacing: 24,
        horizontalMargin: 16,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: AppColors.textSecondary,
          letterSpacing: 0.2,
        ),
        columns: const [
          DataColumn(label: Text("TITLE")),
          DataColumn(label: Text("REQUESTER")),
          DataColumn(label: Text("ASSIGNED TO")),
          DataColumn(label: Text("STATUS")),
          DataColumn(label: Text("PRIORITY")),
          DataColumn(label: Text("CATEGORY")),
          DataColumn(label: Text("CREATED")),
          DataColumn(label: Text("ACTIONS")),
        ],
        rows: tickets.map((ticket) {
          return DataRow(
            cells: [
              // ── Title ──
              DataCell(
                SizedBox(
                  width: 220,
                  child: Text(
                    ticket.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              // ── Created By ──
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: AppColors.primarySubtle,
                      backgroundImage: ticket.createdBy.profileImage.isNotEmpty
                          ? NetworkImage(ticket.createdBy.profileImage)
                          : null,
                      child: ticket.createdBy.profileImage.isEmpty
                          ? Text(
                              ticket.createdBy.name.isNotEmpty
                                  ? ticket.createdBy.name[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      ticket.createdBy.name,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Assigned To ──
              DataCell(
                ticket.assignedTo == null
                    ? const Text(
                        "Unassigned",
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: AppColors.purple.withValues(alpha: 0.15),
                            backgroundImage: ticket.assignedTo!.profileImage.isNotEmpty
                                ? NetworkImage(ticket.assignedTo!.profileImage)
                                : null,
                            child: ticket.assignedTo!.profileImage.isEmpty
                                ? Text(
                                    ticket.assignedTo!.name.isNotEmpty
                                        ? ticket.assignedTo!.name[0].toUpperCase()
                                        : "?",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.purple,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ticket.assignedTo!.name,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
              ),

              // ── Status ──
              DataCell(
                TicketStatusChip(
                  status: ticket.status,
                ),
              ),

              // ── Priority ──
              DataCell(
                PriorityChip(
                  priority: ticket.priority,
                ),
              ),

              // ── Category ──
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // ── Created Date ──
              DataCell(
                Text(
                  DateFormat("dd MMM yyyy").format(ticket.createdAt),
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ),

              // ── Actions ──
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: "View Details",
                      onPressed: () => onView?.call(ticket),
                      icon: const Icon(
                        Icons.visibility_outlined,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    IconButton(
                      tooltip: "Delete Ticket",
                      onPressed: () => onDelete?.call(ticket),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}