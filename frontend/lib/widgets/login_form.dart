import "dart:developer" as dev;
import "dart:io";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/api.dart";
import "package:wod_board_app/models/user.dart";
import "package:wod_board_app/settings.dart";

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsService>(context);
    var api = Provider.of<ApiService>(context);

    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: "Email",
              labelText: "Email",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your email";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter your password";
              }
              return null;
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),
          ElevatedButton(
            onPressed: () async {
              if (_formkey.currentState!.validate()) {
                String email = _emailController.text;
                String password = _passwordController.text;

                try {
                  var userTokenData = await api.postData("/users/token",
                      data: {"username": email, "password": password},
                      headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                      },
                      expectedStatus: HttpStatus.ok);

                  Token userToken = Token.fromJson(userTokenData);
                  settings.setCurrentUsetToken(userToken);
                } catch (error) {
                  dev.log("tokenError", error: error);
                }
              }

              if (settings.currentUserToken != null) {
                try {
                  var userData = await api.fetchData("/users/me");

                  User currentUser = User.fromJson(userData);
                  settings.setCurrentUser(currentUser);
                } catch (error) {
                  dev.log("userError", error: error);
                }
              }
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
