import 'package:flutter/material.dart';
import 'package:wod_board_app/widgets/auto_complete/auto_complete_name.dart';
import 'package:wod_board_app/widgets/misc/add_duration_repetition_panel.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({super.key});

  @override
  State<AddMovement> createState() => _AddMovementState();
}

class _AddMovementState extends State<AddMovement> {
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
      child: const Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Movement #1",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          AsyncAutocompleteName("movement"),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          AddDurationRepetitionPanelList(),
        ],
      ),
    );
  }
}
