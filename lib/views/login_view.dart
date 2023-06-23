import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/constants/routes.dart';
import 'dart:developer' as devtools show log;
import '../utilities/show_error_dialog.dart';

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
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email,
                password: password,
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                notesRoute,
                (route) => false,
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == "user-not-found") {
                devtools.log("User Not Found");
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } else if (e.code == "wrong-password") {
                devtools.log("Wrong Password");
                await showErrorDialog(
                  context,
                  "Wrong Password",
                );
              } else {
                devtools.log(e.code);
                await showErrorDialog(
                  context,
                  'Error: ${e.code}',
                );
              }
            } catch (e) {
              devtools.log(e.toString());
              await showErrorDialog(
                context,
                e.toString(),
              );
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
