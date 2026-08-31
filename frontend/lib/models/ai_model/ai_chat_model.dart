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

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory AIChatModel.fromJson(Map<String, dynamic> json) {
    return AIChatModel(
      reply: _parseString(json["reply"]),
      category: _parseString(json["category"]),
      priority: _parseString(json["priority"]),
      aiSummary: _parseString(json["aiSummary"] ?? json["summary"]),
      duplicate: json["duplicate"] == true,
      createTicket: json["createTicket"] == true || json["canCreateTicket"] == true,
      articles: json["articles"] is List ? json["articles"] : [],
    );
  }
}