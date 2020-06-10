import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/exceptions.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/ui/Login/new_User.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String mail, password;
  String result = "";
  bool otomatikKontrol = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
            accentColor: Colors.green,
            hintColor: Colors.indigo,
            errorColor: Colors.red,
            primaryColor: Colors.teal),
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              emailvesifregiris();
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
                    gSignIn(context);
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
    formKey.currentState.save();
    _auth.sendPasswordResetEmail(email: mail).then((v) {
      setState(() {
        result = "Şifre sıfırlama E-mail ı gönderildi";
      });
    }).catchError((e) {
      setState(() {
        result = "Şifremi unuttum mailinde hata";
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

  Future<void> gSignIn(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    await _userModel.signInWithGoogle();
  }

  Future<void> emailvesifregiris() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      setState(() {
        result = "Giriş Yapılıyor...";
      });
      final _userModel = Provider.of<UserModel>(context, listen: false);
      try {
        await _userModel.signInWithEmailandPassword(mail, password);
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "Oturum Açma HATA",
          icerik: Exceptions.goster(e.code),
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }
}
