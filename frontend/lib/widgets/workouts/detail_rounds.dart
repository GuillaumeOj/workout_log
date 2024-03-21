import "package:flutter/material.dart";
import "package:wod_board_app/widgets/misc/durations.dart";
import "package:wod_board_app/widgets/workouts/detail_movements.dart";

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
