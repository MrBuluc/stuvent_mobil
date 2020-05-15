import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GeneratEvent extends StatefulWidget {
  @override
  _GeneratEventState createState() => _GeneratEventState();
}

class _GeneratEventState extends State<GeneratEvent> {
  String event_name, location, url, category;
  String result = "";
  final formKey = GlobalKey<FormState>();
  final Firestore _firestore = Firestore.instance;
  static DateTime suan = DateTime.now();
  DateTime yilSonu = DateTime(suan.year + 1, 5, 15);
  DateTime time, tamTarih;

  TimeOfDay suankiSaat = TimeOfDay.now();
  TimeOfDay saat;

  File _secilenResim;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            accentColor: Colors.green,
            hintColor: Colors.indigo,
            errorColor: Colors.red,
            primaryColor: Colors.teal),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _veriEkle();
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
                    onSaved: (String value) => event_name = value,
                    onFieldSubmitted: (String value) => event_name = value,
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
                  DropdownButton<String>(
                    items: [
                      DropdownMenuItem<String>(
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
                        value: "CS",
                      ),
                      DropdownMenuItem<String>(
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
                        value: "EA",
                      ),
                      DropdownMenuItem<String>(
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
                        value: "PES",
                      ),
                      DropdownMenuItem<String>(
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
                        value: "RAS",
                      ),
                      DropdownMenuItem<String>(
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
                        value: "WIE",
                      ),
                    ],
                    onChanged: (String secilen) {
                      setState(() {
                        category = secilen;
                      });
                    },
                    hint: Text("Komunite Seçiniz"),
                    value: category,
                  ),
                  RaisedButton(
                    child: Text("Tarih Seç"),
                    color: Colors.green,
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: suan,
                              firstDate: suan,
                              lastDate: yilSonu)
                          .then((secilenTarih) {
                        time = secilenTarih;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    child: Text("Saat Seç"),
                    color: Colors.blue,
                    onPressed: () {
                      showTimePicker(context: context, initialTime: suankiSaat)
                          .then((secilenSaat) {
                        tamTarih = DateTime(time.year, time.month, time.day,
                            secilenSaat.hour, secilenSaat.minute);
                      });
                    },
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

  _veriEkle() async {
    setState(() {
      result = "Etkinlik oluşturuluyor...";
    });

    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child("Etkinlikler")
        .child(event_name)
        .child("event_photo.png");
    StorageUploadTask uploadTask = ref.putFile(_secilenResim);
    url = await (await uploadTask.onComplete).ref.getDownloadURL();

    QuerySnapshot querySnapshot =
    await _firestore.collection("Etkinlikler").getDocuments();

    Map map = querySnapshot.documents.asMap();
    int len = map.length;

    List Katilimcilar = ["0"];

    formKey.currentState.save();
    Map<String, dynamic> data = Map();
    data["Etkinlik Adı"] = event_name;
    data["Etkinlik Konumu"] = location;
    data["Etkinlik Tarihi"] = tamTarih;
    data["Etkinlik Photo Url"] = url;
    data["category"] = category;
    data["Katilimcilar"] = Katilimcilar;

    _firestore
        .collection("Etkinlikler")
        .document(len.toString())
        .setData(data)
        .then((v) {
      setState(() {
        result = "Etkinlik Oluşturuldu.";
      });
    }).catchError((onError) {
      setState(() {
        result = "Etkinlik Oluşturulurken sorun oluştu $onError";
      });
    });
  }

  _galeriResimUpload() async {
    var resim = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _secilenResim = resim;
    });
  }
}
