import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:test_project/constants/routes.dart';
import 'package:test_project/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: const Text("Register"),
      ),
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password,
              );
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              Navigator.of(context).pushNamed(verifyRoute);
              devtools.log(userCredentials.toString());
            } on FirebaseAuthException catch (e) {
              if (e.code == "weak-password") {
                devtools.log("Weak Password");
                showErrorDialog(
                  context,
                  'Weak Password',
                );
              } else if (e.code == "invalid-email") {
                devtools.log("Invalid Email");
                showErrorDialog(
                  context,
                  'Invalid Email',
                );
              } else {
                showErrorDialog(
                  context,
                  'Error ${e.code}',
                );
              }
            } catch (e) {
              showErrorDialog(
                context,
                'Error ${e.toString()}',
              );
            }
          },
          style: const ButtonStyle(),
          child: const Text('Register'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text(
              "Already registered? Login here!!",
            ))
      ]),
    );
  }
}
