import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:println/view_models/auth/auth_store.dart';

class SplashPage extends StatelessWidget {
  final AuthStore authStore;

  const SplashPage({super.key, required this.authStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (authStore.isLogged) {
          Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
                (route) => false,
          ));
        } else {
          Future.microtask(() => Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false,
          ));
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}