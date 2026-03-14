import 'package:mobx/mobx.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/models/post_model.dart';

part 'saved_posts_store.g.dart';

class SavedPostsStore = _SavedPostsStore with _$SavedPostsStore;

abstract class _SavedPostsStore with Store {
  final PostService api;

  _SavedPostsStore(this.api);

  @observable
  ObservableList<PostModel> savedPosts = ObservableList();

  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> loadSavedPosts(String userId) async {
    loading = true;
    error = null;

    try {
      final response = await api.getUserSaves(userId);

      final posts = response
          .map<PostModel>((json) => PostModel.fromJson(json))
          .toList();

      savedPosts.clear();
      savedPosts.addAll(posts);
    } catch (e) {
      error = "Erro ao carregar posts salvos";
    } finally {
      loading = false;
    }
  }

}