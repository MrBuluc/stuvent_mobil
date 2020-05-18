import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stuventmobil/ui/Login/login.dart';
import 'package:stuventmobil/ui/Generate_Event/GeneratEvent.dart';

class Profil extends StatefulWidget {
  String uID;

  Profil(this.uID);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final Firestore _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  final formKey = GlobalKey<FormState>();
  TextEditingController ctrl;

  String name = "", mail = "", mailYeni, password;
  String result = "";
  bool superU = false;
  bool otomatikKontrol = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.green,
        hintColor: Colors.indigo,
        errorColor: Colors.red,
        primaryColor: Color(0xffAA00AA)
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
          backgroundColor: Color(0xFFFF4700),
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
                Row(
                  children: <Widget>[
                    Text(
                      "İsim:",
                      style: TextStyle(fontSize: 20, color: Color(0xffAA00AA)),
                    ),
                    SizedBox(width: 10),
                    Text(
                      name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: ctrl,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    labelText: "E-posta adresiniz",
                    border: OutlineInputBorder(),
                  ),
                  validator: _emailKontrol,
                  onSaved: (String value) => mailYeni = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Yeni Şifre",
                    labelText: "Yeni Şifreniz",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: "123456",
                  validator: (String value) {
                    if(value.length < 6) {
                      return "En az 6 karakter gerekli";
                    }
                    return null;
                  },
                  onSaved: (String value) => password = value,
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text(
                    "E-mail Güncelle",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _emailGuncelle();
                  },
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text(
                    "Şifremi Güncelle",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _sifremiGuncelle();
                  },
                  color: Colors.pink,
                ),
                SizedBox(
                  height: 10,
                ),
                if(superU)
                  RaisedButton(
                    child: Text(
                      "Yeni Etkinlik Oluştur",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GeneratEvent()),
                      );
                    },
                    color: Colors.green,
                  ),
                if(superU)
                  SizedBox(
                    height: 10,
                  ),
                RaisedButton(
                  child: Text(
                    "Oturumu Kapat",
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    _cikisyap();
                  },
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10,
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
      ),
    );
  }

  Future<void> read() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.document("Users/${widget.uID}").get();

    setState(() {
      name = documentSnapshot.data["Ad"];
      mail = documentSnapshot.data["E-mail"];
      superU = documentSnapshot.data["SuperUser"];
      ctrl = TextEditingController.fromValue(TextEditingValue(text: mail));
    });
  }

  Future<void> _sifremiGuncelle() async {
    setState(() {
      result = "Şifre Güncelleniyor...";
    });

    if(formKey.currentState.validate()){
      formKey.currentState.save();
      _auth.currentUser().then((user) {
        user.updatePassword(password).then((a) async {
          Directory directory = await getApplicationDocumentsDirectory();
          String path = directory.path;
          File file = File("$path/user.txt");
          file.writeAsString("$mail-$password");
          setState(() {
            result = "Şifre Güncellendi";
          });
        }).catchError((e) {
          setState(() {
            result = "Şifre güncellenirken hata oluştu $e";
          });
        });
      }).catchError((e) {
        setState(() {
          result = "Kullanıcı getirilirken hata oluştu\n";
          result += "Yeni şifreniz alanı boş geçilemez";
        });
      });
    }
    else{
      setState(() {
        otomatikKontrol = true;
        result = "Girilen Bilgileri Doğru giriniz";
      });
    }
  }

  String _emailKontrol(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(mail))
      return 'Geçersiz mail';
    else
      return null;
  }

  void _cikisyap() {
    _auth.signOut().then((data) async {

      _googleAuth.signOut();

      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File file = File("$path/user.txt");
      file.delete();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }).catchError((e) {
      setState(() {
        result = "Çıkış yapılırken hata oluştu";
      });
    });
  }

  void _emailGuncelle() {
    setState(() {
      result = "E-mail Güncelleniyor...";
    });

    if(formKey.currentState.validate()){
      formKey.currentState.save();
      _auth.currentUser().then((user) {
        user.updateEmail(mailYeni).then((a) async {
          DocumentReference reference = _firestore.document("Users/${widget.uID}");
          _firestore.runTransaction((Transaction transaction) async {
            //DocumentSnapshot data = await reference.get();
            await transaction.update(reference, {"E-mail": mailYeni});
          });

          Directory directory = await getApplicationDocumentsDirectory();
          String path = directory.path;
          File file = File("$path/user.txt");
          try {
            String user = await file.readAsString();
            var arr = user.split("-");
            password = arr[1];
          }catch(e) {
            setState(() {
              result = "Dosya okumada hata";
            });
          }
          file.writeAsString("$mailYeni-$password");

          setState(() {
            result = "E-mail Güncellendi";
          });
        }).catchError((e) {
          setState(() {
            result = "E-mail Güncellenirken hata $e";
          });
        });
      }).catchError((e) {
        setState(() {
          result = "Kullanıcı getirilirken hata oluştu\n";
          result += "Yeni E-mail alanı boş geçilemez";
        });
      });
    }
    else{
      setState(() {
        otomatikKontrol = true;
        result = "Girilen Bilgileri Doğru giriniz";
      });
    }
  }
}