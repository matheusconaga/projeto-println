import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/feed/feed_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import 'package:println/core/routes/app_routes.dart';
import 'package:println/models/post_model.dart';

import 'package:println/widgets/custom_app_bar.dart';
import 'package:println/widgets/user_menu_dialog.dart';
import 'package:println/widgets/post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late AuthStore authStore;
  late ThemeStore themeStore;
  late FeedStore feedStore;
  late PostStore postStore;

  late ReactionDisposer _userReaction;

  final ScrollController scrollController = ScrollController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      authStore = context.read<AuthStore>();
      themeStore = context.read<ThemeStore>();
      feedStore = context.read<FeedStore>();
      postStore = context.read<PostStore>();

      if (authStore.user != null) {
        _refreshAllData();
      }

      _userReaction = reaction(
            (_) => authStore.user,
            (user) {
          if (user != null) {
            _refreshAllData();
          }
        },
      );

      _initialized = true;
    }
  }

  Future<void> _refreshAllData() async {
    await feedStore.loadFeed();

    final user = authStore.user;

    if (user != null) {
      await postStore.initializeLikes(
        user.id,
        feedPosts: feedStore.posts.toList(),
      );

      await postStore.initializeSaves(
        user.id,
        feedPosts: feedStore.posts.toList(),
      );
    }
  }

  @override
  void dispose() {
    _userReaction();
    scrollController.dispose();
    super.dispose();
  }

  void _logout() async {
    await authStore.logout();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _openUserMenu() {
    showDialog(
      context: context,
      builder: (_) => UserMenuDialog(
        onEditProfile: () => Navigator.pop(context),
        onLogout: _logout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Observer(
        builder: (_) {
          if (authStore.user == null && authStore.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authStore.user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            });
            return const Center(child: Text("Redirecionando..."));
          }

          if (feedStore.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (feedStore.error != null && feedStore.posts.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(feedStore.error!),
                  ElevatedButton(
                    onPressed: feedStore.loadFeed,
                    child: const Text("Repetir"),
                  )
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshAllData,
            child: ListView.builder(
              controller: scrollController,
              itemCount: feedStore.posts.length +
                  (feedStore.loadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == feedStore.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = feedStore.posts[index];

                return PostCard(
                  key: ValueKey(post.id),
                  post: post,

                  onEdit: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.createPost,
                      arguments: {
                        "postId": post.id,
                        "content": post.content,
                        "location": post.location,
                        "imageUrl": post.imageUrl,
                      },
                    );

                    if (result == true) {
                      await _refreshAllData();
                    }
                  },

                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.detailsPost,
                      arguments: {
                        "postId": post.id,
                      },
                    );

                    if (result is Map) {
                      final index = feedStore.posts
                          .indexWhere((p) => p.id == result["postId"]);

                      if (index != -1) {
                        final oldPost = feedStore.posts[index];

                        feedStore.posts[index] = PostModel(
                          id: oldPost.id,
                          content: result["content"],
                          location: result["location"],
                          imageUrl: oldPost.imageUrl,
                          likes: oldPost.likes,
                          comments: oldPost.comments,
                          saves: oldPost.saves,
                          createdAt: oldPost.createdAt,
                          user: oldPost.user,
                        );
                      }
                    }

                    if (result == true) {
                      await _refreshAllData();
                    }
                  },
                );
              },
            ),
          );
        },
      ),

    );
  }
}