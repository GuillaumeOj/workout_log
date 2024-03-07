import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wod_board_app/settings.dart';
import 'package:wod_board_app/widgets/workouts/create_workout_form.dart';
import 'package:wod_board_app/widgets/login_form.dart';

const Duration debounceDuration = Duration(milliseconds: 500);

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingProvider>(context);
    var currentUser = settingsProvider.currentUser;

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: currentUser.isAnonymous == true
              ? const LoginForm()
              : const AddWorkoutForm(),
        ),
      ],
    );
  }
}
