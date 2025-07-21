import 'dart:convert';
import 'package:bus_pass_system/All_pass.dart';
import 'package:bus_pass_system/history.dart';
import 'package:flutter/material.dart';
import 'package:bus_pass_system/Registration.dart';
import 'package:bus_pass_system/Renew.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class Home_Screen extends StatefulWidget {
  Home_Screen({super.key, this.stu_id, this.selected_pass});

  String? stu_id;
  Map? selected_pass;

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  String? name;
  String? route;

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Registration()),
    );
  }

  Future getdata() async {
    var student =
        await FirebaseFirestore.instance
            .collection("students")
            .doc(widget.stu_id)
            .get();
    var data = student.data() as Map<String, dynamic>;
    name = data["name"];
    route = data["current_route"];
    setState(() {});
  }

  Future check() async {
    var student =
        await FirebaseFirestore.instance
            .collection("students")
            .doc(widget.stu_id)
            .get();
    var data = student.data() as Map<String, dynamic>;
    List pass = data["pass"];

    DateTime currentDate = DateTime.now();

    pass.removeWhere((single) {
      DateTime expireDate = (single['expired_date'] as Timestamp).toDate();
      bool isExpired = currentDate.isAfter(expireDate);
      if (isExpired) {
        FirebaseFirestore.instance
            .collection("students")
            .doc(widget.stu_id)
            .update({
              "history": FieldValue.arrayUnion([single]),
            });
      }
      return isExpired;
    });

    await FirebaseFirestore.instance
        .collection("students")
        .doc(widget.stu_id)
        .update({"pass": pass, "current_route": null});

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getdata();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          ElevatedButton(onPressed: logout, child: Text("Log Out")),
          ElevatedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => History(stu_id: widget.stu_id),
                  ),
                ),
            child: Text("History"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          color: const Color.fromARGB(255, 194, 79, 3),
                          child: Center(child: Text("upload img here")),
                        ),
                        SizedBox(width: 30),
                        Text(
                          name ?? "Fetching Data..",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      route ?? "Please select your route",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AllPass(stu_id: widget.stu_id),
                          ),
                        );
                      },
                      child: Text("All Pass"),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Renew(stu_id: widget.stu_id),
                  ),
                );
              },
              child: Text("Add Pass"),
            ),
            SizedBox(height: 20),

            Container(
              height: 240,
              width: 240,
              // color: Colors.amber,
              child:
                  widget.selected_pass != null
                      ? Builder(
                        builder: (_) {
                          Timestamp originalTimestamp =
                              widget.selected_pass!["date"];
                          DateTime originalDate = originalTimestamp.toDate();
                          DateTime expireDate = originalDate.add(
                            Duration(days: 30),
                          );
                          
                          int coming = widget.selected_pass!["coming"] ?? 0;
                          int going = widget.selected_pass!["going"] ?? 0;

                          Map<String, dynamic> qrDataMap = {
                            "stu_id": widget.stu_id,
                            "path": widget.selected_pass!["path"],
                            "coming": coming,
                            "going": going,
                          };

                          String qrData = jsonEncode(qrDataMap);

                          return QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 250.0,
                            embeddedImage: AssetImage('assets/st_logo.jpeg'),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size(60, 60),
                            ),
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                          );
                        },
                      )
                      : Center(child: Text("No Pass Selected")),
            ),
          ],
        ),
      ),
    );
  }
}
