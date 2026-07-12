import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PriorityChart extends StatelessWidget {
  final Map<String, int> priorityData;

  const PriorityChart({
    super.key,
    required this.priorityData,
  });

  Color _color(String priority) {
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

  @override
  Widget build(BuildContext context) {
    final priorities = [
      "Low",
      "Medium",
      "High",
      "Critical",
    ];

    final maxValue = priorityData.values.isEmpty
        ? 5
        : priorityData.values.reduce((a, b) => a > b ? a : b);

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
              "Priority Distribution",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: (maxValue + 5).toDouble(),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 35,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= priorities.length) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              priorities[value.toInt()],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(
                    priorities.length,
                    (index) {
                      final label = priorities[index];
                      final value =
                          priorityData[label] ?? 0;

                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: value.toDouble(),
                            width: 28,
                            color: _color(label),
                            borderRadius:
                                BorderRadius.circular(6),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}