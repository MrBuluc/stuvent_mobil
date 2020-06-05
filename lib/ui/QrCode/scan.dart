import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String barcode = "";
  String result = "";


  final _flashOnController = TextEditingController(text: "Flash on");
  final _flashOffController = TextEditingController(text: "Flash off");
  final _cancelController = TextEditingController(text: "Cancel");

  var _aspectTolerance = 0.00;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  Future _scanQR() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": _cancelController.text,
          "flash_on": _flashOnController.text,
          "flash_off": _flashOffController.text,
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: _useAutoFocus,
        ),
      );

      var resul = await BarcodeScanner.scan(options: options);
      setState(() {
        barcode = resul.rawContent;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied\n";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex\n";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything\n";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex\n";
      });
    }

    setState(() {
      result = "Yoklama alınıyor...";
    });

    _auth.currentUser().then(((user) {
      String uId = user.uid;
      final DocumentReference eventRef =
      _firestore.document("Users/$uId");

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
    })
    ).catchError((e) {
      setState(() {
        result = "Kullanıcı getirilirken hata oluştu";
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