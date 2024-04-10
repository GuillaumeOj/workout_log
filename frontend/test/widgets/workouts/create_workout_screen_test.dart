import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/models/user.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/login_form.dart";
import "package:wod_board_app/widgets/misc/choice_list.dart";
import "package:wod_board_app/widgets/movements/add_movement.dart";
import "package:wod_board_app/widgets/rounds/add_round.dart";
import "package:wod_board_app/widgets/workouts/create_workout_form.dart";
import "package:wod_board_app/widgets/workouts/create_workout_screen.dart";

@GenerateNiceMocks([MockSpec<SettingsService>(), MockSpec<ApiService>()])
import "create_workout_screen_test.mocks.dart";

void main() {
  group(
    "CreateWorkoutScreen",
    () {
      testWidgets(
        "login form displayed if not logged in",
        (WidgetTester tester) async {
          final mockSettings = MockSettingsService();
          when(mockSettings.currentUser).thenReturn(User(isAnonymous: true));

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => mockSettings,
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      MockApiService(),
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: CreateWorkoutScreen(),
                ),
              ),
            ),
          );

          expect(find.byType(LoginForm), findsOneWidget);
          expect(find.byType(TextFormField), findsExactly(2));
          expect(find.byType(ElevatedButton), findsOneWidget);
          expect(find.text("Email"), findsOneWidget);
          expect(find.text("Password"), findsOneWidget);
        },
      );

      testWidgets(
        "renders correctly",
        (WidgetTester tester) async {
          final mockSettings = MockSettingsService();
          final user = User(
              isAnonymous: false,
              id: "fooid",
              email: "foo@bar.com",
              username: "foo");
          when(mockSettings.currentUser).thenReturn(user);

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => mockSettings,
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      MockApiService(),
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: CreateWorkoutScreen(),
                ),
              ),
            ),
          );

          expect(find.byType(CreateWorkoutForm), findsOneWidget);

          // Name and description fields
          expect(find.byType(TextFormField), findsAtLeast(2));
          expect(find.text("Name"), findsOneWidget);
          expect(find.text("Description"), findsOneWidget);

          // Workout type
          expect(find.byType(DropdownListFromAPI), findsOneWidget);

          expect(find.byType(AddRound), findsOneWidget);
          expect(find.byType(AddMovement), findsOneWidget);
          expect(find.byType(ElevatedButton), findsOneWidget);
        },
      );
    },
  );
}
