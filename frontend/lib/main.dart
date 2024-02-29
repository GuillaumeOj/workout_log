import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:wod_board_app/settings.dart';
import 'package:wod_board_app/widgets/add_workout_screen.dart';
import 'package:wod_board_app/widgets/bottom_bar.dart';
import 'package:wod_board_app/widgets/home_screen.dart';
import 'package:wod_board_app/widgets/profile_screen.dart';

Future main() async {
  await dotenv.load(mergeWith: Platform.environment);
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingProvider(),
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
  int currentIndex = 0;

  final List<Map<String, dynamic>> staticScreens = const [
    {
      "icon": Icon(Icons.home),
      "label": "Home",
      "screen": HomeScreen(),
    },
    {
      "icon": Icon(Icons.add),
      "label": "Add Workout",
      "screen": AddWorkoutScreen()
    },
    {
      "icon": Icon(Icons.account_circle),
      "label": "MyProfile",
      "screen": ProfileScreen()
    },
  ];

  // Callback function to update currentIndex
  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wod Board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text(staticScreens[currentIndex]["label"])),
        body: staticScreens[currentIndex]["screen"],
        bottomNavigationBar: BottomBar(
          currentIndex: currentIndex,
          itemValues: staticScreens,
          onTabTapped: onTabTapped,
        ),
      ),
    );
  }
}
