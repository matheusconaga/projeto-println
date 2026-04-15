import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/models/post_model.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'package:println/widgets/custom_app_bar.dart';
import 'package:println/widgets/user_menu_dialog.dart';
import 'package:println/widgets/post_card.dart';
import 'package:println/view_models/feed/feed_store.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/core/services/api_service.dart';

class FeedPage extends StatefulWidget {

  final AuthStore authStore;
  final ThemeStore themeStore;

  const FeedPage({
    super.key,
    required this.authStore,
    required this.themeStore,
  });

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  late final AuthStore authStore;
  late final ThemeStore themeStore;
  late final FeedStore feedStore;
  late final PostStore postStore;
  late ReactionDisposer _userReaction;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    authStore = widget.authStore;
    themeStore = widget.themeStore;

    feedStore = FeedStore(PostService(ApiService()));
    postStore = PostStore(PostService(ApiService()));

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
      fireImmediately: false,
    );
  }

  Future<void> _refreshAllData() async {
    await feedStore.loadFeed();
    final user = authStore.user;
    if (user != null) {
      await postStore.initializeLikes(user.id, feedPosts: feedStore.posts.toList());
      await postStore.initializeSaves(user.id, feedPosts: feedStore.posts.toList());
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

  void onUserChanged(String newUserId) async {
    await postStore.initializeLikes(newUserId);
  }

  void _openUserMenu() {

    showDialog(
      context: context,
      builder: (_) => UserMenuDialog(
        themeStore: themeStore,
        feedStore: feedStore,
        onEditProfile: () {
          Navigator.pop(context);
        },
        onLogout: _logout,
        authStore: authStore,
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

          if (feedStore.loading && feedStore.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (feedStore.error != null && feedStore.posts.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text(feedStore.error!),
                  ElevatedButton(onPressed: feedStore.loadFeed, child: Text("Repetir"))
                ],
              ),
            );
          }

          return RefreshIndicator(

            onRefresh: () => feedStore.loadFeed(),

            child: ListView.builder(

              controller: scrollController,

              itemCount: feedStore.posts.isEmpty && !feedStore.loading ?
              1 : feedStore.posts.length + (feedStore.loadingMore ? 1 : 0),

              itemBuilder: (context, index) {

                if (feedStore.posts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Text("Nenhum post ainda"),
                    ),
                  );
                }

                if (index == feedStore.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = feedStore.posts[index];

                return PostCard(
                  post: post,
                  postStore: postStore,
                  currentUserId: authStore.user!.id,
                  authStore: authStore,
                  feedStore: feedStore,
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
                      await feedStore.loadFeed();
                    }

                  },
                  onTap: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      AppRoutes.detailsPost,
                      arguments: {
                        "postId": post.id,
                        "postStore": postStore,
                      },
                    );

                    if (result != null && result is Map) {

                      final index = feedStore.posts.indexWhere((p) => p.id == result["postId"]);
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
                      await feedStore.loadFeed();
                    }
                  },
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,

        currentIndex: 0,

        onTap: (index) async {

          if (index == 1) {

            final result = await Navigator.pushNamed(
              context,
              AppRoutes.createPost,
            );

            if (result == true) {

              await feedStore.loadFeed();

              WidgetsBinding.instance.addPostFrameCallback((_) {

                if (scrollController.hasClients) {

                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );

                }

              });

            }

          }
          if (index == 2) {
            final result = await Navigator.pushNamed(
              context,
              AppRoutes.savedPosts,
            );

            if (result != null && result is bool && result) {
              await feedStore.loadFeed();

              final user = authStore.user;
              if (user != null) {
                final userId = user.id;
                await postStore.initializeLikes(userId, feedPosts: feedStore.posts.toList());
                await postStore.initializeSaves(userId, feedPosts: feedStore.posts.toList());
              }
            }
          }

          if (index == 3) {
            _openUserMenu();
          }

        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Criar"),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Salvos"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}