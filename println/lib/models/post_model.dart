import 'user_model.dart';

class PostModel {

  final String id;
  final String content;
  final String? imageUrl;
  final String? location;
  final int likes;
  final int comments;
  final int saves;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel user;

  PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    this.location,
    required this.likes,
    required this.comments,
    required this.saves,
    required this.createdAt,
    required this.user,
    this.updatedAt
  });

  bool get isEdited => updatedAt != null;

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final userJson = json["user"] as Map<String, dynamic>?;

    return PostModel(
      id: json["id"],
      content: json["content"],
      imageUrl: json["image_url"],
      location: json["location"],
      likes: json["likes_count"] ?? 0,
      comments: json["comments_count"] ?? 0,
      saves: json["saves_count"] ?? 0,
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"]).toLocal()
          : null,
      user: userJson != null
          ? UserModel.fromJson(userJson)
          : UserModel(
        id: json["user_id"] ?? "unknown",
        username: "Desconhecido",
        photo: null,
      ),
    );
  }

}