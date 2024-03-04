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
  final GlobalKey _autocompleteFormKey = GlobalKey();
  double _autocompleFormFieldWidth = 0.0;

  late Iterable<String> _lastOptions = <String>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _autocompleteFormKey.currentContext?.findRenderObject() as RenderBox;
      setState(() {
        _autocompleFormFieldWidth = renderBox.size.width;
      });
    });
  }

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
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<String> onSelected,
        Iterable<String> options,
      ) {
        return LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: _autocompleFormFieldWidth,
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: options
                        .map((String option) => ListTile(
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextFormField(
          key: _autocompleteFormKey,
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
          },
          decoration: InputDecoration(
            labelText: "${StringUtils.capitalize(widget.searchType)} name",
            labelStyle: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        );
      },
    );
  }
}
