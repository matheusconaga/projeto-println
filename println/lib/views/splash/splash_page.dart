import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/view_models/auth/auth_store.dart';

class SplashPage extends StatefulWidget {
  final AuthStore authStore;

  const SplashPage({super.key, required this.authStore});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthStore authStore;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    authStore = widget.authStore;
    _loadUser();
  }

  Future<void> _loadUser() async {
    await authStore.checkAuth();

    if (authStore.isLogged && authStore.user == null) {
      final firebaseUser = authStore.getFirebaseUser();
      if (firebaseUser != null) {
        final backendUser = await authStore.waitForUserInBackend(firebaseUser.uid, timeout: Duration(seconds: 10));
        if (backendUser != null) {
          runInAction(() => authStore.user = backendUser);
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  void _navigate() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final route = authStore.isLogged ? AppRoutes.home : AppRoutes.login;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (authStore.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_hasNavigated && (authStore.user != null || !authStore.isLogged)) {
          _navigate();
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}