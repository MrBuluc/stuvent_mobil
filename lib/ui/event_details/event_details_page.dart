import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/model/user.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import '../../model/event.dart';
import 'package:stuventmobil/ui/QrCode/generate.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool superU = false;
  bool _pickFileInProgress = false;
  Map<String, dynamic> docMap;
  List<String> docMapKeys = [];
  bool control = true;

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    superUser(_userModel);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              heightFactor: 1.25,
              child: Hero(
                tag: widget.event.title,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/loading.gif",
                  image: widget.event.imageURL,
                  height: 300.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          "Dosyalar:",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (final keys in docMapKeys)
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch(docMap[keys])) {
                                await launch(docMap[keys]);
                              } else {
                                debugPrint("Could not launch $docMap[keys]");
                              }
                            },
                            child: Text(
                              keys,
                              style:
                                  TextStyle(color: Colors.green, fontSize: 18),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Color(0xFFFF4700),
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScanScreen()),
                      );
                    },
                    child: const Text('Yoklama al')),
              ),
              if (superU)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: RaisedButton(
                      color: Color(0xFFFF4700),
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GenerateScreen(widget.event.title)),
                        );
                      },
                      child: const Text('QR oluştur')),
                ),
            ]),
            if (superU)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: RaisedButton(
                color: _pickFileInProgress ? Colors.grey : Colors.green,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  _pickFileInProgress ? null : _pickDocument(context, _userModel);
                },
                child: Text(
                  _pickFileInProgress ? "Dosya Yükleniyor" : "Dosya Paylaş",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> superUser(UserModel userModel) async {
    User user = await userModel.currentUser();
    docMap = widget.event.documentsMap;
    if (docMap.isNotEmpty) {
      setState(() {
        control = false;
        docMapKeys = docMap.keys.toList();
      });
    }
    setState(() {
      superU = user.superUser;
    });
  }

  _pickDocument(BuildContext context, UserModel userModel) async {
    String result;
    try {
      setState(() {
        _pickFileInProgress = true;
      });

      result = await FlutterDocumentPicker.openDocument();
      File file = new File(result);
      String fileName = file.path.split("/").removeLast();

      String url = await userModel.uploadFile("Etkinlikler",file, widget.event.title, fileName);

      docMap[fileName] = url;

      await userModel.update("Etkinlikler", widget.event.title, "Dosyalar", docMap).then((sonuc) {
        if(sonuc == true || sonuc == null) {
          PlatformDuyarliAlertDialog(
            baslik: "Dosyalar Güncellendi",
            icerik: "",
            anaButonYazisi: "Tamam",
          ).goster(context);

          setState(() {
            control = false;
            docMapKeys = docMap.keys.toList();
          });
        } else{
          PlatformDuyarliAlertDialog(
            baslik: "Dosyalar Güncellenemedi",
            icerik: "Dosya güncellenirken hata oluştu",
            anaButonYazisi: "Tamam",
          ).goster(context);
        }
      }).catchError((onError) {
        PlatformDuyarliAlertDialog(
          baslik: "Dosyalar Güncellenemedi",
          icerik: "Dosya güncellenirken hata oluştu\n"+ onError.toString(),
          anaButonYazisi: "Tamam",
        ).goster(context);
      });
    } catch (e) {
      PlatformDuyarliAlertDialog(
        baslik: "Dosyalar Güncellenemedi",
        icerik: e.toString(),
        anaButonYazisi: "Tamam",
      ).goster(context);
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }
  }
}
