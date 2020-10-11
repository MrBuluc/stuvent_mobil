import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/exceptions.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/common_widget/social_log_in_button.dart';
import 'package:stuventmobil/ui/Login/new_User.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String mail, password;
  String result = "";
  bool otomatikKontrol = false;

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.green,
          hintColor: Colors.indigo,
          errorColor: Colors.red,
          //primaryColor: Colors.teal),
        ),
        child: Scaffold(
          key: _scaffoldKey,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              emailvesifregiris();
            },
            child: Icon(Icons.arrow_forward),
          ),
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: Center(
                child: Text(
              "Stuvent Etkinlik Habercisi",
              style: TextStyle(fontSize: 25),
            )),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: ListView(children: <Widget>[
                Center(
                    child: Text(
                  "Üye E-posta ve Şifre ile Giriş",
                  style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                )),
                SizedBox(
                  height: 25,
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
                SocialLoginButton(
                  butonText: "Şifremi Unuttum",
                  textColor: Colors.yellow,
                  butonColor: Colors.purple,
                  onPressed: () {
                    _sifremiUnuttum(_userModel);
                  },
                  butonIcon: Icon(Icons.lock_open),
                ),
                SizedBox(
                  height: 10,
                ),
                SocialLoginButton(
                  butonText: "Yeni Kullanıcı Oluştur",
                  butonColor: Colors.blue,
                  onPressed: (() => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewUser()))),
                  butonIcon: Icon(
                    Icons.account_circle,
                    size: 35,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SocialLoginButton(
                  butonText: "Google ile Giriş",
                  textColor: Colors.black,
                  butonColor: Colors.white,
                  onPressed: () {
                    gSignIn(context);
                  },
                  butonIcon: Image.asset("images/google-logo.png"),
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

  Future<void> _sifremiUnuttum(UserModel userModel) async {
    formKey.currentState.save();
    if (mail == "") {
      setState(() {
        result = "E-posta alanını boş bırakamazsınız";
      });
    } else {
      try {
        bool sonuc = await userModel.sendPasswordResetEmail(mail);
        if (sonuc == true || sonuc == null) {
          PlatformDuyarliAlertDialog(
            baslik: "Şifre Sıfırlama Mailı Gönderildi",
            icerik:
                "Şifre sıfırlama mailı başarılı bir şekilde $mail adresine gönderildi",
            anaButonYazisi: "Tamam",
          ).goster(context);
        } else {
          PlatformDuyarliAlertDialog(
            baslik: "Şifre Sıfırlama Mailı Gönderilemedi :(",
            icerik: "Şifre sıfırlama mailı gönderilirken bir sorun oluştu.\n" +
                "İnternet bağlantınızı kontrol edin.",
            anaButonYazisi: "Tamam",
          ).goster(context);
        }
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "Şifre Sıfırlama Mailı HATA",
          icerik: Exceptions.goster(e.code),
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
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
      } catch (e) {
        debugPrint("emailvesifregiris Hata: " + e.toString());
      }
    }
  }
}
