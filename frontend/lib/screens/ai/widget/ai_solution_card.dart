import 'package:flutter/material.dart';
import 'package:frontend/models/ai_model/ai_chat_model.dart';


class AISolutionCard extends StatelessWidget {
  final AIChatModel response;

  const AISolutionCard({
    super.key,
    required this.response,
  });

  Widget buildChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(.15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text(
              "🤖 AI Analysis",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Wrap(
              spacing: 10,
              children: [

                buildChip(
                  response.category,
                  Colors.blue,
                ),

                buildChip(
                  response.priority,
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              response.summary,
            ),

            const SizedBox(height: 20),

            const Text(
              "Suggested Solution",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(response.reply),
          ],
        ),
      ),
    );
  }
}