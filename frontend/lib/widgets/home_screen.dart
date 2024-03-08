import "package:flutter/material.dart";
import "package:wod_board_app/api.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var apiService = ApiService(context);
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
