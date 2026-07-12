import 'package:flutter/material.dart';
import 'package:frontend/models/ticket_model.dart';
import 'package:frontend/core/routes/app_routes.dart';
import 'package:get/get.dart';



class RecentTicketCard extends StatelessWidget {
  final TicketModel? ticket;

  const RecentTicketCard({
    super.key,
    this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final status = ticket?.status ?? "Open";
    final priority = ticket?.priority ?? "Medium";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          if (ticket != null) {
            Get.toNamed(
              AppRoutes.ticketDetails,
              arguments: ticket!.id,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  Expanded(
                    child: Text(
                      ticket?.title ??
                          "Unable to Login",
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  _statusChip(status),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                ticket?.description ??
                    "User cannot login after password reset.",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [

                  _priorityChip(priority),

                  const Spacer(),

                  Text(
                    ticket == null
                        ? "-"
                        : "${ticket!.createdAt.day}/${ticket!.createdAt.month}/${ticket!.createdAt.year}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color = Colors.blue;

    switch (status) {
      case "Open":
        color = Colors.orange;
        break;

      case "In Progress":
        color = Colors.deepPurple;
        break;

      case "Resolved":
        color = Colors.green;
        break;

      case "Closed":
        color = Colors.grey;
        break;
    }

    return Chip(
      backgroundColor:
          color.withValues(alpha: .15),
      label: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _priorityChip(String priority) {
    Color color = Colors.blue;

    switch (priority) {
      case "Low":
        color = Colors.green;
        break;

      case "Medium":
        color = Colors.orange;
        break;

      case "High":
        color = Colors.red;
        break;

      case "Critical":
        color = Colors.deepPurple;
        break;
    }

    return Chip(
      backgroundColor:
          color.withValues(alpha: .12),
      label: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
