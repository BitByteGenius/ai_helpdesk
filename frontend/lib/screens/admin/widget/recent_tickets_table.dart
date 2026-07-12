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
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recent Tickets",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (tickets.isEmpty)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "No Tickets Found",
                  ),
                ),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 28,
                  headingRowHeight: 55,
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 70,
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
                            width: 220,
                            child: Text(
                              ticket.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),

                        DataCell(
                          Text(ticket.createdBy.name),
                        ),

                        DataCell(
                          Text(ticket.category),
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
                            DateFormat(
                              "dd MMM yyyy",
                            ).format(ticket.createdAt),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}