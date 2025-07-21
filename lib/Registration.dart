import 'package:bus_pass_system/Home_Screen.dart';
import 'package:bus_pass_system/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  FirebaseAuth auth =FirebaseAuth.instance;

  TextEditingController email =TextEditingController();
  TextEditingController password =TextEditingController();
  TextEditingController name =TextEditingController();

  void signup()async{
    try {
      UserCredential student =await auth.createUserWithEmailAndPassword(email: email.text, password: password.text);

      FirebaseFirestore.instance.collection("students").doc(student.user!.uid).set({"name":name.text,"pass":[]});
      Navigator.push(context,MaterialPageRoute(builder: (context) =>Home_Screen(stu_id: student.user!.uid,)));
      
    } catch (e) {
      print(e);
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: name, 
            decoration: InputDecoration(
              hintText: "Enter Your Name"
            ),
          ),
          TextField(
            controller: email, 
            decoration: InputDecoration(
              hintText: "Enter Email"
            ),
          ),
          TextField(
            controller: password, 
            decoration: InputDecoration(
              hintText: "Enter Password"
            ),
          ),
          ElevatedButton(onPressed: signup, child: Text("signup")),
          SizedBox(height: 10,),
          ElevatedButton(onPressed:() {
            Navigator.push(context,MaterialPageRoute(builder: (context) =>Login()));
          }, 
          child: Text("Login"))

          
        ],
      ),
    );
  }
}