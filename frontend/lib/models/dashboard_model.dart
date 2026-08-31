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
    final ticketStatusMap = <String, int>{};
    final ticketStatusRaw = json["ticketStatus"] ?? json["status"];
    if (ticketStatusRaw is Map) {
      ticketStatusRaw.forEach((key, value) {
        ticketStatusMap[key.toString()] = int.tryParse(value.toString()) ?? 0;
      });
    }

    final priorityMap = <String, int>{};
    final priorityRaw = json["priority"];
    if (priorityRaw is Map) {
      priorityRaw.forEach((key, value) {
        priorityMap[key.toString()] = int.tryParse(value.toString()) ?? 0;
      });
    }

    final recentTicketsList = <TicketModel>[];
    final recentTicketsRaw = json["recentTickets"];
    if (recentTicketsRaw is List) {
      for (final item in recentTicketsRaw) {
        if (item is Map<String, dynamic>) {
          recentTicketsList.add(TicketModel.fromJson(item));
        } else if (item is Map) {
          recentTicketsList.add(TicketModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    final recentUsersList = <UserModel>[];
    final recentUsersRaw = json["recentUsers"];
    if (recentUsersRaw is List) {
      for (final item in recentUsersRaw) {
        if (item is Map<String, dynamic>) {
          recentUsersList.add(UserModel.fromJson(item));
        } else if (item is Map) {
          recentUsersList.add(UserModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    return DashboardModel(
      stats: DashboardStats.fromJson(
        json["stats"] is Map<String, dynamic>
            ? json["stats"]
            : (json["stats"] is Map ? Map<String, dynamic>.from(json["stats"]) : {}),
      ),
      ticketStatus: ticketStatusMap,
      priority: priorityMap,
      recentTickets: recentTicketsList,
      recentUsers: recentUsersList,
      aiInsights: AiInsights.fromJson(
        json["aiInsights"] is Map<String, dynamic>
            ? json["aiInsights"]
            : (json["aiInsights"] is Map ? Map<String, dynamic>.from(json["aiInsights"]) : {}),
      ),
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
      totalTickets: int.tryParse(json["totalTickets"]?.toString() ?? "0") ?? 0,
      open: int.tryParse(json["open"]?.toString() ?? "0") ?? 0,
      resolved: int.tryParse(json["resolved"]?.toString() ?? "0") ?? 0,
      users: int.tryParse(json["users"]?.toString() ?? "0") ?? 0,
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
      totalAnalysis: int.tryParse(json["totalAnalysis"]?.toString() ?? "0") ?? 0,
      duplicates: int.tryParse(json["duplicates"]?.toString() ?? "0") ?? 0,
      suggestedReplies: int.tryParse(json["suggestedReplies"]?.toString() ?? "0") ?? 0,
    );
  }
}