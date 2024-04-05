import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/bottom_bar.dart";
import "package:wod_board_app/widgets/routers.dart";

Future main() async {
  await dotenv.load(mergeWith: Platform.environment);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomBarState(),
        ),
        ProxyProvider<SettingsService, ApiService>(
          update: (BuildContext context, SettingsService settings,
                  ApiService? apiService) =>
              ApiService(settings),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String _currentScreenLabel = "Home";

  // Callback function to update currentIndex
  void onTabTapped(String screenLabel) {
    setState(() {
      _currentScreenLabel = screenLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsService>(context);
    return MaterialApp(
      title: "Wod Board",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(_currentScreenLabel)),
        body: Navigator(
          key: settings.mainNavigatorKey,
          initialRoute: Routes.home,
          onGenerateRoute: (RouteSettings routeSettings) {
            return WorkoutRouter.generateRoute(routeSettings);
          },
        ),
        bottomNavigationBar: BottomBar(
          onTabTapped: onTabTapped,
          navigatorKey: settings.mainNavigatorKey,
        ),
      ),
    );
  }
}
