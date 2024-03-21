import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/misc/cirular_progress_indicator.dart";

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

String formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final remainingSeconds = duration.inSeconds % 60;

  if (minutes == 0) {
    return "In $remainingSeconds seconds";
  } else {
    var minutesLabel = minutes > 1 ? "minutes" : "minute";
    var remainingSecondsLabel =
        remainingSeconds > 0 ? " and $remainingSeconds seconds" : "";
    return "In $minutes $minutesLabel$remainingSecondsLabel";
  }
}

class DetailRounds extends StatelessWidget {
  const DetailRounds({super.key, required this.rounds});
  final List<dynamic> rounds;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rounds.map(
        (round) {
          final duration = Duration(seconds: round["durationSeconds"]);
          final repetitions = round["repetitions"];
          final position = round["position"];

          return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text("Round #$position / "),
                    if (duration.inSeconds > 0) Text(formatDuration(duration)),
                    if (repetitions > 0)
                      Text("${repetitions.toString()} times"),
                  ],
                ),
                const SizedBox(height: 10),
                DetailMovements(movements: round["movements"]),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}

class DetailMovements extends StatelessWidget {
  const DetailMovements({super.key, required this.movements});
  final List<dynamic> movements;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: movements.map((movement) {
        final duration = Duration(seconds: movement["durationSeconds"]);
        final repetitions = movement["repetitions"];
        final name = movement["name"];

        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  const Icon(Icons.arrow_right),
                  if (repetitions > 0) Text("${repetitions.toString()} "),
                  Text("$name"),
                  if (duration.inSeconds > 0)
                    Text(" ${formatDuration(duration)}"),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
