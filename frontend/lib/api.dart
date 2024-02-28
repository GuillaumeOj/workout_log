import 'dart:convert';
import 'dart:io';

import 'package:wod_board_app/settings.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final SettingProvider settingsProvider;

  ApiService(this.settingsProvider);

  String get scheme =>
      settingsProvider.environnment == "dev" ? "http" : "https";
  int get defaultPort => scheme == "http" ? 80 : 443;
  String get host => settingsProvider.apiUrlHost;
  int get port => settingsProvider.apiUrlPort != ""
      ? int.parse(settingsProvider.apiUrlPort)
      : defaultPort;

  Uri getUrl(String path, Map<String, dynamic> queryParameters) {
    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: path,
      queryParameters: queryParameters,
    );
  }

  Map<String, String> getHeaders(Map<String, String> headers) {
    var defaultHeaders = {"Content-Type": "application/json"};
    if (settingsProvider.currentUserToken != null) {
      defaultHeaders["Authorization"] =
          settingsProvider.currentUserToken.toString();
    }
    return {...defaultHeaders, ...headers};
  }

  Future<Map<String, dynamic>> fetchData(
    String path, {
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
  }) async {
    Uri fetchUrl = getUrl(path, queryParameters);
    var endpointHeaders = getHeaders(headers);

    final response = await http.get(fetchUrl, headers: endpointHeaders);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception(json.decode(response.body));
    }

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> postData(
    String path, {
    Map<String, dynamic> data = const {},
    Map<String, String> headers = const {},
    Map<String, dynamic> queryParameters = const {},
    int expectedStatus = HttpStatus.created,
  }) async {
    Uri postUrl = getUrl(path, queryParameters);
    var endpointHeaders = getHeaders(headers);
    Map<String, dynamic> body;

    if (endpointHeaders["Content-Type"] ==
        "application/x-www-form-urlencoded") {
      body = data;
    } else {
      body = json.encode(data) as Map<String, dynamic>;
    }
    final response =
        await http.post(postUrl, body: body, headers: endpointHeaders);

    if (response.statusCode != expectedStatus) {
      throw Exception(json.decode(response.body));
    }

    return json.decode(response.body);
  }

  Future<List<dynamic>> search(
    Map<String, dynamic> queryParameters, {
    Map<String, String> headers = const {},
    int expectedStatus = HttpStatus.ok,
  }) async {
    Uri searchUrl = getUrl("/search", queryParameters);
    var endpointHeaders = getHeaders(headers);

    final response = await http.get(searchUrl, headers: endpointHeaders);

    if (response.statusCode != expectedStatus) {
      throw Exception(json.decode(response.body));
    }

    return json.decode(response.body);
  }

  Future<Iterable<String>> searchName(
    String name,
    String type, {
    Map<String, String> headers = const {},
    int expectedStatus = HttpStatus.ok,
  }) async {
    if (name == "" || type == "") {
      return const Iterable<String>.empty();
    }

    final queryParameters = {type: name};
    final response = await search(queryParameters,
        headers: headers, expectedStatus: expectedStatus);

    return response.map((option) => option["name"].toString()).toList();
  }
}
