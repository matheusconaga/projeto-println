import 'post_model.dart';

class FeedResponse {

  final List<PostModel> posts;

  FeedResponse({
    required this.posts,
  });

  factory FeedResponse.fromJson(List data) {

    return FeedResponse(
      posts: data.map((e) => PostModel.fromJson(e)).toList(),
    );
  }
}