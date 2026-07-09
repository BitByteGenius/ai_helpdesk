class AIMessageModel {
  final String message;
  final bool isUser;
  final DateTime time;

  AIMessageModel({
    required this.message,
    required this.isUser,
    required this.time,
  });
}