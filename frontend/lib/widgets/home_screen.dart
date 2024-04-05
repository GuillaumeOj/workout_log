import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/widgets/misc/cirular_progress_indicator.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var api = Provider.of<ApiService>(context);
    return Center(
      child: Column(
        children: [
          const Text("Home Screen"),
          FutureBuilder(
              future: api.fetchData("/"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedCircularProgressIndicator(
                    width: 15,
                    height: 15,
                  );
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
