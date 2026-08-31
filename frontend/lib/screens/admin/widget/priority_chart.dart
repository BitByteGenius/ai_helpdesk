import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PriorityChart extends StatelessWidget {
  final Map<String, int> priorityData;

  const PriorityChart({
    super.key,
    required this.priorityData,
  });

  Color _color(String priority) {
    switch (priority.toLowerCase()) {
      case "critical":
        return AppColors.error;
      case "high":
        return const Color(0xFFF97316); // Orange
      case "medium":
        return AppColors.warning;
      case "low":
        return AppColors.success;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    const priorities = ["Low", "Medium", "High", "Critical"];

    final maxValue = priorityData.values.isEmpty
        ? 5
        : priorityData.values.reduce((a, b) => a > b ? a : b);

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
          Text(
            "Priority Distribution",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: context.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: (maxValue == 0 ? 5 : maxValue + 2).toDouble(),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxValue > 10 ? 5 : 2,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: context.border.withValues(alpha: 0.7),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (val, meta) => Text(
                        val.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
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
                    final value = priorityData[label] ?? 0;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value.toDouble(),
                          width: 24,
                          color: _color(label),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
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
    );
  }
}