import 'package:flutter/material.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/views/feed/feed_page.dart';
import 'package:println/views/login/auth_page.dart';
import 'package:println/views/post/post_details_page.dart';
import 'package:println/views/post/post_page.dart';
import 'package:println/views/saved_post/saved_post_page.dart';
import 'package:println/views/splash/splash_page.dart';


class RouteGenerator{

  static Route<dynamic> generateRoute(RouteSettings settings){

    switch (settings.name) {
      case AppRoutes.splashPage:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => AuthPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => FeedPage());

      case AppRoutes.createPost:

        final args = settings.arguments as Map?;

        return MaterialPageRoute(
          builder: (_) => PostPage(
            postId: args?["postId"],
            initialContent: args?["content"],
            initialLocation: args?["location"],
            initialImageUrl: args?["imageUrl"],
          ),
        );

      case AppRoutes.savedPosts:
        return MaterialPageRoute(builder: (_) => SavedPostsPage());
      case AppRoutes.detailsPost:

        final args = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => PostDetailsPage(
            postId: args["postId"],
          ),
        );

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