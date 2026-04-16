import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/widgets/custom_app_bar.dart';
import 'package:println/widgets/post_card.dart';
import 'package:provider/provider.dart';

class SavedPostsPage extends StatefulWidget {


  const SavedPostsPage({super.key});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  late final AuthStore authStore;
  late final PostStore postStore;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      authStore = context.read<AuthStore>();
      postStore = context.read<PostStore>();

      _loadSavedPosts();

      _initialized = true;
    }
  }

  Future<void> _loadSavedPosts() async {
    final user = authStore.user;
    if (user == null) return;

    final userId = user.id;

    await postStore.loadSavedPosts(userId);

    await postStore.initializeLikes(
      userId,
      feedPosts: postStore.savedPostsList,
    );

    await postStore.initializeSaves(
      userId,
      feedPosts: postStore.savedPostsList,
    );
  }

  @override
  Widget build(BuildContext context) {

    final authStore = context.watch<AuthStore>();
    final postStore = context.watch<PostStore>();

    final user = authStore.user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "Postagens salvas",
        onBackTap: () {
          Navigator.pop(context, true);
        },
      ),
      body: Observer(
        builder: (_) {
          if (postStore.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (postStore.savedPostsList.isEmpty) {
            return const Center(
              child: Text("Você não salvou nenhum post ainda"),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSavedPosts,
            child: ListView.builder(
              itemCount: postStore.savedPostsList.length,
              itemBuilder: (context, index) {
                final post = postStore.savedPostsList[index];

                return PostCard(
                  post: post,
                );
              },
            ),
          );
        },
      ),
    );

  }
}