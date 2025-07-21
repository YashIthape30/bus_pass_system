import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
   History({super.key,this.stu_id});

  String? stu_id;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Expired Pass")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("students").doc(widget.stu_id).snapshots(), 
        builder: (context,snapshot){
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var data = snapshot.data!.data() as Map<String,dynamic>;
          var Expired_pass = List<Map<String, dynamic>>.from(data['history'] ?? []);

          if (Expired_pass.length == 0) {
           return Center(child: Text("Empty..",style: TextStyle(fontSize: 30),));
          }
          return ListView.builder(
            itemCount: Expired_pass.length,
            itemBuilder: (context, index) {
               String date = DateFormat('dd/MM/yyyy HH:mm:ss').format((Expired_pass[index]["date"] as Timestamp).toDate());
               String expired_date = DateFormat('dd/MM/yyyy HH:mm:ss').format((Expired_pass[index]["expired_date"] as Timestamp).toDate());
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: const Color.fromARGB(255, 218, 67, 29),
                  // height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(Expired_pass[index]["path"],style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text(date,style: TextStyle(fontSize: 20,color: Colors.white)),
                        Text(expired_date,style: TextStyle(fontSize: 20,color: Colors.white)),
                    
                         
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      )
    );
  }
}