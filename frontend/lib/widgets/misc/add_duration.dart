import 'package:flutter/material.dart';

class AddDuration extends StatefulWidget {
  const AddDuration({super.key});

  @override
  State<AddDuration> createState() => _AddDurationState();
}

class _AddDurationState extends State<AddDuration> {
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Duration",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _secondsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Seconds",
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            )),
            Expanded(
              child: TextFormField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Minutes",
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
