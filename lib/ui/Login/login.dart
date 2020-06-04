import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/ui/Login/new_User.dart';
import 'package:stuventmobil/ui/homepage/home_page.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuventmobil/user_repository.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();
  final Firestore _firestore = Firestore.instance;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String mail, password;
  String result =
      "Daha önce E-mail ve Şifre ile giriş yaptıysanız lütfen sağ alttaki butona basın";
  bool otomatikKontrol = false;

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return Theme(
        data: Theme.of(context).copyWith(
            accentColor: Colors.green,
            hintColor: Colors.indigo,
            errorColor: Colors.red,
            primaryColor: Colors.teal),
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                if (!await userRepo.signIn(mail, password)) {
                  _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("E-posta veya Şifre Hatalı")));
                }
              }
            },
            backgroundColor: Colors.teal,
            child: Icon(Icons.arrow_forward),
          ),
          appBar: AppBar(
            title: Text("Üye E-posta ve Şifre ile Giriş"),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: ListView(children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    hintText: "E-posta",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "E-posta adresiniz",
                    border: OutlineInputBorder(),
                  ),
                  validator: _emailKontrol,
                  onSaved: (String value) => mail = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Şifre",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "Şifreniz",
                    border: OutlineInputBorder(),
                  ),
                  validator: (String value) {
                    if (value.length < 6) {
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
                    "Şifemi Unuttum",
                    style: TextStyle(color: Colors.yellow),
                  ),
                  color: Colors.purple,
                  onPressed: () {
                    _sifremiUnuttum();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                    child: Text(
                      "Email ve Sifre ile Yeni Kullanıcı Oluştur",
                    ),
                    color: Colors.blue,
                    onPressed: (() => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewUser()),
                        ))),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text("Google ile Giriş"),
                  color: Colors.red,
                  onPressed: () {
                    _googleGiris();
                  },
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
              ]),
            ),
          ),
        ));
  }

  Future<void> _sifremiUnuttum() async {
    setState(() {
      result = "Şifre gösteriliyor...";
    });
    formKey.currentState.save();
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    File file = File("$path/user.txt");
    try {
      String user = await file.readAsString();
      var arr = user.split("-");
      String mail1 = arr[0];
      password = arr[1];
      if (mail == mail1) {
        setState(() {
          result = "Şifreniz: $password";
        });
      } else {
        setState(() {
          result = "Bu telefona kayıtlı E-mail bu değildir";
        });
      }
    } catch (e) {
      setState(() {
        result = "Bu telefona kayıtlı User bulunamamıştır\n";
        result += "Şifre sıfırlama E-mail ı gönderiliyor...\n";
      });

      _auth.sendPasswordResetEmail(email: mail).then((v) {
        setState(() {
          result += "Şifre sıfırlama E-mail ı gönderildi";
        });
      }).catchError((e) {
        setState(() {
          result += "Şifremi unuttum mailinde hata";
        });
      });
    }
  }

  void _googleGiris() {
    setState(() {
      result = "Giriş yapılıyor...";
    });

    _googleAuth.signIn().then((sonuc) {
      sonuc.authentication.then((googleKeys) {
        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleKeys.idToken, accessToken: googleKeys.accessToken);

        _auth.signInWithCredential(credential).then((user) {
          List etkinlikler = ["0"];

          Map<String, dynamic> data = Map();
          data["Ad"] = user.user.displayName;
          data["E-mail"] = user.user.email;
          data["UserID"] = user.user.uid;
          data["SuperUser"] = false;
          data["Etkinlikler"] = etkinlikler;

          _firestore
              .collection("Users")
              .document(user.user.uid)
              .setData(data)
              .catchError((onError) {
            setState(() {
              result = "Üye Database'e Kayıt edilirken sorun oluştu $onError";
            });
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }).catchError((hata) {
          setState(() {
            result = "Firebase ve google kullanıcı hatası";
          });
        });
      }).catchError((hata) {
        setState(() {
          result = "Google authentication hatası";
        });
      });
    }).catchError((hata) {
      setState(() {
        result =
            "Google ile Girişde hata veya İnternet Bağlantınızı kontrol edin";
      });
    });
  }

  String _emailKontrol(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Geçersiz mail';
    else
      return null;
  }
}
