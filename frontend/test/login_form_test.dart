import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/login_form.dart";

@GenerateNiceMocks([MockSpec<SettingsService>(), MockSpec<ApiService>()])
import "login_form_test.mocks.dart";

void main() {
  group(
    "LoginForm",
    () {
      testWidgets(
        "renders correctly",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => MockSettingsService(),
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      MockApiService(),
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: LoginForm(),
                ),
              ),
            ),
          );

          expect(find.byType(TextFormField), findsNWidgets(2));
          expect(find.byType(ElevatedButton), findsOneWidget);
        },
      );

      testWidgets(
        "validates input",
        (WidgetTester tester) async {
          final mockApi = MockApiService();

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => MockSettingsService(),
                ),
                ProxyProvider<SettingsService, ApiService>(
                  update: (BuildContext context, SettingsService settings,
                          ApiService? apiService) =>
                      mockApi,
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: LoginForm(),
                ),
              ),
            ),
          );

          // User send the form with no email and no password
          await tester.enterText(find.byType(TextFormField).first, "");
          await tester.enterText(find.byType(TextFormField).last, "");
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

          expect(find.text("Please enter your email"), findsOneWidget);
          expect(find.text("Please enter your password"), findsOneWidget);

          // User send inccorect email
          const wrongEmail = "bar@foo.com";
          const email = "foo@bar.com";
          const password = "password";

          when(
            mockApi.postData(
              "/users/token",
              data: {
                "username": wrongEmail,
                "password": password,
              },
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              expectedStatus: HttpStatus.ok,
            ),
          ).thenThrow(
            ApiException("Username and/or password are wrong"),
          );

          await tester.enterText(find.byType(TextFormField).first, wrongEmail);
          await tester.enterText(find.byType(TextFormField).last, password);
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

          expect(
            () async {
              await mockApi.postData(
                "/users/token",
                data: {
                  "username": wrongEmail,
                  "password": password,
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
          expect(find.byType(SnackBar), findsOneWidget);
          expect(
              find.text("Username and/or password are wrong"), findsOneWidget);

          // User send the form with expected email and password
          await tester.enterText(find.byType(TextFormField).first, email);
          await tester.enterText(find.byType(TextFormField).last, password);
          await tester.tap(find.byType(ElevatedButton));
          await tester.pump();

          when(
            mockApi.postData(
              "/users/token",
              data: {
                "username": email,
                "password": password,
              },
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              expectedStatus: HttpStatus.ok,
            ),
          ).thenAnswer(
            (_) async => {
              "access_token": "foo_token",
              "token_type": "bearer",
            },
          );

          verify(
            mockApi.postData(
              "/users/token",
              data: {
                "username": email,
                "password": password,
              },
              headers: {
                "Content-Type": "application/x-www-form-urlencoded",
              },
              expectedStatus: HttpStatus.ok,
            ),
          ).called(1);
        },
      );
    },
  );
}
