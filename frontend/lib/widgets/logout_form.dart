import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wod_board_app/models/user.dart';
import 'package:wod_board_app/settings.dart';

class LogoutForm extends StatefulWidget {
  const LogoutForm({super.key});

  @override
  State<LogoutForm> createState() => _LogoutFormState();
}

class _LogoutFormState extends State<LogoutForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var settingsProvider = Provider.of<SettingProvider>(context);

    return Form(
      key: _formkey,
      child: Column(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                settingsProvider.setCurrentUser(User(isAnonymous: true));
                settingsProvider.setCurrentUsetToken(null);
              },
              child: const Text("Logout")),
        ],
      ),
    );
  }
}
