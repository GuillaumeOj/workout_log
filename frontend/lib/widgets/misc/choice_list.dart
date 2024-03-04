import 'package:flutter/material.dart';
import 'package:wod_board_app/api.dart';

class DropdownList extends StatefulWidget {
  const DropdownList(
      {super.key, required this.choices, required this.onSelected});

  final List<String> choices;
  final void Function(String) onSelected;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return DropdownMenu<String>(
        width: constraints.maxWidth,
        textStyle: const TextStyle(
          fontSize: 15,
        ),
        menuHeight: 150,
        initialSelection: widget.choices.first,
        dropdownMenuEntries:
            widget.choices.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(
            value: value,
            label: value,
          );
        }).toList(),
        onSelected: (String? value) {
          widget.onSelected(value!);
        },
      );
    });
  }
}

class DropdownListFromAPI extends StatefulWidget {
  const DropdownListFromAPI(
      {super.key, required this.path, required this.onSelected});

  final String path;
  final void Function(String) onSelected;

  @override
  State<DropdownListFromAPI> createState() => _DropdownListFromAPIState();
}

class _DropdownListFromAPIState extends State<DropdownListFromAPI> {
  @override
  Widget build(BuildContext context) {
    var apiService = ApiService(context);

    return FutureBuilder<List<String>>(
      future: fetchChoices(widget.path, apiService),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return DropdownList(
            choices: snapshot.data!,
            onSelected: widget.onSelected,
          );
        }
      },
    );
  }
}

Future<List<String>> fetchChoices(String path, ApiService apiService) async {
  final Map<String, dynamic> choices = await apiService.fetchData(path);

  return choices["values"]
      .map((choice) => choice.toString())
      .toList()
      .cast<String>();
}
