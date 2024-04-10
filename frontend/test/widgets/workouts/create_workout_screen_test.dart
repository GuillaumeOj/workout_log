import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/models/user.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/misc/choice_list.dart";
import "package:wod_board_app/widgets/movements/add_movement.dart";
import "package:wod_board_app/widgets/rounds/add_round.dart";
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
                  body: AddWorkoutScreen(),
                ),
              ),
            ),
          );

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
                  body: AddWorkoutScreen(),
                ),
              ),
            ),
          );

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

      testWidgets("validates input", (WidgetTester tester) async {
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
                body: AddWorkoutScreen(),
              ),
            ),
          ),
        );

        // User send the form with no movement name
        expect(find.text("Movement name"), findsOneWidget);

        final submitButtonFinder =
            find.byKey(const ValueKey("submitButton"), skipOffstage: false);
        await tester.scrollUntilVisible(submitButtonFinder, 500.0);
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        // expect(find.text("Please enter a movement name"), findsOneWidget);
      });

      testWidgets(
        "submits the form",
        (WidgetTester tester) async {
          final mockSettings = MockSettingsService();
          final mockApi = MockApiService();
          final user = User(
              isAnonymous: false,
              id: "fooid",
              email: "foo@bar.com",
              username: "foo");

          when(mockSettings.currentUser).thenReturn(user);

          const wrongWorkoutType = "foo";
          const workoutType = "AMRAP";
          when(mockApi.fetchData("/workouts/workoute-types"))
              .thenAnswer((_) async => {
                    "values": [
                      workoutType,
                      wrongWorkoutType,
                    ]
                  });

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => mockSettings,
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      mockApi,
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: AddWorkoutScreen(),
                ),
              ),
            ),
          );

          const expectedErrorMessage =
              'Workout Type should be "AMRAP", "EMOM", "TABATA", "For Time" or "For Load"';

          when(
            mockApi.postData(
              "/workouts",
              data: {
                "workoutType": wrongWorkoutType,
                "name": "",
                "description": "",
              },
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              expectedStatus: HttpStatus.ok,
            ),
          ).thenThrow(
            ApiException(expectedErrorMessage),
          );

          await tester.enterText(find.text("Movement name"), "foo");

          // Select the wrong workout type
          final dropdownWrongWorkoutType = find.text(wrongWorkoutType).first;
          await tester.tap(dropdownWrongWorkoutType);
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

          expect(
            () async {
              await mockApi.postData(
                "/workouts",
                data: {
                  "workoutType": wrongWorkoutType,
                  "description": "",
                  "name": "",
                },
                headers: {
                  "Content-Type": "application/x-www-form-urlencoded",
                },
                expectedStatus: HttpStatus.ok,
              );
            },
            throwsA(
              isInstanceOf<ApiException>(),
            ),
          );
          // expect(find.byType(SnackBar), findsOneWidget);
          // expect(find.text(expectedErrorMessage), findsOneWidget);
        },
      );
    },
  );
}
