import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import 'package:stuventmobil/app/exceptions.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/model/userC.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final formKey = GlobalKey<FormState>();

  String name, lastname, mail, password;
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _generateNewUser();
            },
            backgroundColor: Colors.teal,
            child: Icon(Icons.save),
          ),
          appBar: AppBar(
            title: Text("Üye Kayıt"),
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
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: "Ad",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "Adınız",
                    border: OutlineInputBorder(),
                  ),
                  validator: _isimKontrol,
                  onSaved: (String value) => name = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    hintText: "Soyad",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "Soyadınız",
                    border: OutlineInputBorder(),
                  ),
                  validator: _soyisimKontrol,
                  onSaved: (String value) => lastname = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: "E-mail",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "E-mail adresiniz",
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

  Future<void> _generateNewUser() async {
    setState(() {
      result = "Üye kayıt ediliyor...";
    });

    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      final _userModel = Provider.of<UserModel>(context, listen: false);
      try {
        UserC _user = await _userModel.createUserWithEmailandPassword(
            name, lastname, mail, password, false);
        if (_user != null) {
          var sonuc = await PlatformDuyarliAlertDialog(
            baslik: "Kaydınız Başarıyla Gerçekleştirildi :)",
            icerik: "Uygulamamızın keyfini çıkarabilirsiniz 🥳",
            anaButonYazisi: "Tamam",
          ).goster(context);
          if (sonuc) {
            Navigator.pop(context);
          }
          setState(() {
            result = "Üye Kayıt Edildi\n "
                "Uygulamamızın keyfini çıkarabilirsiniz 🥳";
          });
        } else {
          setState(() {
            result = "Üye Kayıt edilirken sorun oluştu";
          });
        }
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Exceptions.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    } else {
      setState(() {
        otomatikKontrol = true;
        result = "Girilen Bilgileri Doğru giriniz";
      });
    }
  }

  String _isimKontrol(String isim) {
    RegExp regex = RegExp(
        "^[abcçdefgğhıijklmnoöprsştuüvyzqwxABCÇDEFGHIİJKLMNOÖPRSŞTUÜVYZQWX]+\$");
    if (!regex.hasMatch(isim))
      return 'Isim numara veya boşluk içermemeli';
    else
      return null;
  }

  String _soyisimKontrol(String soyisim) {
    RegExp regex = RegExp(
        "^[abcçdefgğhıijklmnoöprsştuüvyzqwxABCÇDEFGHIİJKLMNOÖPRSŞTUÜVYZQWX]+\$");
    if (!regex.hasMatch(soyisim))
      return 'Soyisim numara veya boşluk içermemeli';
    else
      return null;
  }

  String _emailKontrol(String mail) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(mail))
      return 'Geçersiz mail';
    else
      return null;
  }
}
