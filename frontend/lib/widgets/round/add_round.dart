import 'package:flutter/material.dart';
import 'package:wod_board_app/models/workout.dart';
import 'package:wod_board_app/widgets/misc/add_duration_repetition_panel.dart';
import 'package:wod_board_app/widgets/movement/add_movement.dart';

class AddRound extends StatefulWidget {
  const AddRound({super.key, required this.onRoundChanged});

  final void Function(CreateRound) onRoundChanged;

  @override
  State<AddRound> createState() => _AddRoundState();
}

class _AddRoundState extends State<AddRound> {
  CreateRound round = CreateRound(
    position: 1,
    durationSeconds: 0,
    repetitions: 0,
  );

  void onDurationChanged(int newDurationSeconds) {
    round.durationSeconds = newDurationSeconds;
    setState(() {
      widget.onRoundChanged(round);
    });
  }

  void onRepetitionsChanged(int newRepetition) {
    round.repetitions = newRepetition;
    setState(() {
      widget.onRoundChanged(round);
    });
  }

  void onMovementChanged(CreateMovement newMovement) {
    round.movements = [newMovement];
    setState(() {
      widget.onRoundChanged(round);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Round #1",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          AddDurationRepetitionPanelList(
            onDurationChanged: onDurationChanged,
            onRepetitionsChanged: onRepetitionsChanged,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          AddMovement(
            onMovementChanged: onMovementChanged,
          ),
        ],
      ),
    );
  }
}
