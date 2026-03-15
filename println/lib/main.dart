import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/routes/router_generator.dart';
import 'package:println/core/theme/app_theme.dart';
import 'package:println/view_models/theme/theme_store.dart';
import 'firebase_options.dart';

final themeStore = ThemeStore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await themeStore.init();

  runApp(AppWithThemeListener(themeStore: themeStore));
}

class AppWithThemeListener extends StatelessWidget {
  final ThemeStore themeStore;

  const AppWithThemeListener({super.key, required this.themeStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: "PrintLn",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        // themeMode: ThemeMode.light,
        initialRoute: AppRoutes.splashPage,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}