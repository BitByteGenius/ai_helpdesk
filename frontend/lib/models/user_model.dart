// import 'dart:convert';

// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final String phone;
//   final String role;
//   final String profileImage;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.role,
//     required this.profileImage,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     final resolvedId = json["_id"] ?? json["id"] ?? json["userId"] ?? "";
//     return UserModel(
//       id: resolvedId.toString(),
//       name: json["name"]?.toString() ?? "",
//       email: json["email"]?.toString() ?? "",
//       phone: json["phone"]?.toString() ?? "",
//       role: json["role"]?.toString() ?? "user",
//       profileImage: json["profileImage"]?.toString() ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "_id": id,
//       "name": name,
//       "email": email,
//       "phone": phone,
//       "role": role,
//       "profileImage": profileImage,
//     };
//   }

//   String encode() => jsonEncode(toJson());

//   factory UserModel.decode(String source) =>
//       UserModel.fromJson(jsonDecode(source));

//   bool get isAdmin => role == "admin";

//   bool get isUser => role == "user";
// }


import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;

  /// NEW
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final resolvedId = json["_id"] ?? json["id"] ?? json["userId"] ?? "";

    return UserModel(
      id: resolvedId.toString(),
      name: json["name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phone: json["phone"]?.toString() ?? "",
      role: json["role"]?.toString() ?? "user",
      profileImage: json["profileImage"]?.toString() ?? "",
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