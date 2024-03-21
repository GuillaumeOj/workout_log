import "package:flutter/material.dart";
import "package:wod_board_app/widgets/misc/durations.dart";

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
