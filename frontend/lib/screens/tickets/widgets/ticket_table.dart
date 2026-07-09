import 'package:flutter/material.dart';
import 'package:frontend/models/ticket_model.dart';

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
      child: DataTable(
        headingRowHeight: 60,
        dataRowMinHeight: 70,
        dataRowMaxHeight: 90,
        columnSpacing: 30,
        horizontalMargin: 20,

        columns: const [
          DataColumn(label: Text("Title")),
          DataColumn(label: Text("Created By")),
          DataColumn(label: Text("Assigned To")),
          DataColumn(label: Text("Status")),
          DataColumn(label: Text("Priority")),
          DataColumn(label: Text("Category")),
          DataColumn(label: Text("Created")),
          DataColumn(label: Text("Actions")),
        ],

        rows: tickets.map((ticket) {
          return DataRow(
            cells: [

              /// Title
              DataCell(
                SizedBox(
                  width: 220,
                  child: Text(
                    ticket.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),

              /// Created By
              DataCell(
                Row(
                  children: [

                    CircleAvatar(
                      radius: 16,
                      backgroundImage:
                          ticket.createdBy.profileImage.isNotEmpty
                              ? NetworkImage(
                                  ticket.createdBy.profileImage,
                                )
                              : null,
                      child:
                          ticket.createdBy.profileImage.isEmpty
                              ? Text(
                                  ticket.createdBy.name[0],
                                )
                              : null,
                    ),

                    const SizedBox(width: 10),

                    Text(ticket.createdBy.name),
                  ],
                ),
              ),

              /// Assigned To
              DataCell(
                ticket.assignedTo == null
                    ? const Text("-")
                    : Row(
                        children: [

                          CircleAvatar(
                            radius: 16,
                            backgroundImage: ticket
                                    .assignedTo!
                                    .profileImage
                                    .isNotEmpty
                                ? NetworkImage(
                                    ticket.assignedTo!.profileImage,
                                  )
                                : null,
                            child: ticket
                                    .assignedTo!
                                    .profileImage
                                    .isEmpty
                                ? Text(
                                    ticket.assignedTo!.name[0],
                                  )
                                : null,
                          ),

                          const SizedBox(width: 10),

                          Text(ticket.assignedTo!.name),
                        ],
                      ),
              ),

              /// Status
              DataCell(
                TicketStatusChip(
                  status: ticket.status,
                ),
              ),

              /// Priority
              DataCell(
                PriorityChip(
                  priority: ticket.priority,
                ),
              ),

              /// Category
              DataCell(
                Text(ticket.category),
              ),

              /// Created Date
              DataCell(
                Text(
                  "${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}",
                ),
              ),

              /// Actions
              DataCell(
                Row(
                  children: [

                    IconButton(
                      tooltip: "View",
                      onPressed: () => onView?.call(ticket),
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.blue,
                      ),
                    ),

                    IconButton(
                      tooltip: "Delete",
                      onPressed: () => onDelete?.call(ticket),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
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