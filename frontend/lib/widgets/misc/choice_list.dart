import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/widgets/misc/cirular_progress_indicator.dart";

class DropdownListFromAPI extends StatefulWidget {
  const DropdownListFromAPI({
    super.key,
    required this.path,
    required this.onChanged,
    required this.validator,
    required this.selectedChoice,
  });

  final String path;
  final String? selectedChoice;
  final void Function(String) onChanged;
  final Function(String) validator;

  @override
  State<DropdownListFromAPI> createState() => _DropdownListFromAPIState();
}

class _DropdownListFromAPIState extends State<DropdownListFromAPI> {
  @override
  Widget build(BuildContext context) {
    var api = Provider.of<ApiService>(context);

    return FutureBuilder<List<String>>(
      future: fetchChoices(widget.path, api),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedCircularProgressIndicator(
            width: 25,
            height: 25,
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return DropdownButtonFormField<String>(
            value: widget.selectedChoice ?? snapshot.data!.first,
            items: snapshot.data!.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                widget.onChanged(value!);
              });
            },
            validator: (value) {
              return widget.validator(value!);
            },
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
