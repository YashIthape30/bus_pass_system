import 'package:bus_pass_system/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  FirebaseAuth auth =FirebaseAuth.instance;

  Future login() async{
     UserCredential loggeduser = await auth.signInWithEmailAndPassword(email: email.text, password: password.text);
     Navigator.push(context, MaterialPageRoute(builder: (context)=>Home_Screen(stu_id: loggeduser.user!.uid,)));
  }

  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: "Enter Email"
            ),
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(
              hintText: "Enter password"
            ),
          ),
          SizedBox(height: 10,),
          TextButton(onPressed: login, child: Text("login"))
        ],
      ),
    );
  }
}