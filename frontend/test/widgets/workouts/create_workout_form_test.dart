import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/models/user.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/bottom_bar.dart";
import "package:wod_board_app/widgets/misc/auto_complete_name.dart";
import "package:wod_board_app/widgets/misc/choice_list.dart";
import "package:wod_board_app/widgets/movements/add_movement.dart";
import "package:wod_board_app/widgets/rounds/add_round.dart";
import "package:wod_board_app/widgets/workouts/create_workout_form.dart";

@GenerateNiceMocks([
  MockSpec<SettingsService>(),
  MockSpec<ApiService>(),
  MockSpec<BottomBarState>()
])
import "create_workout_form_test.mocks.dart";

void main() {
  group(
    "CreateWorkoutForm",
    () {
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
                  body: SingleChildScrollView(
                    child: CreateWorkoutForm(),
                  ),
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
                body: SingleChildScrollView(
                  child: CreateWorkoutForm(),
                ),
              ),
            ),
          ),
        );

        // User send the form with no movement name
        expect(find.text("Movement name"), findsOneWidget);

        final buttonFinder = find.byType(ElevatedButton);
        expect(buttonFinder, findsOneWidget);

        await tester.ensureVisible(buttonFinder);
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        expect(find.text("Please enter a movement name"), findsOneWidget);
      });

      testWidgets(
        "submits the form with wrong values",
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
          when(mockApi.fetchData("workouts/workout-types"))
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
                ChangeNotifierProvider<BottomBarState>(
                  create: (_) => MockBottomBarState(),
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      mockApi,
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: CreateWorkoutForm(),
                  ),
                ),
              ),
            ),
          );

          const expectedWorkoutTypeErrorMessage =
              'Workout Type should be "AMRAP", "EMOM", "TABATA", "For Time" or "For Load"';

          when(
            mockApi.postData(
              "/workouts",
              data: {
                "workoutType": wrongWorkoutType,
                "name": "",
                "description": "",
                "rounds": null,
              },
            ),
          ).thenThrow(
            ApiException(expectedWorkoutTypeErrorMessage),
          );

          final movementNameFinder = find.byType(AsyncAutocompleteName);
          await tester.ensureVisible(movementNameFinder);
          await tester.enterText(movementNameFinder, "foo");

          final buttonFinder = find.byType(ElevatedButton);

          // Select the wrong workout type
          final dropdownListFromAPIFinder = find.byWidgetPredicate(
            (Widget widget) => widget is DropdownListFromAPI,
          );
          final dropdownListFromAPI = tester.widget<DropdownListFromAPI>(
            dropdownListFromAPIFinder,
          );
          (dropdownListFromAPI.onChanged)(wrongWorkoutType);
          await tester.pumpAndSettle();

          // Check the selected value is now 'foo'
          final createWorkoutFormState = tester.state<CreateWorkoutFormState>(
            find.byType(
              CreateWorkoutForm,
            ),
          );
          expect(createWorkoutFormState.selectedWorkoutType, wrongWorkoutType);

          await tester.ensureVisible(buttonFinder);
          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          expect(
            () async {
              await mockApi.postData(
                "/workouts",
                data: {
                  "workoutType": wrongWorkoutType,
                  "description": "",
                  "name": "",
                  "rounds": null,
                },
              );
            },
            throwsA(
              isInstanceOf<ApiException>(),
            ),
          );
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text(expectedWorkoutTypeErrorMessage), findsOneWidget);
        },
      );

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

          const workoutType = "AMRAP";
          when(
            mockApi.fetchData("workouts/workout-types"),
          ).thenAnswer(
            (_) async => {
              "values": [
                workoutType,
              ]
            },
          );

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => mockSettings,
                ),
                ChangeNotifierProvider<BottomBarState>(
                  create: (_) => MockBottomBarState(),
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      mockApi,
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: CreateWorkoutForm(),
                  ),
                ),
              ),
            ),
          );
          // User send a valid form
          when(
            mockApi.postData(
              "/workouts",
              data: {
                "workoutType": workoutType,
                "name": "",
                "description": "",
                "rounds": null,
              },
            ),
          ).thenAnswer(
            (_) async => {
              "workoutType": workoutType,
              "name": "",
              "description": "",
              "rounds": [],
            },
          );

          final movementNameFinder = find.byType(AsyncAutocompleteName);
          await tester.ensureVisible(movementNameFinder);
          await tester.enterText(movementNameFinder, "foo");

          // Select the correct workout type
          final dropdownListFromAPIFinder = find.byWidgetPredicate(
            (Widget widget) => widget is DropdownListFromAPI,
          );
          final dropdownListFromAPI = tester.widget<DropdownListFromAPI>(
            dropdownListFromAPIFinder,
          );
          (dropdownListFromAPI.onChanged)(workoutType);
          await tester.pumpAndSettle();

          // Check the selected value is now 'AMRAP'
          final createWorkoutFormState = tester.state<CreateWorkoutFormState>(
            find.byType(
              CreateWorkoutForm,
            ),
          );
          expect(createWorkoutFormState.selectedWorkoutType, workoutType);

          final buttonFinder = find.byType(ElevatedButton);
          await tester.ensureVisible(buttonFinder);
          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          verify(
            mockApi.postData(
              "/workouts",
              data: {
                "workoutType": workoutType,
                "description": "",
                "name": "",
                "rounds": null,
              },
            ),
          ).called(1);
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text("Workout created"), findsOneWidget);
        },
      );
    },
  );
}
