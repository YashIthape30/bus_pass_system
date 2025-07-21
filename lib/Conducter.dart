import 'package:bus_pass_system/pass_check.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

class Conducter extends StatefulWidget {
  const Conducter({super.key});

  @override
  State<Conducter> createState() => _ConducterState();
}

class _ConducterState extends State<Conducter> {
  bool isScanned = false;
  bool showScanner = false;

  void handleScan(String qrData) {
    try {
      final data = jsonDecode(qrData);
      String stuId = data["stu_id"];
      String path = data["path"];

      setState(() {
        showScanner = false; 
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassCheck(stuId: stuId, path: path),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(" Error"),
          content: Text("Invalid QR data"),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isScanned = false;
                  showScanner = false; 
                });
              },
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  }

  void startScanning() {
    setState(() {
      showScanner = true;
      isScanned = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conductor QR Scanner",style: TextStyle(fontSize: 30,),),
        backgroundColor: Colors.cyan[300],
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          Center(
            child: Text("Scan Student QR",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: startScanning,
            child: Text("Scan",style: TextStyle(fontSize: 25)),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 60, 238, 128),
                elevation: 15,
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
              ),
          ),
          SizedBox(height: 20),

          if (showScanner)
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    fit: BoxFit.cover,
                    onDetect: (BarcodeCapture capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String? code = barcode.rawValue;
                        if (code != null && !isScanned) {
                          setState(() {
                            isScanned = true;
                          });
                          handleScan(code);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
