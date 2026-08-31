class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;
  final bool isVerified;
  final DateTime createdAt;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileImage,
    required this.isVerified,
    required this.createdAt,
  });

  static String _parseString(dynamic val, {String fallback = ""}) {
    if (val == null) return fallback;
    if (val is String) return val;
    if (val is List) return val.map((e) => e.toString()).join(", ");
    return val.toString();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: _parseString(json["_id"]),
      name: _parseString(json["name"]),
      email: _parseString(json["email"]),
      phone: _parseString(json["phone"]),
      role: _parseString(json["role"], fallback: "User"),
      profileImage: _parseString(json["profileImage"]),
      isVerified: json["isVerified"] == true,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "profileImage": profileImage,
      "isVerified": isVerified,
    };
  }

  ProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    bool? isVerified,
  }) {
    return ProfileModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
    );
  }
}