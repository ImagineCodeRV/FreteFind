import 'package:flutter/material.dart';

import '../methods/common_methods.dart';

class UsersPage extends StatefulWidget {
  static const String id = "\webPageUsers";
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Manage Users",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    cMethods.header(2, "User Id"),
                    cMethods.header(1, "Name"),
                    cMethods.header(1, "User Email"),
                    cMethods.header(1, "Phone"),
                    cMethods.header(1, "Action"),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
