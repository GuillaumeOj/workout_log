import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:wod_board_app/models/user.dart";

class SettingsService extends ChangeNotifier {
  User _currentUser = User(isAnonymous: true);
  User get currentUser => _currentUser;

  Token? _currentUserToken;
  Token? get currentUserToken => _currentUserToken;

  final environnment = dotenv.get("ENV");
  final apiUrlHost = dotenv.get("API_URL_HOST");
  final apiUrlPort = dotenv.get("API_URL_PORT", fallback: "");

  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  void setCurrentUser(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  void setCurrentUsetToken(Token? newToken) {
    _currentUserToken = newToken;
    notifyListeners();
  }
}
