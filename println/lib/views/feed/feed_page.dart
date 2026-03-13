import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/view_models/auth/auth_store.dart';

class FeedPage extends StatefulWidget {
  final AuthStore authStore;
  const FeedPage({super.key, required this.authStore});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late final AuthStore authStore;

  @override
  void initState() {
    super.initState();
    authStore = widget.authStore;
  }

  void _logout() async {
    await authStore.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          Observer(
            builder: (_) => authStore.isLogged
                ? IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: const Center(
        child: Text("Bem-vindo ao PrintLn!"),
      ),
    );
  }
}