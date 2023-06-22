import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/constants/routes.dart';
import 'package:test_project/main.dart';
import 'package:test_project/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(children: [
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Enter your Email Here',
          ),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          obscuringCharacter: "*",
          autocorrect: false,
          enableSuggestions: false,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            hintText: 'Enter password here',
          ),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              final userCredentials =
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                notesRoute,
                (route) => false,
              );
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                devtools.log("verified");
              } else {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(verifyRoute, (route) => false);
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == "user-not-found") {
                devtools.log("User Not Found");
              } else {
                devtools.log("something else occurred");
              }
              devtools.log(e.code);
            }
          },
          style: const ButtonStyle(),
          child: const Text('LogIn'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text("Click here to Register!!"),
        )
      ]),
    );
  }
}
