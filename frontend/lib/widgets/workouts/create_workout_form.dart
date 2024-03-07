import "dart:developer";

import "package:flutter/material.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/models/workout.dart";
import "package:wod_board_app/widgets/misc/choice_list.dart";
import "package:wod_board_app/widgets/rounds/add_round.dart";

class AddWorkoutForm extends StatefulWidget {
  const AddWorkoutForm({super.key});

  @override
  State<AddWorkoutForm> createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late String _selectedWorkoutType;
  CreateWorkout workout = CreateWorkout(name: "", workoutType: "AMRAP");

  void onRoundChanged(CreateRound round) {
    workout.rounds = [round];
  }

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService(context);
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
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
            controller: _descriptionController,
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
                  path: "workouts/workout-types",
                  onSelected: (String value) {
                    _selectedWorkoutType = value;
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
          AddRound(onRoundChanged: onRoundChanged),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                String name = _nameController.text;
                String description = _descriptionController.text;
                String workoutType = _selectedWorkoutType;

                workout.name = name;
                workout.description = description;
                workout.workoutType = workoutType;

                try {
                  await apiService.postData(
                    "/workouts",
                    data: workout.toJson(),
                  );

                  if (mounted) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Workout created"),
                      ),
                    );
                  }
                } catch (e) {
                  log(e.toString());
                }
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
