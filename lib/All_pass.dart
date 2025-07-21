import 'package:flutter/material.dart';
import 'package:bus_pass_system/Home_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AllPass extends StatefulWidget {
   AllPass({super.key,this.stu_id});

  String? stu_id;

  @override
  State<AllPass> createState() => _AllPassState();
}


class _AllPassState extends State<AllPass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("ALL PASSES")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").doc(widget.stu_id).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.data() as Map<String,dynamic>;
          var pass = data['pass'] as List<dynamic>;
          if (pass.length==0) {
           return Center(child: Text("Empty..",style: TextStyle(fontSize: 30),));
          }
          return ListView.builder(
            itemCount: pass.length,
            itemBuilder: (context, index) {
              
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                     FirebaseFirestore.instance.collection("students").doc(widget.stu_id).update({
                      "current_route": pass[index]["path"]
                     });
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Home_Screen(stu_id: widget.stu_id,selected_pass: pass[index],)));
                  },
                  child: Container(
                    color: const Color.fromARGB(255, 29, 201, 6),
                    height: 50,
                    child: Row(
                      children: [
                        Container(
                          width: 260,
                          height: double.infinity,
                          child: Text(pass[index]["path"],style: TextStyle(fontSize: 20))),
                        
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
   
  
  }
}