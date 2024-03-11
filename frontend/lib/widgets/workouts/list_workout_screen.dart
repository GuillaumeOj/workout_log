import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/login_form.dart";
import "package:wod_board_app/widgets/misc/cirular_progress_indicator.dart";
import "package:wod_board_app/widgets/routers.dart";

class ListWorkoutsScreen extends StatelessWidget {
  const ListWorkoutsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingProvider>(context);
    var currentUser = settingsProvider.currentUser;
    var apiService = ApiService(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: currentUser.isAnonymous == true
          ? const LoginForm()
          : FutureBuilder(
              future: apiService.listData("/workouts"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedCircularProgressIndicator(
                    width: 40,
                    height: 40,
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  var workouts = snapshot.data;
                  return ListView.builder(
                    itemCount: workouts!.length,
                    itemBuilder: (context, index) {
                      var workout = workouts[index];
                      return ListTile(
                        title: Text(workout["name"] ?? workout["workoutType"]),
                        subtitle: Text(workout["description"] ?? ""),
                        onTap: () {
                          settingsProvider.mainNavigatorKey.currentState!
                              .pushNamed(
                            Routes.detailWorkout,
                            arguments: workout["id"],
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
