import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fretefind/authentication/signup_screen.dart';
import 'package:fretefind/global/global_var.dart';

import '../methods/commom_methods.dart';
import '../pages/home_page.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CommomMethods cMethods = CommomMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    if (!emailController.text.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email", context);
    } else if (passwordController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your phone must be atleast 6 or more characters.", context);
    } else {
      signInUser(); //register user
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFireBase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((errorMsg) {
      Navigator.pop(context);
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFireBase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userFireBase!.uid);
      usersRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => HomePage()));
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("Usuário Bloqueado", context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("Usuário não Existe", context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 120),
              Image.asset(
                'assets/images/logo.png',
                height: 160,
                width: 160,
              ),
              SizedBox(height: 100),
              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 22),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                        onPressed: () {
                          checkIfNetworkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 10),
                        ),
                        child: const Text('Login'))
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const SignupScreen()));
                  },
                  child: const Text(
                    "Don\'t have an Account? Register here",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
