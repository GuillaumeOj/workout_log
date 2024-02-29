import 'package:flutter/material.dart';
import 'package:wod_board_app/widgets/auto_complete/auto_complete_name.dart';
import 'package:wod_board_app/widgets/duration/add_duration.dart';

const Duration debounceDuration = Duration(milliseconds: 500);

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            AsyncAutocompleteName("equipment"),
            AsyncAutocompleteName("movement"),
            AddDuration(),
          ]),
        ),
      ],
    );
  }
}
