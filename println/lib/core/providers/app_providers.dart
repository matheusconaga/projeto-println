import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:println/view_models/auth/auth_store.dart';
import 'package:println/view_models/post/post_store.dart';
import 'package:println/view_models/feed/feed_store.dart';
import 'package:println/view_models/theme/theme_store.dart';

import 'package:println/core/services/api_service.dart';
import 'package:println/core/services/post_service.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final postService = PostService(apiService);

    return MultiProvider(
      providers: [

        Provider<AuthStore>(
          create: (_) => AuthStore(),
        ),

        Provider<ThemeStore>(
          create: (_) => ThemeStore(),
        ),

        Provider<FeedStore>(
          create: (_) => FeedStore(postService),
        ),

        Provider<PostStore>(
          create: (_) => PostStore(postService),
        ),
      ],
      child: child,
    );
  }
}