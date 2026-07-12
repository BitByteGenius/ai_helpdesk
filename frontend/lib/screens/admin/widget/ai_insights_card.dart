import 'package:flutter/material.dart';
import '../../../models/dashboard_model.dart';

class AiInsightsCard extends StatelessWidget {
  final AiInsights insights;

  const AiInsightsCard({
    super.key,
    required this.insights,
  });

  Widget _metric({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: color.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: .15),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
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
              "AI Insights",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            LayoutBuilder(
              builder: (_, constraints) {

                if (constraints.maxWidth > 900) {

                  return Row(
                    children: [

                      _metric(
                        icon: Icons.smart_toy,
                        title: "AI Analyses",
                        value:
                            insights.totalAnalysis.toString(),
                        color: Colors.blue,
                      ),

                      const SizedBox(width: 16),

                      _metric(
                        icon: Icons.copy,
                        title: "Duplicate Tickets",
                        value:
                            insights.duplicates.toString(),
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 16),

                      _metric(
                        icon: Icons.auto_awesome,
                        title: "Suggested Replies",
                        value:
                            insights.suggestedReplies
                                .toString(),
                        color: Colors.green,
                      ),
                    ],
                  );
                }

                return Column(
                  children: [

                    _metric(
                      icon: Icons.smart_toy,
                      title: "AI Analyses",
                      value:
                          insights.totalAnalysis.toString(),
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 12),

                    _metric(
                      icon: Icons.copy,
                      title: "Duplicate Tickets",
                      value:
                          insights.duplicates.toString(),
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 12),

                    _metric(
                      icon: Icons.auto_awesome,
                      title: "Suggested Replies",
                      value:
                          insights.suggestedReplies.toString(),
                      color: Colors.green,
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
}