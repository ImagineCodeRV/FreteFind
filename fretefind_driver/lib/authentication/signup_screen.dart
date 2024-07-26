import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fretefind_driver/pages/dashboard.dart';
import 'package:image_picker/image_picker.dart';

import '../methods/commom_methods.dart';
import '../widgets/loading_dialog.dart';
import 'login_screen.dart';

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
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleNumberController = TextEditingController();
  TextEditingController vehicleSizeController = TextEditingController();
  CommomMethods cMethods = CommomMethods();
  XFile? imageFile;
  String urlUploadedImage = "";

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    if(imageFile != null){
      signUpFormValidation();
    }else{
      cMethods.displaySnackBar("Por favor, escolha uma imagem de perfil", context);
    }
  }

  uploadImageToStorage() async {
    String imageIdName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceImage = FirebaseStorage.instance.ref().child("Images").child(imageIdName);
    UploadTask uploadTask = referenceImage.putFile(File(imageFile!.path));
    TaskSnapshot snapshot = await uploadTask;
    urlUploadedImage = await snapshot.ref.getDownloadURL();
    setState(() {
      urlUploadedImage;
    });
    registerNewDriver();
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
    } else if (vehicleModelController.text.trim().isEmpty) {
      cMethods.displaySnackBar(
          "Campo não pode ser em branco.", context);
    } else if (vehicleSizeController.text.trim().isEmpty) {
      cMethods.displaySnackBar(
          "Seu carro é Pequeno, Medio, Grande", context);
    } else if (vehicleNumberController.text.isEmpty) {
      cMethods.displaySnackBar(
          "Digite a Placa do Seu veiculo", context);
    } else {
      uploadImageToStorage();
      //register user
    }
  }

  registerNewDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "Registrando sua Conta..."),
    );

    final User? userFireBase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
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
    DatabaseReference usersRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(userFireBase!.uid);
    Map driverCarInfo = {
      "carModel": vehicleModelController.text.trim(),
      "carSize": vehicleSizeController.text.trim(),
      "carNumberBoard": vehicleNumberController.text.trim(),
    };
    Map userDataMap = {
      "photo": urlUploadedImage,
      "carDetails": driverCarInfo,
      "name": userNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": userPhoneController.text.trim(),
      "id": userFireBase.uid,
      "blockStatus": "no",
    };
    usersRef.set(userDataMap);

    Navigator.push(context, MaterialPageRoute(builder: (c) => Dashboard()));
  }

  chooseImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        imageFile = pickedFile;
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
              const SizedBox(height: 100),
              imageFile == null ?
              const CircleAvatar(
                radius: 86,
                backgroundImage: AssetImage("assets/images/avatarman.png"),
              ) : Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(
                      File(
                        imageFile!.path,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  chooseImageFromGallery();
                },
                child: const Text(
                  "Selecione sua Foto",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                    TextField(
                      controller: vehicleModelController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Veículo",
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
                      controller: vehicleSizeController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Tamanho do Veiculo",
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
                      controller: vehicleNumberController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Placa do Carro",
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
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
