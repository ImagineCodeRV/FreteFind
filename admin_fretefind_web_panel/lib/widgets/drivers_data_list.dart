import 'package:admin_fretefind_web_panel/methods/common_methods.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DriversDataList extends StatefulWidget {
  const DriversDataList({super.key});

  @override
  State<DriversDataList> createState() => _DriversDataListState();
}

class _DriversDataListState extends State<DriversDataList> {
  final driversRecordsFromDatabase =
      FirebaseDatabase.instance.ref().child("drivers");
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: driversRecordsFromDatabase.onValue,
        builder: (BuildContext context, snapshotData) {
          if (snapshotData.hasError) {
            return const Center(
              child: Text(
                "Error Occured. Try Later",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.pink,
                ),
              ),
            );
          }
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          Map dataMap = snapshotData.data!.snapshot.value as Map;
          List itemsList = [];
          dataMap.forEach((key, value){
            itemsList.add({"key": key, ...value});
          });
          return ListView.builder(
            shrinkWrap: true,
            itemCount: itemsList.length,
            itemBuilder: ((context, index){
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cMethods.data(2, itemsList[index]["id"])
                ],
              );
            }),
          );
        });
  }
}
