import 'package:mobx/mobx.dart';
import 'package:println/core/services/api_service.dart';
import 'package:println/core/services/comment_service.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/models/comment_model.dart';
import 'package:println/models/post_model.dart';
import 'package:println/view_models/post/post_store.dart';

part 'post_details_store.g.dart';

class PostDetailsStore = _PostDetailsStore with _$PostDetailsStore;

abstract class _PostDetailsStore with Store {

  final PostService api;

  _PostDetailsStore(this.api);

  @observable
  PostModel? post;

  @observable
  ObservableList<CommentModel> comments = ObservableList<CommentModel>();

  @observable
  bool sendingComment = false;

  final CommentService commentService = CommentService(ApiService());

  @observable
  bool loading = false;

  @observable
  String? error;

  @observable
  String? editingCommentId;

  @action
  Future<void> loadPost(String postId, PostStore postStore) async {
    loading = true;

    try {
      final json = await api.getPostDetails(postId);

      post = PostModel.fromJson(json);

      if (!postStore.postComments.containsKey(postId)) {
        postStore.postComments[postId] = post!.comments;
      }

      final commentsJson = json["comments_preview"] as List;

      comments.clear();
      comments.addAll(
        commentsJson.map((e) => CommentModel.fromJson(e)).toList(),
      );

    } catch (e) {
      error = "Erro ao carregar post";
    }

    loading = false;
  }

  @action
  Future<void> addComment(
      String userId,
      String postId,
      String content,
      PostStore postStore,
      ) async {

    final currentCount =
        postStore.postComments[postId] ?? post?.comments ?? 0;

    final tempComment = CommentModel(
      id: DateTime.now().toString(),
      content: content,
      createdAt: DateTime.now(),
      updatedAt: null,
      user: post!.user!,
    );

    comments.insert(0, tempComment);
    postStore.postComments[postId] = currentCount + 1;

    try {
      final newComment = await commentService.createComment(
        userId: userId,
        postId: postId,
        content: content,
      );

      final index = comments.indexWhere((c) => c.id == tempComment.id);
      if (index != -1) {
        comments[index] = newComment;
      }

    } catch (e) {
      comments.removeWhere((c) => c.id == tempComment.id);
      postStore.postComments[postId] = currentCount;
      error = "Erro ao comentar";
    }
  }

  @action
  Future<void> editComment(String commentId, String userId, String content) async {
    final updated = await commentService.editComment(
      commentId: commentId,
      userId: userId,
      content: content,
    );

    final index = comments.indexWhere((c) => c.id == commentId);

    if (index != -1) {
      comments[index] = updated;
    }

  }

  @action
  Future<void> deleteComment(
      String commentId,
      String userId,
      PostStore postStore,
      ) async {
    final postId = post!.id;
    final currentCount = postStore.postComments[postId] ?? post!.comments;

    final newCount = (currentCount - 1).clamp(0, 9999);

    postStore.postComments[postId] = newCount;

    comments.removeWhere((c) => c.id == commentId);

    if (post != null) {
      post = PostModel(
        id: post!.id,
        content: post!.content,
        imageUrl: post!.imageUrl,
        location: post!.location,
        likes: post!.likes,
        comments: newCount,
        saves: post!.saves,
        createdAt: post!.createdAt,
        user: post!.user,
      );
    }

    try {
      await commentService.deleteComment(
        commentId: commentId,
        userId: userId,
      );
    } catch (e) {
      postStore.postComments[postId] = currentCount;
      error = "Erro ao deletar comentário";
    }
  }

}