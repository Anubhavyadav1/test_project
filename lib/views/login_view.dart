import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_project/main.dart';
import 'package:test_project/views/verify_email_view.dart';

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
              print(userCredentials);
              final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                print("verified");
              } else {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/verify/", (route) => false);
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == "user-not-found") {
                print("User Not Found");
              } else {
                print("something else occurred");
              }
              print(e.code);
            }
          },
          style: const ButtonStyle(),
          child: const Text('LogIn'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/register/',
              (route) => false,
            );
          },
          child: const Text("Click here to Register!!"),
        )
      ]),
    );
  }
}
