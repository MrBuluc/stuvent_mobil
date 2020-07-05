import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

class GeneratEvent extends StatefulWidget {
  @override
  _GeneratEventState createState() => _GeneratEventState();
}

class _GeneratEventState extends State<GeneratEvent> {
  String event_name, location, url;
  int category;
  String result = "";
  final formKey = GlobalKey<FormState>();
  List<String> etkinlikler = [];

  File _secilenResim;

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    getEtkinlikler(_userModel);
    return Theme(
        data: Theme.of(context).copyWith(
            accentColor: Colors.green,
            hintColor: Colors.indigo,
            errorColor: Colors.red,
            primaryColor: Colors.teal),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _veriEkle(_userModel);
            },
            backgroundColor: Colors.teal,
            child: Icon(Icons.save),
          ),
          appBar: AppBar(
            title: Text("Etkinlik Oluştur"),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.event),
                      hintText: "Etkinliğin Adı",
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: "Etkinliğin Adı",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String value) {
                      if (etkinlikler.contains(value)) {
                        return "Bu etkinlik bulunmaktadır";
                      } else
                        return null;
                    },
                    onSaved: (String value) => event_name = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.event),
                      hintText: "Etkinliğin Konumu",
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: "Etkinliğin Konumu",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (String value) => location = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButton<int>(
                    items: [
                      DropdownMenuItem<int>(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("CS"),
                          ],
                        ),
                        value: 1,
                      ),
                      DropdownMenuItem<int>(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("EA"),
                          ],
                        ),
                        value: 2,
                      ),
                      DropdownMenuItem<int>(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("PES"),
                          ],
                        ),
                        value: 3,
                      ),
                      DropdownMenuItem<int>(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("RAS"),
                          ],
                        ),
                        value: 4,
                      ),
                      DropdownMenuItem<int>(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 24,
                              height: 24,
                              margin: EdgeInsets.only(right: 10),
                            ),
                            Text("WIE"),
                          ],
                        ),
                        value: 5,
                      ),
                    ],
                    onChanged: (int secilen) {
                      setState(() {
                        category = secilen;
                      });
                    },
                    hint: Text("Komunite Seçiniz"),
                    value: category,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text("Galeriden Resim Seç"),
                    color: Colors.red,
                    onPressed: _galeriResimUpload,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: _secilenResim == null
                        ? Text("Resim Yok")
                        : Image.file(_secilenResim),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      result,
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  _veriEkle(UserModel userModel) async {
    if (_secilenResim == null) {
      setState(() {
        result = "Lütfen resim yükleyiniz!!!";
      });
    } else {
      setState(() {
        result = "Etkinlik oluşturuluyor...";
      });
      if (formKey.currentState.validate()) {
        formKey.currentState.save();

        String url = await userModel.uploadFile(
            "Etkinlikler", _secilenResim, event_name, "event_photo.png");

        List katilimcilar = [];

        List categoryList = [0];
        categoryList.add(category);

        Map<String, dynamic> docMap = {};

        formKey.currentState.save();
        Map<String, dynamic> data = Map();
        data["Etkinlik Adı"] = event_name;
        data["Etkinlik Konumu"] = location;
        data["Etkinlik Photo Url"] = url;
        data["category"] = categoryList;
        data["Katilimcilar"] = katilimcilar;
        data["Dosyalar"] = docMap;

        bool sonuc = await userModel.setData("Etkinlikler", event_name, data);

        if (sonuc == true || sonuc == null) {
          final sonuc1 = await PlatformDuyarliAlertDialog(
            baslik: "Etkinlik Oluşturuldu",
            icerik: "Etkinlik Başarıyla Oluşturuldu",
            anaButonYazisi: "Tamam",
          ).goster(context);
          if (sonuc1) {
            Navigator.pop(context);
          }
        } else {
          PlatformDuyarliAlertDialog(
            baslik: "Etkinlik Oluşturulamadı",
            icerik: "Etkinlik Oluşturulurken sorun oluştu",
            anaButonYazisi: "Tamam",
          ).goster(context);
        }
      }else{
        setState(() {
          result = "Etkinlik adını doğru giriniz";
        });
      }

    }
  }

  _galeriResimUpload() async {
    final picker = ImagePicker();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _secilenResim = File(pickedFile.path);
    });
  }

  Future<void> getEtkinlikler(UserModel userModel) async {
    etkinlikler = await userModel.getEtkinlikler();
  }
}
