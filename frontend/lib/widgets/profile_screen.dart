import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:wod_board_app/models/user.dart";
import "package:wod_board_app/settings.dart";
import "package:wod_board_app/widgets/login_form.dart";
import "package:wod_board_app/widgets/logout_form.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<SettingsService>(context);
    var currentUser = settings.currentUser;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: currentUser.isAnonymous == true
            ? const LoginForm()
            : Column(
                children: [
                  ProfileForm(user: currentUser),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  const LogoutForm(),
                ],
              ),
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key, required this.user});

  final User user;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Username",
              labelText: "Username",
            ),
            initialValue: widget.user.username,
            validator: (username) {
              if (username == null || username.isEmpty) {
                return "Please provide a username";
              } else {
                return username;
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: "Email",
              labelText: "Email",
            ),
            keyboardType: TextInputType.emailAddress,
            initialValue: widget.user.email,
            validator: (email) {
              if (email == null || email.isEmpty) {
                return "Please provide an email";
              } else {
                return email;
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              if (_formkey.currentState!.validate()) {
                scaffoldMessenger.showSnackBar(
                    const SnackBar(content: Text("Informations updated!")));
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
