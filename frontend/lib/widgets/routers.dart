import "package:flutter/material.dart";
import "package:wod_board_app/widgets/home_screen.dart";
import "package:wod_board_app/widgets/profile_screen.dart";
import "package:wod_board_app/widgets/workouts/create_workout_screen.dart";

class Routes {
  static const String home = "/";
  static const String createWorkout = "/workouts/create";
  static const String myWorkouts = "/workouts/list";
  static const String profile = "/users/profile";
}

class WorkoutRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.createWorkout:
        return MaterialPageRoute(builder: (_) => const AddWorkoutScreen());
      case Routes.myWorkouts:
        return MaterialPageRoute(builder: (_) => const AddWorkoutScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}