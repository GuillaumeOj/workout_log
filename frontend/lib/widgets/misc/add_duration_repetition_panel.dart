import "package:flutter/material.dart";
import "package:wod_board_app/widgets/misc/add_duration.dart";
import "package:wod_board_app/widgets/misc/add_repetition.dart";

class AddDurationRepetitionPanelList extends StatefulWidget {
  const AddDurationRepetitionPanelList({
    super.key,
    required this.onDurationChanged,
    required this.onRepetitionsChanged,
  });

  final void Function(int) onDurationChanged;
  final void Function(int) onRepetitionsChanged;

  @override
  State<AddDurationRepetitionPanelList> createState() =>
      _AddDurationRepetitionPanelListState();
}

class _AddDurationRepetitionPanelListState
    extends State<AddDurationRepetitionPanelList> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text("Repetition / Duration"),
            );
          },
          body: Padding(
            padding: const EdgeInsets.fromLTRB(
              15.0,
              0,
              15.0,
              15.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddDuration(onDurationChanged: widget.onDurationChanged),
                AddRepetition(onRepetitionChanged: widget.onRepetitionsChanged),
              ],
            ),
          ),
          isExpanded: _isExpanded,
        ),
      ],
    );
  }
}
