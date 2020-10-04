import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import 'package:stuventmobil/app/exceptions.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final formKey = GlobalKey<FormState>();

  String mail, oldPassword, newPassword;
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
              _updatePassword();
            },
            backgroundColor: Colors.teal,
            child: Icon(Icons.save),
          ),
          appBar: AppBar(
            title: Text("Şifre Güncelle"),
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
                    prefixIcon: Icon(Icons.lock_open),
                    hintText: "Eski Şifre",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "Eski Şifreniz",
                    border: OutlineInputBorder(),
                  ),
                  validator: (String value) {
                    if (value.length < 6) {
                      return "En az 6 karakter gerekli";
                    }
                    return null;
                  },
                  onSaved: (String value) => oldPassword = value,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Yeni Şifre",
                    hintStyle: TextStyle(fontSize: 12),
                    labelText: "Yeni Şifreniz",
                    border: OutlineInputBorder(),
                  ),
                  validator: (String value) {
                    if (value.length < 6) {
                      return "En az 6 karakter gerekli";
                    }
                    return null;
                  },
                  onSaved: (String value) => newPassword = value,
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

  Future<void> _updatePassword() async {
    setState(() {
      result = "Şifre Güncelleniyor...";
    });

    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      UserModel _userModel = Provider.of<UserModel>(context, listen: false);
      try {
        await _userModel
            .signInWithEmailandPassword(mail, oldPassword)
            .then((value) async {
          bool sonuc = await _userModel.sifreGuncelle(newPassword);
          if (sonuc == true || sonuc == null) {
            var sonuc1 = await PlatformDuyarliAlertDialog(
              baslik: "Şifreniz Güncellendi :)",
              icerik: "Şifreniz Başarılı Bir Şekilde Güncellendi",
              anaButonYazisi: "Tamam",
            ).goster(context);
            setState(() {
              result = "Şifre Güncellendi";
            });
            if (sonuc1) {
              Navigator.pop(context);
            }
          } else {
            final sonuc = await PlatformDuyarliAlertDialog(
              baslik: "Şifreniz Güncellenemedi :(",
              icerik: "Şifreniz Güncellenirken Bir Sorun Oluştu\n" +
                  "İnternet bağlantınızı kontrol edin",
              anaButonYazisi: "Tamam",
            ).goster(context);
            setState(() {
              result = "Şifre güncellenirken hata oluştu";
            });
            if (sonuc) {
              Navigator.pop(context);
            }
          }
        }).catchError((e) {
          PlatformDuyarliAlertDialog(
            baslik: "Şifre Güncelleme Hata",
            icerik: Exceptions.goster(e.toString()),
            anaButonYazisi: "Tamam",
          ).goster(context);
        });
        setState(() {
          result = "Şifre güncellenirken hata oluştu";
        });
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: "Şifre Güncelleme HATA",
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
