import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fretefind/authentication/login_screen.dart';
import 'package:fretefind/methods/commom_methods.dart';
import 'package:fretefind/pages/home_page.dart';
import 'package:fretefind/widgets/loading_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  CommomMethods cMethods = CommomMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation() {
    if (userNameController.text.trim().length < 3) {
      cMethods.displaySnackBar(
          "Your name must be atleast 4 or more characters.", context);
    } else if (userPhoneController.text.trim().length < 10) {
      cMethods.displaySnackBar(
          "Your phone must be atleast 11 or more characters.", context);
    } else if (!emailController.text.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email", context);
    } else if (passwordController.text.trim().length < 5) {
      cMethods.displaySnackBar(
          "Your phone must be atleast 6 or more characters.", context);
    } else {
      registerNewUser(); //register user
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registrando sua Conta..."),
    );

    final User? userFireBase = (
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ).catchError((errorMsg){
        Navigator.pop(context);
        cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;
    if(!context.mounted) return;

    Navigator.pop(context);
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users').child(userFireBase!.uid);
    Map userDataMap = {
      "name": userNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": userPhoneController.text.trim(),
      "id": userFireBase.uid,
      "blockStatus": "no",
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
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
                "Create a User\'s Account",
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
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Name",
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
                      controller: userPhoneController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Telefone",
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
                        child: const Text('Sign up'))
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const LoginScreen()));
                  },
                  child: const Text(
                    "Already have an Account? Login Here",
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
