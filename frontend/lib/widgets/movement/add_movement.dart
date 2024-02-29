import 'package:flutter/material.dart';
import 'package:wod_board_app/widgets/auto_complete/auto_complete_name.dart';
import 'package:wod_board_app/widgets/duration/add_duration.dart';
import 'package:wod_board_app/widgets/repetition/add_repetition.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({super.key});

  @override
  State<AddMovement> createState() => _AddMovementState();
}

class _AddMovementState extends State<AddMovement> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
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
          const AsyncAutocompleteName("movement"),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
          ),
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                _isExpanded = isExpanded;
              });
            },
            children: <ExpansionPanel>[
              ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return const ListTile(
                    title: Text('Repetition / Duration'),
                  );
                },
                body: const Padding(
                  padding: EdgeInsets.fromLTRB(
                    15.0,
                    0,
                    15.0,
                    15.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AddDuration(),
                      AddRepetition(),
                    ],
                  ),
                ),
                isExpanded: _isExpanded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
