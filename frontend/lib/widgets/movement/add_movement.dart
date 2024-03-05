import 'package:flutter/material.dart';
import 'package:wod_board_app/models/workout.dart';
import 'package:wod_board_app/widgets/misc/add_duration_repetition_panel.dart';
import 'package:wod_board_app/widgets/misc/auto_complete_name.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({super.key, required this.onMovementChanged});

  final void Function(CreateMovement) onMovementChanged;

  @override
  State<AddMovement> createState() => _AddMovementState();
}

class _AddMovementState extends State<AddMovement> {
  CreateMovement movement = CreateMovement(
    position: 1,
    name: "",
    durationSeconds: 0,
    repetitions: 0,
  );

  void onDurationChanged(int newDurationSeconds) {
    movement.durationSeconds = newDurationSeconds;
    setState(() {
      widget.onMovementChanged(movement);
    });
  }

  void onRepetitionsChanged(int newRepetitions) {
    movement.repetitions = newRepetitions;
    setState(() {
      widget.onMovementChanged(movement);
    });
  }

  void onMovementNameChanged(String newMovementName) {
    movement.name = newMovementName;
    setState(() {
      widget.onMovementChanged(movement);
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
              "Movement #1",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          AsyncAutocompleteName(
            "movement",
            isRequired: true,
            onChanged: onMovementNameChanged,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          AddDurationRepetitionPanelList(
            onDurationChanged: onDurationChanged,
            onRepetitionsChanged: onRepetitionsChanged,
          ),
        ],
      ),
    );
  }
}
