import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wod_board_app/widgets/misc/choice_list.dart';
import 'package:wod_board_app/widgets/round/add_round.dart';

class AddWorkoutForm extends StatefulWidget {
  const AddWorkoutForm({super.key});

  @override
  State<AddWorkoutForm> createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Name",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a name for the workout";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Description",
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownListFromAPI(
                  path: 'workouts/workout-types',
                  onSelected: (String value) {
                    log(value);
                  },
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
            ),
          ),
          const AddRound(),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Processing Data'),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
