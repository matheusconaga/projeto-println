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
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {

    return PostModel(
      id: json["id"],
      content: json["content"],
      imageUrl: json["image_url"],
      location: json["location"],
      likes: json["likes_count"],
      comments: json["comments_count"],
      saves: json["saves_count"],
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
      user: json["user"] != null
          ? UserModel.fromJson(json["user"])
          : UserModel(
        id: json["user_id"] ?? "unknown",
        username: "Desconhecido",
        photo: null,
      ),
    );
  }
}