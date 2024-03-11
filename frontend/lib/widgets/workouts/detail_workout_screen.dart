import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/settings.dart";

class DetailWorkoutScreen extends StatelessWidget {
  const DetailWorkoutScreen({super.key, required this.workoutUUID});

  final String workoutUUID;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingProvider>(context);

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () =>
              settingsProvider.mainNavigatorKey.currentState!.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back"),
        ),
        Text(workoutUUID),
      ],
    );
  }
}
