import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wod_board_app/api.dart';
import 'package:wod_board_app/settings.dart';
import 'package:wod_board_app/widgets/duration/add_duration.dart';

const Duration debounceDuration = Duration(milliseconds: 500);

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: [
            _AsyncAutocomplete("equipment"),
            _AsyncAutocomplete("movement"),
            AddDuration(),
          ]),
        ),
      ],
    );
  }
}

class _AsyncAutocomplete extends StatefulWidget {
  const _AsyncAutocomplete(this.searchType);

  final String searchType;

  @override
  State<_AsyncAutocomplete> createState() => _AsyncAutocompleteState();
}

class _AsyncAutocompleteState extends State<_AsyncAutocomplete> {
  String? _searchingWithQuery;

  late Iterable<String> _lastOptions = <String>[];

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingProvider>(context);
    var apiService = ApiService(settingsProvider);

    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        _searchingWithQuery = textEditingValue.text;
        final Iterable<String> options = await apiService.searchName(
            _searchingWithQuery!, widget.searchType);

        if (_searchingWithQuery != textEditingValue.text) {
          return _lastOptions;
        }

        _lastOptions = options;

        return options;
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            labelText: StringUtils.capitalize(widget.searchType),
          ),
        );
      },
    );
  }
}
