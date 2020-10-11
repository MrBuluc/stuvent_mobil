import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/exceptions.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
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

  Future<void> _scanQR(BuildContext context, UserModel userModel) async {
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

    String userName = userModel.user.userName + " " + userModel.user.lastName;
    try {
      bool sonuc = await userModel.yoklamaAl(
          userName, userModel.user.userID, "CS Toplantısı");
      if (sonuc == true || sonuc == null) {
        PlatformDuyarliAlertDialog(
          baslik: "Yoklama Alındı",
          icerik: "Yoklama başarılı bir şekilde alındı",
          anaButonYazisi: "Tamam",
        ).goster(context);
        setState(() {
          result = "Yoklama Alındı";
        });
      } else {
        PlatformDuyarliAlertDialog(
          baslik: "Yoklama Alınamadı 😞",
          icerik: "Yoklama alınırken bir sorun oluştu.\n" +
              "İnternet bağlantınızı kontrol edin.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    } on PlatformException catch (e) {
      PlatformDuyarliAlertDialog(
        baslik: "Yoklama Alma HATA",
        icerik: Exceptions.goster(e.code),
        anaButonYazisi: 'Tamam',
      ).goster(context);
      setState(() {
        result = "Yoklama Alma HATA";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Yoklama'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      _scanQR(context, _userModel);
                    },
                    child: const Text('START CAMERA SCAN')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  result,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ));
  }
}
