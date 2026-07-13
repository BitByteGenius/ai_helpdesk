class AuditModel {
  final String id;

  final AuditUser user;

  final String action;

  final String entity;

  final String description;

  final Map<String, dynamic>? oldData;

  final Map<String, dynamic>? newData;

  final String ipAddress;

  final String userAgent;

  final DateTime createdAt;

  AuditModel({
    required this.id,
    required this.user,
    required this.action,
    required this.entity,
    required this.description,
    this.oldData,
    this.newData,
    required this.ipAddress,
    required this.userAgent,
    required this.createdAt,
  });

  factory AuditModel.fromJson(
      Map<String, dynamic> json) {
    return AuditModel(
      id: json["_id"] ?? "",

      user: AuditUser.fromJson(
        json["user"] ?? {},
      ),

      action: json["action"] ?? "",

      entity: json["entity"] ?? "",

      description:
          json["description"] ?? "",

      oldData: json["oldData"],

      newData: json["newData"],

      ipAddress:
          json["ipAddress"] ?? "",

      userAgent:
          json["userAgent"] ?? "",

      createdAt: DateTime.tryParse(
            json["createdAt"]?.toString() ?? "",
          ) ??
          DateTime.now(),
    );
  }
}

class AuditUser {
  final String id;

  final String name;

  final String email;

  final String role;

  AuditUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuditUser.fromJson(
      Map<String, dynamic> json) {
    return AuditUser(
      id: json["_id"] ?? "",

      name: json["name"] ?? "",

      email: json["email"] ?? "",

      role: json["role"] ?? "",
    );
  }
}
