class CommentModel {
  final String id;
  final String ticketId;
  final String message;
  final DateTime createdAt;

  final CommentUser user;
  final bool isEdited;

  CommentModel({
    required this.id,
    required this.ticketId,
    required this.message,
    required this.createdAt,
    required this.user,
    required this.isEdited,
  });

  factory CommentModel.fromJson(
      Map<String, dynamic> json) {
    return CommentModel(
      id: json["_id"] ?? "",
      ticketId: json["ticket"] ?? "",
      message: json["message"] ?? "",
      createdAt: DateTime.parse(
        json["createdAt"],
      ),
      user: CommentUser.fromJson(
        json["user"] ?? {},
      ),
      isEdited: json["isEdited"] ?? false,
    );
  }
}

class CommentUser {
  final String id;
  final String name;
  final String image;

  CommentUser({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CommentUser.fromJson(
      Map<String, dynamic> json) {
    return CommentUser(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      image: json["profileImage"] ?? "",
    );
  }
}