import 'package:admin_fretefind_web_panel/dashboard/side_navigation_drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC45lfr21tPJE8wt4CkJA7ey1w-bHl5P8E",
        authDomain: "fretefind.firebaseapp.com",
        databaseURL: "https://fretefind-default-rtdb.firebaseio.com",
        projectId: "fretefind",
        storageBucket: "fretefind.appspot.com",
        messagingSenderId: "523952275460",
        appId: "1:523952275460:web:bf4864f8c1b756020bb551",
        measurementId: "G-YCN4XSSKWH"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: SideNavigationDrawer(),
    );
  }
}
