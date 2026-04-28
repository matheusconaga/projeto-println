import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import 'package:println/core/routes/app_routes.dart';
import 'package:println/view_models/auth/auth_store.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AuthStore authStore;

  bool _hasNavigated = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      authStore = context.read<AuthStore>();
      _loadUser();
      _initialized = true;
    }
  }

  Future<void> _loadUser() async {
    await authStore.checkAuth();

    _navigate();
  }

  void _navigate() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final route = authStore.isLogged
        ? AppRoutes.home
        : AppRoutes.login;

    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthStore>();

    return Observer(
      builder: (_) {
        if (authStore.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}