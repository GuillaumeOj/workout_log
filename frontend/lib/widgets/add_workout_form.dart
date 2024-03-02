import 'package:flutter/material.dart';
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
          const AddRound(),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 15.0,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
