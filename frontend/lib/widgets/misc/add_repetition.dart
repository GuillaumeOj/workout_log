import "package:flutter/material.dart";

class AddRepetition extends StatefulWidget {
  const AddRepetition({super.key, required this.onRepetitionChanged});

  final void Function(int) onRepetitionChanged;

  @override
  State<AddRepetition> createState() => _AddRepetitionState();
}

class _AddRepetitionState extends State<AddRepetition> {
  final TextEditingController _repetitionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _repetitionsController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Repetitions",
            labelStyle: TextStyle(
              fontSize: 15.0,
            ),
          ),
          style: const TextStyle(
            fontSize: 15.0,
          ),
          onChanged: (String value) {
            widget.onRepetitionChanged(int.parse(value));
          },
        ),
      ],
    );
  }
}
