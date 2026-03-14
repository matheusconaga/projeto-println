import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/routes/app_routes.dart';
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

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    authStore = widget.authStore;
    themeStore = widget.themeStore;

    final apiService = PostService(ApiService());

    feedStore = FeedStore(apiService);
    postStore = PostStore(apiService);

    feedStore.loadFeed().then((_) {
      postStore.initializeLikes(
        authStore.user!.id,
        feedPosts: feedStore.posts.toList(),
      );
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        feedStore.loadMore();
      }
    });
  }

  void _logout() async {
    await authStore.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void onUserChanged(String newUserId) async {
    await postStore.initializeLikes(newUserId);
  }

  void _openUserMenu() {

    showDialog(
      context: context,
      builder: (_) => UserMenuDialog(
        themeStore: themeStore,
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

      appBar: CustomAppBar(onNotificationsTap: () {}),

      body: Observer(
        builder: (_) {

          if (feedStore.loading) {
            return const Center(child: CircularProgressIndicator());
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