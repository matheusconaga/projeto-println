import 'user_model.dart';

class CommentModel {

  final String id;
  final String content;
  final DateTime createdAt;
  final UserModel user;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {

    return CommentModel(
      id: json["id"],
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
      user: UserModel.fromJson(json["user"]),
    );
  }
}