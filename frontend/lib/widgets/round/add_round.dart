import 'package:flutter/material.dart';
import 'package:wod_board_app/widgets/misc/add_duration_repetition_panel.dart';
import 'package:wod_board_app/widgets/movement/add_movement.dart';

class AddRound extends StatefulWidget {
  const AddRound({super.key});

  @override
  State<AddRound> createState() => _AddRoundState();
}

class _AddRoundState extends State<AddRound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      child: const Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Round #1",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          AddDurationRepetitionPanelList(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          AddMovement(),
        ],
      ),
    );
  }
}
