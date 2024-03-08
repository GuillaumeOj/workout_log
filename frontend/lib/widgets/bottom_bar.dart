import "package:flutter/material.dart";
import "package:wod_board_app/widgets/routers.dart";

class BottomBar extends StatefulWidget {
  const BottomBar({
    super.key,
    required this.onTabTapped,
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final void Function(int, String) onTabTapped;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  final List<Map<String, dynamic>> staticScreens = const [
    {
      "icon": Icon(Icons.home),
      "label": "Home",
      "route": Routes.home,
    },
    {
      "icon": Icon(Icons.add),
      "label": "Add Workout",
      "route": Routes.createWorkout,
    },
    {
      "icon": Icon(Icons.account_circle),
      "label": "MyProfile",
      "route": Routes.profile,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });

        widget.onTabTapped(index, staticScreens[index]["label"] as String);
        widget.navigatorKey.currentState!
            .pushNamed(staticScreens[index]["route"]);
      },
      items: staticScreens.map((item) {
        return BottomNavigationBarItem(
          icon: item["icon"] as Icon,
          label: item["label"] as String,
        );
      }).toList(),
    );
  }
}
