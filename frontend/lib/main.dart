import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/bottom_bar.dart";
import "package:wod_board_app/widgets/routers.dart";

Future main() async {
  await dotenv.load(mergeWith: Platform.environment);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BottomBarState(),
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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String _currentScreenLabel = "Home";

  // Callback function to update currentIndex
  void onTabTapped(String screenLabel) {
    setState(() {
      _currentScreenLabel = screenLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wod Board",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(_currentScreenLabel)),
        body: Navigator(
          key: navigatorKey,
          initialRoute: Routes.home,
          onGenerateRoute: (RouteSettings settings) {
            return WorkoutRouter.generateRoute(settings);
          },
        ),
        bottomNavigationBar: BottomBar(
          onTabTapped: onTabTapped,
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
