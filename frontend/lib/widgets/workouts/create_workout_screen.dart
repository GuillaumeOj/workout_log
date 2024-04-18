import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/workouts/create_workout_form.dart";
import "package:wod_board_app/widgets/login_form.dart";

const Duration debounceDuration = Duration(milliseconds: 500);

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsService>(context);
    var currentUser = settings.currentUser;

    return ListView(
      key: const Key("addWorkoutScreenListView"),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: currentUser.isAnonymous == true
              ? const LoginForm()
              : const CreateWorkoutForm(),
        ),
      ],
    );
  }
}
