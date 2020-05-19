import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ScanScreen extends StatefulWidget {
  String uId;

  ScanScreen(this.uId);

  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  final Firestore _firestore = Firestore.instance;
  String barcode = "";
  String result = "";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        barcode = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          barcode = "Camera permission was denied";
        });
      } else {
        setState(() {
          barcode = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        barcode = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        barcode = "Unknown Error $ex";
      });
    }

    setState(() {
      result = "Yoklama alınıyor...";
    });

    final DocumentReference eventRef =
    _firestore.document("Users/${widget.uId}");

    List etkinlik;
    _firestore.runTransaction((Transaction transaction) async {
      DocumentSnapshot eventData = await eventRef.get();
      etkinlik = eventData.data["Etkinlikler"];
      etkinlik.add(barcode);
      await transaction.update(eventRef, {"Etkinlikler": etkinlik}).then(
              (onValue) {
            setState(() {
              result = "Yoklama alındı";
            });
          }).catchError((onError) {
        setState(() {
          result = "Yoklama alınırken sorun oluştu";
        });
      });
    });
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('Yoklama'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: _scanQR,
                    child: const Text('START CAMERA SCAN')
                ),
              )
              ,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(result, textAlign: TextAlign.center,),
              )
              ,
            ],
          ),
        ));
  }
}