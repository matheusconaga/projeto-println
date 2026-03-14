import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/view_models/saved_post/saved_posts_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'package:println/widgets/custom_app_bar.dart';
import 'package:println/widgets/post_card.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/core/services/api_service.dart';

class SavedPostsPage extends StatefulWidget {
  final AuthStore authStore;
  final ThemeStore themeStore;

  const SavedPostsPage({
    super.key,
    required this.authStore,
    required this.themeStore,
  });

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  late final AuthStore authStore;
  late final ThemeStore themeStore;
  late final SavedPostsStore savedStore;
  late final PostStore postStore;

  @override
  void initState() {
    super.initState();

    authStore = widget.authStore;
    themeStore = widget.themeStore;

    final apiService = PostService(ApiService());

    savedStore = SavedPostsStore(apiService);
    postStore = PostStore(apiService);

    _loadSavedPosts();
  }

  Future<void> _loadSavedPosts() async {
    final userId = authStore.user!.id;

    await savedStore.loadSavedPosts(userId);

    await postStore.initializeLikes(
      userId,
      feedPosts: savedStore.savedPosts.toList(),
    );

    await postStore.initializeSaves(userId);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Postagens salvas",
        onBackTap: () {
          Navigator.pop(context, true);
        },
        onNotificationsTap: () {},
      ),
      body: Observer(
        builder: (_) {
          if (savedStore.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (savedStore.savedPosts.isEmpty) {
            return const Center(
              child: Text("Você não salvou nenhum post ainda"),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSavedPosts,
            child: ListView.builder(
              itemCount: savedStore.savedPosts.length,
              itemBuilder: (context, index) {
                final post = savedStore.savedPosts[index];
                final currentUserId = authStore.user!.id;

                return PostCard(
                  post: post,
                  postStore: postStore,
                  currentUserId: currentUserId,
                );
              },
            ),
          );
        },
      ),
    );

  }
}