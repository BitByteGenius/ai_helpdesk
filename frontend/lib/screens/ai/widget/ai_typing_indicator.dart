import 'package:flutter/material.dart';

class AITypingIndicator extends StatelessWidget {
  const AITypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 12),
          Text("AI is thinking..."),
        ],
      ),
    );
  }
}