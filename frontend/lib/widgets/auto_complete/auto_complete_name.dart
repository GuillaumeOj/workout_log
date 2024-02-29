import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wod_board_app/api.dart';
import 'package:wod_board_app/settings.dart';

class AsyncAutocompleteName extends StatefulWidget {
  const AsyncAutocompleteName(this.searchType, {super.key});

  final String searchType;

  @override
  State<AsyncAutocompleteName> createState() => _AsyncAutocompleteNameState();
}

class _AsyncAutocompleteNameState extends State<AsyncAutocompleteName> {
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
