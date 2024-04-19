import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/models/user.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/logout_form.dart";

@GenerateNiceMocks([MockSpec<SettingsService>()])
import "logout_form_test.mocks.dart";

void main() {
  group(
    "LogoutForm",
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
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: LogoutForm(),
                ),
              ),
            ),
          );

          expect(find.byType(ElevatedButton), findsOneWidget);
          expect(find.text("Logout"), findsOneWidget);
        },
      );

      testWidgets(
        "user is logged out",
        (WidgetTester tester) async {
          final mockSettings = MockSettingsService();

          final user = User(
            isAnonymous: false,
            id: "fooid",
            email: "foo@bar.com",
            username: "foo",
          );
          when(mockSettings.currentUser).thenReturn(user);

          await tester.pumpWidget(
            MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsService>(
                  create: (_) => mockSettings,
                ),
              ],
              child: const MaterialApp(
                home: Scaffold(
                  body: LogoutForm(),
                ),
              ),
            ),
          );

          await tester.tap(find.byType(ElevatedButton));
          await tester.pumpAndSettle();

          verify(
            mockSettings.setCurrentUser(any),
          ).called(1);
          verify(
            mockSettings.setCurrentUsetToken(null),
          ).called(1);
        },
      );
    },
  );
}
