import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/models/workout.dart";
import "package:wod_board_app/widgets/bottom_bar.dart";
import "package:wod_board_app/widgets/misc/choice_list.dart";
import "package:wod_board_app/widgets/rounds/add_round.dart";
import "package:wod_board_app/widgets/routers.dart";

class CreateWorkoutForm extends StatefulWidget {
  const CreateWorkoutForm({super.key});

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

abstract class CreateWorkoutFormState extends State<CreateWorkoutForm> {
  String? get selectedWorkoutType;
}

class _CreateWorkoutFormState extends CreateWorkoutFormState {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedWorkoutType;
  CreateWorkout workout = CreateWorkout(name: "", workoutType: "AMRAP");

  @override
  String? get selectedWorkoutType => _selectedWorkoutType;

  void onRoundChanged(CreateRound round) {
    workout.rounds = [round];
  }

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiService>(context);

    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
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
                  onChanged: (String value) {
                    setState(() {
                      _selectedWorkoutType = value;
                    });
                  },
                  selectedChoice: _selectedWorkoutType,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Please select a workout type";
                    }
                    return null;
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
                String? workoutType = _selectedWorkoutType;

                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final bottomBarState =
                    Provider.of<BottomBarState>(context, listen: false);
                final navigator = Navigator.of(context);

                workout.name = name;
                workout.description = description;
                workout.workoutType = workoutType ?? "";

                try {
                  await api.postData(
                    "/workouts",
                    data: workout.toJson(),
                  );

                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("Workout created"),
                      ),
                    );

                    bottomBarState.updateIndexFromRoute(Routes.home);
                    navigator.pushNamed(Routes.home);
                  }
                } catch (error) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(error.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
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
