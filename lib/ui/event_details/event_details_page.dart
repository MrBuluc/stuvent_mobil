import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/event.dart';
import 'package:stuventmobil/ui/QrCode/generate.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool superU = false;
  bool _pickFileInProgress = false;
  String url;
  Map<String, dynamic> docMap;
  List<String> docMapKeys;
  bool control = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    superUser();
  }

  @override
  Widget build(BuildContext context) {
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
                        for(final keys in docMapKeys)
                          GestureDetector(
                            onTap: () async {
                              if(await canLaunch(docMap[keys])){
                                await launch(docMap[keys]);
                              } else{
                                debugPrint("Could not launch $docMap[keys]");
                              }
                            },
                            child: Text(
                              keys,
                              style: TextStyle(color: Colors.green, fontSize: 18),
                            ),
                          )
                      ],
                    )
                    /*myWidget(
                      control: control,
                      docMap: docMap,
                    ),*/
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: () {
                  _pickFileInProgress ? null : _pickDocument();
                },
                child: Text(
                    _pickFileInProgress ? "Dosya Yükleniyor" : "Dosya Paylaş"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> superUser() async {
    docMap = widget.event.documentsMap;
    if (docMap.isNotEmpty) {
      setState(() {
        control = false;
        docMapKeys = docMap.keys.toList();
      });
    }
    _auth.currentUser().then((user) async {
      String uId = user.uid;
      DocumentSnapshot documentSnapshot =
          await _firestore.document("Users/${uId}").get();

      setState(() {
        superU = documentSnapshot.data["SuperUser"];
      });
    });
  }

  _pickDocument() async {
    String result;
    try {
      setState(() {
        _pickFileInProgress = true;
      });

      result = await FlutterDocumentPicker.openDocument();
      File file = new File(result);
      String fileName = file.path.split("/").removeLast();

      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("Etkinlikler")
          .child(widget.event.title)
          .child(fileName);
      StorageUploadTask uploadTask = ref.putFile(file);
      url = await (await uploadTask.onComplete).ref.getDownloadURL();

      docMap[fileName] = url;

      _firestore
          .collection("Etkinlikler")
          .document(widget.event.title)
          .updateData({"Dosyalar": docMap}).then((v) {
        debugPrint("Dosyalar Güncellendi");
        setState(() {
          control = false;
        });
      }).catchError((onError) {
        debugPrint("Hata: " + onError.toString());
      });
    } catch (e) {
      debugPrint("Hata2: " + e.toString());
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }
  }

  /*Widget myWidget() {
    debugPrint("Docmap: " + docMap.toString());
    docMap.forEach((key, value) {
      return myWidget2(key2: key, value: value,);
    });
  }*/
}

class myWidget extends StatelessWidget {
  bool control;
  Map<String, dynamic> docMap;
  myWidget({Key key, this.control, this.docMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!control) {
      debugPrint("docMap: $docMap");
      docMap.forEach((key, value) {
        return Container(
          width: 0,
          height: 0,
          child: GestureDetector(
            onTap: () async {
              if (await canLaunch(value)) {
                await launch(value);
              } else {
                debugPrint("Could not launch $value");
              }
            },
            child: Text(
              key,
              style: TextStyle(color: Colors.green, fontSize: 15),
            ),
          ),
        );
      });
    }
    return Text("Paylaşılan dosya yok");
  }
}
