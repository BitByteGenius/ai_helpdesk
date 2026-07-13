import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/audit_model.dart';

class AuditTimelineCard extends StatelessWidget {
  final List<AuditModel> audits;

  const AuditTimelineCard({
    super.key,
    required this.audits,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Icon(
                  Icons.history,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  "Audit Timeline",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (audits.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No activity available."),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: audits.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  final audit = audits[index];

                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Column(
                        children: [

                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                _color(audit.action)
                                    .withValues(alpha: .15),
                            child: Icon(
                              _icon(audit.action),
                              color: _color(audit.action),
                              size: 18,
                            ),
                          ),

                          if (index != audits.length - 1)
                            Container(
                              width: 2,
                              height: 70,
                              color: Colors.grey.shade300,
                            ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              audit.action,
                              style: const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              audit.description,
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [

                                Icon(
                                  Icons.person,
                                  size: 14,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 4),

                                Expanded(
                                  child: Text(
                                    audit.user.name,
                                    style:
                                        const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                Text(
                                  DateFormat(
                                    "dd MMM yyyy • hh:mm a",
                                  ).format(
                                    audit.createdAt,
                                  ),
                                  style:
                                      const TextStyle(
                                    fontSize: 11,
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  IconData _icon(String action) {
    switch (action.toLowerCase()) {
      case "created":
        return Icons.add_circle;

      case "assigned":
        return Icons.assignment_ind;

      case "status changed":
        return Icons.sync_alt;

      case "resolved":
        return Icons.check_circle;

      case "closed":
        return Icons.lock;

      case "comment":
        return Icons.chat;

      case "ai_analysis":
        return Icons.smart_toy;

      default:
        return Icons.history;
    }
  }

  Color _color(String action) {
    switch (action.toLowerCase()) {
      case "created":
        return Colors.green;

      case "assigned":
        return Colors.blue;

      case "status changed":
        return Colors.orange;

      case "resolved":
        return Colors.teal;

      case "closed":
        return Colors.grey;

      case "comment":
        return Colors.indigo;

      case "ai_analysis":
        return Colors.deepPurple;

      default:
        return Colors.black54;
    }
  }
}