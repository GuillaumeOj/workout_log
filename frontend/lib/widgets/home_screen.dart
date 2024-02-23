import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wod_board_app/api.dart';
import 'package:wod_board_app/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingProvider>(context);
    var apiService = ApiService(settingsProvider);
    return Center(
      child: Column(
        children: [
          const Text("Home Screen"),
          FutureBuilder(
              future: apiService.fetchData("/"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  var data = snapshot.data;
                  return Text("Fetched data: $data");
                }
              }),
        ],
      ),
    );
  }
}
