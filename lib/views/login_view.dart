import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test_project/firebase_options.dart';

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
      appBar: AppBar(
        title: const Text('LogIn'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(children: [
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
                      final userCredentials = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      print(userCredentials);
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
              ]);
            default:
              return const Text('Loading.....');
          }
        },
      ),
    );
  }
}