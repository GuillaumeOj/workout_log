import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/widgets/routers.dart";

const List<Map<String, dynamic>> staticScreens = [
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
    "icon": Icon(Icons.bar_chart),
    "label": "My Workouts",
    "route": Routes.myWorkouts,
  },
  {
    "icon": Icon(Icons.account_circle),
    "label": "MyProfile",
    "route": Routes.profile,
  },
];

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    required this.onTabTapped,
    required this.navigatorKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final void Function(String) onTabTapped;

  @override
  Widget build(BuildContext context) {
    final currentIndex = Provider.of<BottomBarState>(context).currentIndex;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.blue,
      currentIndex: currentIndex,
      onTap: (int index) {
        // Avoid navigating
        if (index == currentIndex) {
          return;
        }

        String newLabel = staticScreens[index]["label"];
        String newRoute = staticScreens[index]["route"];

        Provider.of<BottomBarState>(context, listen: false).updateIndex(index);
        onTabTapped(newLabel);
        navigatorKey.currentState!.pushNamed(newRoute);
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

class BottomBarState extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateIndexFromRoute(String route) {
    _currentIndex =
        staticScreens.indexWhere((element) => element["route"] == route);
    notifyListeners();
  }
}
