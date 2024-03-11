import "package:flutter/material.dart";
import "package:wod_board_app/widgets/home_screen.dart";
import "package:wod_board_app/widgets/profile_screen.dart";
import "package:wod_board_app/widgets/workouts/create_workout_screen.dart";
import "package:wod_board_app/widgets/workouts/detail_workout_screen.dart";
import "package:wod_board_app/widgets/workouts/list_workout_screen.dart";

class Routes {
  static const String home = "/";
  static const String createWorkout = "/workouts/create";
  static const String myWorkouts = "/workouts/list";
  static const String detailWorkout = "/workouts/detail";
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
        return MaterialPageRoute(builder: (_) => const ListWorkoutsScreen());
      case Routes.detailWorkout:
        final String workoutUUID = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailWorkoutScreen(workoutUUID: workoutUUID),
        );
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
