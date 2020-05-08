import 'package:flutter/material.dart';
import 'ui/Login/new_User.dart';
import 'ui/Login/login_email.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                onPressed: (() => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewUser()),
                    ))),
            RaisedButton(
              child: Text("Email ve Şifre ile Giriş Yap"),
              color: Colors.green,
              onPressed: (() => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginEmail()),
              ))
            )
          ],
        ),
      ),
    );
  }

}
