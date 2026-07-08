class DashboardModel {
  final UserStats users;
  final TicketStats tickets;
  final PriorityStats priority;
  final StatusStats status;
  final List<RecentTicket> recentTickets;
  final List<RecentUser> recentUsers;

  DashboardModel({
    required this.users,
    required this.tickets,
    required this.priority,
    required this.status,
    required this.recentTickets,
    required this.recentUsers,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      users: UserStats.fromJson(json["users"] ?? {}),
      tickets: TicketStats.fromJson(json["tickets"] ?? {}),
      priority: PriorityStats.fromJson(json["priority"] ?? {}),
      status: StatusStats.fromJson(json["status"] ?? {}),
      recentTickets: (json["recentTickets"] as List? ?? [])
          .map((e) => RecentTicket.fromJson(e))
          .toList(),
      recentUsers: (json["recentUsers"] as List? ?? [])
          .map((e) => RecentUser.fromJson(e))
          .toList(),
    );
  }
}

class UserStats {
  final int total;
  final int active;
  final int inactive;

  UserStats({
    required this.total,
    required this.active,
    required this.inactive,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      total: json["total"] ?? 0,
      active: json["active"] ?? 0,
      inactive: json["inactive"] ?? 0,
    );
  }
}

class TicketStats {
  final int total;
  final int open;
  final int assigned;
  final int inProgress;
  final int resolved;
  final int closed;

  TicketStats({
    required this.total,
    required this.open,
    required this.assigned,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });

  factory TicketStats.fromJson(Map<String, dynamic> json) {
    return TicketStats(
      total: json["total"] ?? 0,
      open: json["open"] ?? 0,
      assigned: json["assigned"] ?? 0,
      inProgress: json["inProgress"] ?? 0,
      resolved: json["resolved"] ?? 0,
      closed: json["closed"] ?? 0,
    );
  }
}

class PriorityStats {
  final int low;
  final int medium;
  final int high;
  final int critical;

  PriorityStats({
    required this.low,
    required this.medium,
    required this.high,
    required this.critical,
  });

  factory PriorityStats.fromJson(Map<String, dynamic> json) {
    return PriorityStats(
      low: json["low"] ?? 0,
      medium: json["medium"] ?? 0,
      high: json["high"] ?? 0,
      critical: json["critical"] ?? 0,
    );
  }
}

class StatusStats {
  final int open;
  final int assigned;
  final int inProgress;
  final int resolved;
  final int closed;

  StatusStats({
    required this.open,
    required this.assigned,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });

  factory StatusStats.fromJson(Map<String, dynamic> json) {
    return StatusStats(
      open: json["open"] ?? 0,
      assigned: json["assigned"] ?? 0,
      inProgress: json["inProgress"] ?? 0,
      resolved: json["resolved"] ?? 0,
      closed: json["closed"] ?? 0,
    );
  }
}

class RecentTicket {
  final String id;
  final String title;
  final String priority;
  final String status;

  RecentTicket({
    required this.id,
    required this.title,
    required this.priority,
    required this.status,
  });

  factory RecentTicket.fromJson(Map<String, dynamic> json) {
    return RecentTicket(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      priority: json["priority"] ?? "",
      status: json["status"] ?? "",
    );
  }
}

class RecentUser {
  final String id;
  final String name;
  final String email;
  final String role;

  RecentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory RecentUser.fromJson(Map<String, dynamic> json) {
    return RecentUser(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
    );
  }
}