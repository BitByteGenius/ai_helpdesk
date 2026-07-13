class AIChatModel {
  final String reply;
  final String category;
  final String priority;
  final String aiSummary;
  final bool duplicate;
  final bool createTicket;
  final List<dynamic> articles;

  AIChatModel({
    required this.reply,
    required this.category,
    required this.priority,
    required this.aiSummary,
    required this.duplicate,
    required this.createTicket,
    required this.articles,
  });

  factory AIChatModel.fromJson(
      Map<String, dynamic> json) {
    return AIChatModel(
      reply: json["reply"] ?? "",
      category: json["category"] ?? "",
      priority: json["priority"] ?? "",
      aiSummary: json["aiSummary"] ?? "",
      duplicate: json["duplicate"] ?? false,
      createTicket: json["createTicket"] ?? false,
      articles: json["articles"] ?? [],
    );
  }
}