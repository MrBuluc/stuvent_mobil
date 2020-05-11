import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stuventmobil/ui/Login/new_User.dart';
import 'package:stuventmobil/ui/homepage/home_page.dart';
import 'dart:io';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  String mail, password;
  String result = "";
  bool checkBoxState = false;

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
                  //onFieldSubmitted: (String value) => name = value,
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
                CheckboxListTile(
                  value: checkBoxState,
                  onChanged: (secildi) {
                    setState(() {
                      checkBoxState = secildi;
                    });
                  },
                  activeColor: Colors.green,
                  title: Text("Otomatik giriş"),
                  selected: true,
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

  void _emailvesifreileGirisYap() {
    setState(() {
      result = "Giriş yapılıyor...";
    });

    formKey.currentState.save();

    _auth
        .signInWithEmailAndPassword(email: mail, password: password)
        .then((u) async {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File file = File("$path/user.txt");
      
      file.writeAsString("Oto_Giris= $checkBoxState");
      try{
        final contents = await file.readAsString();
        setState(() {
          result = contents+"\n"+ path ;
        });
      }catch(e){
        setState(() {
          result = "Okumada hata: $e";
        });
      }
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));*/
    }).catchError((e) {
      setState(() {
        result = "Email veya şifre hatalı";
      });
    });
  }
}
