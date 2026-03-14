import 'package:flutter/material.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'package:println/widgets/custom_app_bar.dart';
import 'package:println/widgets/user_menu_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    authStore = widget.authStore;
    themeStore = widget.themeStore;
  }

  void _logout() async {
    await authStore.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  _openUserMenu() {
    showDialog(
      context: context,
      builder: (_) => UserMenuDialog(
        themeStore: themeStore,
        onEditProfile: () {
          Navigator.pop(context);
        },
        onLogout: _logout,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onNotificationsTap: () {}),
      body: Center(
        child: Text("Feed vai aqui...", style: AppTextStyles.body1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {

          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.createPost);
          }

          if (index == 3) _openUserMenu();

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