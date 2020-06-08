import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String baslik, icerik, anaButonYazisi, iptalButonYazisi;

  PlatformDuyarliAlertDialog(
      {@required this.baslik,
      @required this.icerik,
      @required this.anaButonYazisi,
      this.iptalButonYazisi});
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      if (iptalButonYazisi != null) {
        tumButonlar.add(CupertinoDialogAction(
          child: Text(iptalButonYazisi),
          onPressed: () {},
        ));
      }
      tumButonlar.add(CupertinoDialogAction(
        child: Text(anaButonYazisi),
        onPressed: () {},
      ));
    } else {
      if (iptalButonYazisi != null) {
        tumButonlar.add(FlatButton(
          child: Text(iptalButonYazisi),
          onPressed: () {},
        ));
      }
      tumButonlar.add(FlatButton(
        child: Text(anaButonYazisi),
        onPressed: () {
          Navigator.pop(context);
        },
      ));
    }

    return tumButonlar;
  }
}
