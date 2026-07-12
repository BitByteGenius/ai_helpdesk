import 'package:frontend/models/ticket_model.dart';
import 'package:frontend/models/user_model.dart';

class DashboardModel {
  final DashboardStats stats;
  final Map<String, int> ticketStatus;
  final Map<String, int> priority;
  final List<TicketModel> recentTickets;
  final List<UserModel> recentUsers;
  final AiInsights aiInsights;

  DashboardModel({
    required this.stats,
    required this.ticketStatus,
    required this.priority,
    required this.recentTickets,
    required this.recentUsers,
    required this.aiInsights,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      stats: DashboardStats.fromJson(json["stats"] ?? {}),

      ticketStatus:
          Map<String, int>.from(json["ticketStatus"] ?? {}),

      priority:
          Map<String, int>.from(json["priority"] ?? {}),

      recentTickets:
          (json["recentTickets"] as List? ?? [])
              .map((e) => TicketModel.fromJson(e))
              .toList(),

      recentUsers:
          (json["recentUsers"] as List? ?? [])
              .map((e) => UserModel.fromJson(e))
              .toList(),

      aiInsights:
          AiInsights.fromJson(json["aiInsights"] ?? {}),
    );
  }
}

class DashboardStats {
  final int totalTickets;
  final int open;
  final int resolved;
  final int users;

  DashboardStats({
    required this.totalTickets,
    required this.open,
    required this.resolved,
    required this.users,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalTickets: json["totalTickets"] ?? 0,
      open: json["open"] ?? 0,
      resolved: json["resolved"] ?? 0,
      users: json["users"] ?? 0,
    );
  }
}

class AiInsights {
  final int totalAnalysis;
  final int duplicates;
  final int suggestedReplies;

  AiInsights({
    required this.totalAnalysis,
    required this.duplicates,
    required this.suggestedReplies,
  });

  factory AiInsights.fromJson(Map<String, dynamic> json) {
    return AiInsights(
      totalAnalysis: json["totalAnalysis"] ?? 0,
      duplicates: json["duplicates"] ?? 0,
      suggestedReplies: json["suggestedReplies"] ?? 0,
    );
  }
}