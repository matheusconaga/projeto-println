import 'package:println/models/comment_model.dart';
import 'package:println/core/services/api_service.dart';

class CommentService {
  final ApiService api;

  CommentService(this.api);

  Future<CommentModel> createComment({
    required String userId,
    required String postId,
    required String content,
  }) async {

    final response = await api.dio.post(
      "/comments/",
      queryParameters: {
        "user_id": userId,
        "post_id": postId,
        "content": content,
      },
    );

    return CommentModel.fromJson(response.data);
  }

  Future<CommentModel> editComment({
    required String commentId,
    required String userId,
    required String content,
  }) async {
    final response = await api.dio.put("/comments/$commentId", queryParameters: {
      "user_id": userId,
      "content": content,
    });

    return CommentModel.fromJson(response.data);
  }

  Future<void> deleteComment({
    required String commentId,
    required String userId,
  }) async {
    await api.dio.delete("/comments/$commentId", queryParameters: {
      "user_id": userId,
    });
  }
}