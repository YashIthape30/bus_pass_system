import 'package:bus_pass_system/Conducter.dart';
import 'package:bus_pass_system/Home_Screen.dart';
import 'package:bus_pass_system/Registration.dart';
import 'package:bus_pass_system/firebase_options.dart';
import 'package:bus_pass_system/pass_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? student = auth.currentUser;
   // print(student!.uid);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: Conducter(),
      home: student != null ? Home_Screen(stu_id: student.uid) : Registration(),

        
    );
  }
}
