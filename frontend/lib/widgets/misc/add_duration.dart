import "package:flutter/material.dart";

class AddDuration extends StatefulWidget {
  const AddDuration({super.key, required this.onDurationChanged});

  final void Function(int) onDurationChanged;

  @override
  State<AddDuration> createState() => _AddDurationState();
}

class _AddDurationState extends State<AddDuration> {
  final TextEditingController _secondsController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  Duration duration = const Duration();

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
                onChanged: (String value) {
                  duration = Duration(
                      minutes: duration.inMinutes, seconds: int.parse(value));
                  widget.onDurationChanged(duration.inSeconds);
                },
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
                onChanged: (String value) {
                  duration = Duration(
                      minutes: int.parse(value), seconds: duration.inSeconds);
                  widget.onDurationChanged(duration.inSeconds);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
