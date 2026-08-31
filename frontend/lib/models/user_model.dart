import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileImage,
    this.createdAt,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final resolvedId = json["_id"] ?? json["id"] ?? json["userId"] ?? "";

    return UserModel(
      id: _parseString(resolvedId),
      name: _parseString(json["name"]),
      email: _parseString(json["email"]),
      phone: _parseString(json["phone"]),
      role: _parseString(json["role"], fallback: "user"),
      profileImage: _parseString(json["profileImage"]),
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "profileImage": profileImage,
      "createdAt": createdAt?.toIso8601String(),
    };
  }

  String encode() => jsonEncode(toJson());

  factory UserModel.decode(String source) =>
      UserModel.fromJson(jsonDecode(source));

  bool get isAdmin => role.toLowerCase() == "admin";

  bool get isUser => role.toLowerCase() == "user";
}