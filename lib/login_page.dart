import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ui/Login/new_User.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Ekranı"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(
                "Email/Sifre Yeni Kullanıcı Oluştur",
              ),
              color: Colors.blue,
              onPressed:(() => Navigator.push(context, MaterialPageRoute(builder: (context) => NewUser()),))
            ),
            RaisedButton(
              child: Text(
                "Email ve Şifre ile Giriş Yap"
              ),
              color: Colors.green,
              onPressed: (){},
            )
          ],
        ),
      ),
    );
  }

  Future<void> _emailveSifreLogin() async {
    String mail = "hakkicanbuluc@gmail.com";
    String sifre = "123456";

    var firebaseUser = await _auth
        .createUserWithEmailAndPassword(email: mail, password: sifre)
        .catchError((e) => debugPrint("Hata: " + e.toString()));


  }
}
