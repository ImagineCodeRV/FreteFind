import 'package:admin_fretefind_web_panel/methods/common_methods.dart';
import 'package:admin_fretefind_web_panel/widgets/drivers_data_list.dart';
import 'package:flutter/material.dart';

class DriversPage extends StatefulWidget {
  static const String id = "\webPageDrivers";
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
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
                  "Manage Drivers",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  cMethods.header(2, "Driver Id"),
                  cMethods.header(1, "Photo"),
                  cMethods.header(1, "Name"),
                  cMethods.header(1, "Car Details"),
                  cMethods.header(1, "Phone"),
                  cMethods.header(1, "Total Earnings"),
                  cMethods.header(1, "Action"),
                ],
              ),
              DriversDataList(),
            ],
          ),
        ),
      )
    );
  }
}
