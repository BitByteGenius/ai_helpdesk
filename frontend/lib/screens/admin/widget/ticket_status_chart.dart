import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class TicketStatusChart extends StatelessWidget {
  final Map<String, int> statusData;

  const TicketStatusChart({
    super.key,
    required this.statusData,
  });

  Color _color(String status) {
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

  @override
  Widget build(BuildContext context) {
    final total = statusData.values.fold<int>(0, (a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ticket Status",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: context.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.primarySubtle,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$total Total",
                  style: TextStyle(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (total == 0)
            Expanded(
              child: Center(
                child: Text(
                  "No ticket data available",
                  style: TextStyle(color: context.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            centerSpaceRadius: 48,
                            sectionsSpace: 3,
                            sections: statusData.entries.map((entry) {
                              final percent = total == 0 ? 0.0 : entry.value / total * 100;
                              return PieChartSectionData(
                                color: _color(entry.key),
                                value: entry.value.toDouble(),
                                title: percent >= 8 ? "${percent.toStringAsFixed(0)}%" : "",
                                radius: 46,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$total",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: context.textPrimary,
                              ),
                            ),
                            Text(
                              "Tickets",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: context.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ListView(
                      shrinkWrap: true,
                      children: statusData.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _color(entry.key),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: context.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}