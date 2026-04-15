import 'package:mobx/mobx.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/models/comment_model.dart';
import 'package:println/models/post_model.dart';

part 'post_details_store.g.dart';

class PostDetailsStore = _PostDetailsStore with _$PostDetailsStore;

abstract class _PostDetailsStore with Store {

  final PostService api;

  _PostDetailsStore(this.api);

  @observable
  PostModel? post;

  @observable
  ObservableList<CommentModel> comments = ObservableList();

  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> loadPost(String postId) async {

    loading = true;

    try {

      final json = await api.getPostDetails(postId);

      post = PostModel.fromJson(json);

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
}