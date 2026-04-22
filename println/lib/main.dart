import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:println/core/providers/app_providers.dart';
import 'package:println/core/routes/app_routes.dart';
import 'package:println/core/routes/router_generator.dart';
import 'package:println/core/theme/app_theme.dart';
import 'package:println/view_models/theme/theme_store.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const AppProviders(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeStore themeStore;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!initialized) {
      themeStore = context.read<ThemeStore>();
      themeStore.init();
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: "PrintLn",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        themeMode: themeStore.themeMode,

        initialRoute: AppRoutes.splashPage,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}