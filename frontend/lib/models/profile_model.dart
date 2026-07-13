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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "User",
      profileImage: json["profileImage"] ?? "",
      isVerified: json["isVerified"] ?? false,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
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