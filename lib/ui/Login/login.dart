import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stuventmobil/ui/Login/new_User.dart';
import 'package:stuventmobil/ui/homepage/home_page_super.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  String mail, password;
  String result = "Daha önce giriş yaptıysanız lütfen sağ alttaki butona basın";

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
              _emailvesifreileGirisYap();
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
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: "E-posta",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "E-posta adresiniz",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (String value) => mail = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: "Şifre",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "Şifreniz",
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (String value) => password = value,
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  child: Text(
                    "Şifemi Unuttum", style: TextStyle(color: Colors.yellow),
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

  Future<void> _emailvesifreileGirisYap() async {
    setState(() {
      result = "Giriş yapılıyor...";
    });

    formKey.currentState.save();
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    File file = File("$path/user.txt");
    try {
      String user = await file.readAsString();
      var arr = user.split("-");
      mail = arr[0];
      password = arr[1];
      _auth
          .signInWithEmailAndPassword(email: mail, password: password)
          .then((u) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePageSuper()));
      }).catchError((e) {
        setState(() {
          result = "-Email veya şifre hatalı";
        });
      });
    } catch (e) {
      _auth
          .signInWithEmailAndPassword(email: mail, password: password)
          .then((u) {
        file.writeAsString("$mail-$password");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePageSuper()));
      }).catchError((e) {
        setState(() {
          result = "E-mail veya şifre hatalı";
        });
      });
    }
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
      if(mail == mail1){
        setState(() {
          result = "Şifreniz: $password";
        });
      }
      else{
        setState(() {
          result = "Bu telefona kayıtlı E-mail bu değildir";
        });
      }
    }catch(e){
      setState(() {
        result = "Bu telefona kayıtlı User bulunamamıştır";
      });
    }
  }
}
