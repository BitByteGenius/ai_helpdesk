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

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      id: _parseString(json["_id"]),
      user: AuditUser.fromJson(
        json["user"] is Map<String, dynamic> ? json["user"] : {},
      ),
      action: _parseString(json["action"]),
      entity: _parseString(json["entity"]),
      description: _parseString(json["description"]),
      oldData: json["oldData"] is Map<String, dynamic> ? json["oldData"] : null,
      newData: json["newData"] is Map<String, dynamic> ? json["newData"] : null,
      ipAddress: _parseString(json["ipAddress"]),
      userAgent: _parseString(json["userAgent"]),
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? "") ?? DateTime.now(),
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

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory AuditUser.fromJson(Map<String, dynamic> json) {
    return AuditUser(
      id: _parseString(json["_id"]),
      name: _parseString(json["name"]),
      email: _parseString(json["email"]),
      role: _parseString(json["role"]),
    );
  }
}
