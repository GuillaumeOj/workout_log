import 'package:basic_utils/basic_utils.dart';

class User {
  User({
    required this.isAnonymous,
    this.id,
    this.email,
    this.username,
  });

  bool isAnonymous;
  final String? id;
  final String? email;
  final String? username;

  @override
  String toString() {
    return 'User{id: $id, username: $username}';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        isAnonymous: false,
        id: json["id"],
        email: json["email"],
        username: json["username"],
      );
  Map<String, dynamic> toJson() => {
        "isAnonymous": isAnonymous,
        "id": id,
        "email": email,
        "username": username,
      };
}

class Token {
  Token({
    required this.accessToken,
    required this.tokenType,
  });

  final String accessToken;
  final String tokenType;

  @override
  String toString() {
    if (accessToken == "" || tokenType == "") {
      return "";
    } else {
      String capitalizedTokenType =
          StringUtils.capitalize(tokenType.toString());
      return '$capitalizedTokenType $accessToken';
    }
  }

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        tokenType: json["token_type"],
        accessToken: json["access_token"],
      );
  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
      };
}
