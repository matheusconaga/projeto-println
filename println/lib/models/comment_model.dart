import 'user_model.dart';

class CommentModel {

  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final UserModel user;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.user,
  });

  bool get isEdited => updatedAt != null;

  factory CommentModel.fromJson(Map<String, dynamic> json) {

    return CommentModel(
      id: json["id"],
      content: json["content"],
      createdAt: DateTime.parse(json["created_at"]).toLocal(),
      updatedAt: json["updated_at"] != null
          ? DateTime.parse(json["updated_at"])
          : null,
      user: UserModel.fromJson(json["user"]),
    );
  }
}