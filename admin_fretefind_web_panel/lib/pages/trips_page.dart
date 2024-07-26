import 'package:flutter/material.dart';

import '../methods/common_methods.dart';

class TripsPage extends StatefulWidget {
  static const String id = "\webPageTrips";
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
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
                    "Manage Trips",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    cMethods.header(2, "Trip Id"),
                    cMethods.header(1, "User Name"),
                    cMethods.header(1, "Driver Name"),
                    cMethods.header(1, "Car Details"),
                    cMethods.header(1, "Timing"),
                    cMethods.header(1, "Fare"),
                    cMethods.header(1, "View Details"),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}
