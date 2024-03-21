import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/misc/cirular_progress_indicator.dart";
import "package:wod_board_app/widgets/workouts/detail_rounds.dart";

class DetailWorkoutScreen extends StatelessWidget {
  const DetailWorkoutScreen({super.key, required this.workoutUUID});

  final String workoutUUID;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingProvider>(context);
    final apiService = ApiService(context);

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () =>
              settingsProvider.mainNavigatorKey.currentState!.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Back"),
        ),
        FutureBuilder(
          future: apiService.fetchData("/workouts/$workoutUUID"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedCircularProgressIndicator(
                width: 40,
                height: 40,
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              final workout = snapshot.data!;
              return Column(
                children: [
                  Text(workout["name"] ?? workout["workoutType"]),
                  Text(workout["description"] ?? ""),
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: DetailRounds(rounds: workout["rounds"])),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
