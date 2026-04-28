import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:println/core/ui/app_messenger.dart';
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
      child: AppWrapper(),
    ),
  );
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktopWeb = kIsWeb && width >= 900;

    final app = MyApp();

    if (!isDesktopWeb) {
      return app;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Container(
          width: 390,
          height: 744,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(42),
            boxShadow: const [
              BoxShadow(
                blurRadius: 30,
                spreadRadius: 5,
                color: Colors.black26,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(34),
            child: app,
          ),
        ),
      ),
    );
  }
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
        scaffoldMessengerKey: AppMessenger.messengerKey,
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