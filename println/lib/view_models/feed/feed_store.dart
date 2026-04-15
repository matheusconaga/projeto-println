import 'package:mobx/mobx.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/models/feed_response.dart';
import 'package:println/models/post_model.dart';

part 'feed_store.g.dart';

class FeedStore = _FeedStore with _$FeedStore;

abstract class _FeedStore with Store {
  final PostService api;

  _FeedStore(this.api);

  @observable
  ObservableList<PostModel> posts = ObservableList();

  @observable
  bool loading = false;

  @observable
  bool loadingMore = false;

  @observable
  String? error;

  int page = 1;
  bool hasMore = true;

  @action
  Future<void> loadFeed() async {
    try {
      loading = true;
      error = null;
      page = 1;
      final response = await api.getFeed(page);
      final feed = FeedResponse.fromJson(response.data);

      posts.clear();
      posts.addAll(feed.posts);
      hasMore = feed.posts.length >= 10;
    } catch (e) {
      error = "Erro ao carregar feed: $e";
      print(e);
    } finally {
      loading = false;
    }
  }

  @action
  void updatePost(PostModel updatedPost) {

    final index = posts.indexWhere((p) => p.id == updatedPost.id);
    if (index == -1) return;
    posts[index] = updatedPost;

  }

  @action
  Future<void> loadMore() async {
    if (loadingMore || !hasMore) return;

    loadingMore = true;

    try {
      page++;
      final response = await api.getFeed(page);
      final feed = FeedResponse.fromJson(response.data);

      posts.addAll(feed.posts);

      if (feed.posts.length < 10) {
        hasMore = false;
      }
    } catch (e) {
      error = "Erro ao carregar mais posts";
    }

    loadingMore = false;
  }
}