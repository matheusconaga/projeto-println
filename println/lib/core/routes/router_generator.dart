import 'package:flutter/material.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'package:println/views/feed/feed_page.dart';
import 'package:println/views/login/auth_page.dart';
import 'package:println/views/post/post_page.dart';
import 'package:println/views/splash/splash_page.dart';


class RouteGenerator{
  static final AuthStore _authStore = AuthStore();
  static final ThemeStore _themeStore = ThemeStore();

  static Route<dynamic> generateRoute(RouteSettings settings){

    switch (settings.name) {
      case AppRoutes.splashPage:
        return MaterialPageRoute(builder: (_) => SplashPage(authStore: _authStore));
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => AuthPage(authStore: _authStore));
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => FeedPage(authStore: _authStore, themeStore: _themeStore,));
      case AppRoutes.createPost:
        return MaterialPageRoute(builder: (_) => PostPage());

      default:
        return _erroRota();
    }

  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }

}