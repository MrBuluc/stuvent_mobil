import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/model/userC.dart';
import 'package:stuventmobil/ui/QrCode/generate.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'package:stuventmobil/ui/event_details/participants_page.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/event.dart';

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
    superUser(_userModel, context);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Dosyalar:",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
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
                            onLongPress: () async {
                              if (superU) {
                                _areYouSureforDelete(context, _userModel, keys);
                              } else {
                                PlatformDuyarliAlertDialog(
                                  baslik: "Erişim Hatası",
                                  icerik:
                                      "Dosyayı kaldırmak için yetkili değilsiniz",
                                  anaButonYazisi: "Tamam",
                                ).goster(context);
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
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
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
                          builder: (context) => ParticipantsPage(
                                eventName: widget.event.title,
                              )),
                    );
                  },
                  child: const Text('Yoklamayı Görüntüle')),
            ),
            if (superU)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: RaisedButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    splashColor: Colors.black,
                    onPressed: () {
                      _silmekIcinOnayIste(
                          context, _userModel, widget.event.title);
                    },
                    child: const Text('Etkinliği Kaldır')),
              ),
            if (superU)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: RaisedButton(
                  color: _pickFileInProgress ? Colors.grey : Colors.green,
                  textColor: Colors.white,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    if (!_pickFileInProgress)
                      _pickDocument(context, _userModel);
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

  Future<void> superUser(UserModel userModel, BuildContext context) async {
    UserC user = await userModel.currentUser();
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

      String url = await userModel.uploadFile(
          "Etkinlikler", file, widget.event.title, fileName);

      docMap[fileName] = url;

      bool sonuc = await userModel
          .update("Etkinlikler", widget.event.title, "Dosyalar", docMap)
          .catchError((onError) {
        PlatformDuyarliAlertDialog(
          baslik: "Dosyalar Güncellenemedi",
          icerik: "Dosya güncellenirken hata oluştu\n" + onError.toString(),
          anaButonYazisi: "Tamam",
        ).goster(context);
      });
      if (sonuc || sonuc == null) {
        PlatformDuyarliAlertDialog(
          baslik: "Dosya Eklendi",
          icerik: "Dosya başarılı bir şekilde eklendi",
          anaButonYazisi: "Tamam",
        ).goster(context);

        setState(() {
          control = false;
          docMapKeys = docMap.keys.toList();
        });
      } else {
        PlatformDuyarliAlertDialog(
          baslik: "Dosyalar Güncellenemedi",
          icerik: "Dosya güncellenirken hata oluştu",
          anaButonYazisi: "Tamam",
        ).goster(context);
        print("sonuc: " + sonuc.toString());
      }
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

  Future<void> _silmekIcinOnayIste(
      BuildContext context, UserModel userModel, String document) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Etkinliği Kaldırmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc) {
      _delEvent(context, userModel, document);
    }
  }

  Future<void> _delEvent(
      BuildContext context, UserModel userModel, String document) async {
    try {
      await userModel
          .delEvent("Etkinlikler", widget.event.title)
          .then((value) async {
        bool sonuc = await userModel.eventDel(document);
        if (sonuc == true || sonuc == null) {
          final sonuc1 = await PlatformDuyarliAlertDialog(
            baslik: "Etkinlik Kaldırıldı",
            icerik: "Etkinlik başarıyla kaldırıldı",
            anaButonYazisi: "Tamam",
          ).goster(context);
          if (sonuc1) {
            Navigator.pop(context);
          }
        } else {
          PlatformDuyarliAlertDialog(
            baslik: "Etkinlik Kaldırılırken Sorun",
            icerik: "Etkinlik kaldırılırken bir sorun oluştu ",
            anaButonYazisi: "Tamam",
          ).goster(context);
        }
      });
    } catch (e) {
      PlatformDuyarliAlertDialog(
        baslik: "Etkinlik Kaldırılırken Sorun",
        icerik: "Etkinlik kaldırılırken bir sorun oluştu: $e ",
        anaButonYazisi: "Tamam",
      ).goster(context);
    }
  }

  Future<void> _areYouSureforDelete(
      BuildContext context, UserModel userModel, String fileName) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Dosyayı kaldırmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc) {
      _deleteFile(context, userModel, fileName);
    }
  }

  Future<void> _deleteFile(
      BuildContext context, UserModel userModel, String fileName) async {
    try {
      docMap.remove(fileName);

      await userModel
          .deleteFile("Etkinlikler", widget.event.title, fileName)
          .then((value) {
        userModel
            .update("Etkinlikler", widget.event.title, "Dosyalar", docMap)
            .then((value) {
          PlatformDuyarliAlertDialog(
            baslik: "Dosya Kaldırıldı",
            icerik: "Dosya başarılı bir şekilde kaldırıldı",
            anaButonYazisi: "Tamam",
          ).goster(context);
          setState(() {
            docMapKeys = docMap.keys.toList();
          });
        }).catchError((onError) {
          PlatformDuyarliAlertDialog(
            baslik: "Dosya Kaldırılamadı",
            icerik: "Dosya kaldırılırken bir sorun oluştu\n" +
                "İnternet bağlantınızı kontrol edin\n" +
                "Hata: $onError",
            anaButonYazisi: "Tamam",
          ).goster(context);
        });
      }).catchError((onError) {
        PlatformDuyarliAlertDialog(
          baslik: "Dosya Kaldırılamadı",
          icerik: "Dosya kaldırılırken bir sorun oluştu\n" +
              "İnternet bağlantınızı kontrol edin\n" +
              "Hata: $onError",
          anaButonYazisi: "Tamam",
        ).goster(context);
      });
    } catch (e) {
      print("deleteFile hata:" + e.toString());
    }
  }
}
