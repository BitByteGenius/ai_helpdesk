import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TicketStatusChart extends StatelessWidget {
  final Map<String, int> statusData;

  const TicketStatusChart({
    super.key,
    required this.statusData,
  });

  Color _color(String status) {
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
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = statusData.values.fold<int>(0, (a, b) => a + b);

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
              "Ticket Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 55,
                        sectionsSpace: 2,
                        sections: statusData.entries.map((entry) {
                          final percent = total == 0
                              ? 0.0
                              : entry.value / total * 100;

                          return PieChartSectionData(
                            color: _color(entry.key),
                            value: entry.value.toDouble(),
                            title: "${percent.toStringAsFixed(0)}%",
                            radius: 65,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: ListView(
                      children: statusData.entries.map((entry) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: _color(entry.key),
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Text(entry.key),
                              ),

                              Text(
                                entry.value.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}