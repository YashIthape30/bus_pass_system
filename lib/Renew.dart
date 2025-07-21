import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Renew extends StatefulWidget {
  Renew({super.key, this.stu_id});
  String? stu_id;

  @override
  State<Renew> createState() => _RenewState();
}

class _RenewState extends State<Renew> {
  List<String> selected_routes = [];
  bool isloading = true;
  String searchQuery = "";

  void addpass(String route) async {
    var single_route = await FirebaseFirestore.instance.collection("route").doc(route).get();
    var data = single_route.data();

    await FirebaseFirestore.instance.collection("students").doc(widget.stu_id).update({
      "pass": FieldValue.arrayUnion([
        {
          "path": data!["path"],
          "date": DateTime.now(),
          "route_id": route,
          "coming": 0,
          "going": 0,
          "expired_date": DateTime.now().add(Duration(days: 2))
        }
      ])
    });
    getpass();
  }

  void getpass() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("students").doc(widget.stu_id).get();
    List<dynamic> pass = doc['pass'];
    selected_routes = pass.map((e) => e['route_id'].toString()).toList();
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    getpass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Select Your Route")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Select Your Route")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search route by path',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("route").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var route = snapshot.data!.docs;
                var remaining_routes = route.where((doc) => !selected_routes.contains(doc.id)).toList();

                // Apply search filter
                var filteredRoutes = remaining_routes.where((doc) {
                  final path = doc['path'].toString().toLowerCase();
                  return path.contains(searchQuery);
                }).toList();

                if (filteredRoutes.isEmpty) {
                  return Center(
                    child: Text(
                      "No matching route found.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredRoutes.length,
                  itemBuilder: (context, index) {
                    var route = filteredRoutes[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Payment"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(" RS ${route["amount"]}",
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      addpass(route.id);
                                    },
                                    child: Text("Done"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.amber,
                          height: 100,
                          child: Center(
                            child: Text(
                              "${route["path"]}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
