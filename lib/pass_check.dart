import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PassCheck extends StatefulWidget {
   final String stuId;
  final String path;

   PassCheck({super.key,required this.stuId, required this.path });
  
  @override
  State<PassCheck> createState() => _PassCheckState();
}

class _PassCheckState extends State<PassCheck> {
   void handleTap(String type) async {
     final doc =await FirebaseFirestore.instance.collection("students").doc(widget.stuId).get();
     final data = doc.data();

    if (data != null && data["pass"] is List) {
      List passList = data["pass"];
      int index = passList.indexWhere((p) => p["path"] == widget.path);

      if (index != -1) {
        Map pass = passList[index];
        int value = pass[type] ?? 0;

        if (value >= 1) {
          showDialogBox("Limit Finish", false);
        } else {
          pass[type] = value + 1;
          passList[index] = pass;

          await FirebaseFirestore.instance.collection("students").doc(widget.stuId).update({"pass": passList});
          showDialogBox("Done", true);
        }
      } else {
        showDialogBox("Pass not found", false);
      }
    } else {
      showDialogBox("Invalid student data", false);
    }
  }

  void showDialogBox(String msg, bool isValid) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isValid ? "Success" : "Error",style: TextStyle(fontSize: 30)),
        content: Text(msg,style: TextStyle(fontSize: 23)),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK",style: TextStyle(fontSize: 20)),
          )
        ],
      ),
    );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Coming and Going",style: TextStyle(fontSize: 30),)),
        backgroundColor: Colors.cyan[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Center(child: Text("Select one option",style: TextStyle(fontSize: 30,color: Colors.red,),)),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => handleTap("coming"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 60, 238, 128),
                elevation: 15,
                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 30),
              ),
              child: Text("Coming",style: TextStyle(fontSize: 20,color: Colors.black),),
            ),

            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => handleTap("going"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 60, 238, 128),
                elevation: 15,
                padding: EdgeInsets.symmetric(horizontal: 34,vertical: 30),
              ),
              child: Text("Going",style: TextStyle(fontSize: 20,color: Colors.black)),
            ),

          ],
        ),
      ),
    );
  }
}
