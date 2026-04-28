import 'package:flutter/material.dart';
import 'package:println/view_models/feed/feed_store.dart';
import 'package:println/views/feed/feed_page.dart';
import 'package:println/views/post/post_page.dart';
import 'package:println/views/saved_post/saved_post_page.dart';
import 'package:println/widgets/user_menu_dialog.dart';
import 'package:provider/provider.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentIndex = 0;

  late final List<Widget> pages = [
    const FeedPage(),
    const PostPage(),
    const SavedPostsPage(),
  ];

  Future<void> changeTab(int index) async {
    if (index == 3) {
      openProfile();
      return;
    }

    setState(() {
      currentIndex = index;
    });

    final feedStore = context.read<FeedStore>();
    final postStore = context.read<PostStore>();
    final authStore = context.read<AuthStore>();

    if (index == 0) {
      feedStore.loadFeed();
    }

    if (index == 2) {
      final user = authStore.user;

      if (user != null) {
        postStore.loadSavedPosts(user.id);
      }
    }
  }

  void openProfile() {
    final authStore = context.read<AuthStore>();

    showDialog(
      context: context,
      builder: (_) => UserMenuDialog(
        onEditProfile: () {},
        onLogout: () async {
          Navigator.pop(context);
          await authStore.logout();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final inactive = theme.iconTheme.color?.withOpacity(.55);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              _item(
                icon: Icons.home_rounded,
                label: "Home",
                selected: currentIndex == 0,
                color: primary,
                inactive: inactive,
                onTap: () => changeTab(0),
              ),
              _item(
                icon: Icons.add_circle_rounded,
                label: "Criar",
                selected: currentIndex == 1,
                color: primary,
                inactive: inactive,
                onTap: () => changeTab(1),
              ),
              _item(
                icon: Icons.bookmark_rounded,
                label: "Salvos",
                selected: currentIndex == 2,
                color: primary,
                inactive: inactive,
                onTap: () => changeTab(2),
              ),
              _item(
                icon: Icons.person_rounded,
                label: "Perfil",
                selected: false,
                color: primary,
                inactive: inactive,
                onTap: openProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required Color color,
    required Color? inactive,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? color.withOpacity(.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? color : inactive,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? color : inactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}