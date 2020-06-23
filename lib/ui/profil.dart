import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/exceptions.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/model/user.dart';
import 'package:stuventmobil/ui/Generate_Event/GeneratEvent.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();

  String name = "", mail = "", password;
  String result = "";
  bool superU = false;
  bool otomatikKontrol = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    read(_userModel);
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: Colors.green,
          hintColor: Colors.indigo,
          errorColor: Colors.red,
          primaryColor: Color(0xffAA00AA)),
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
                Column(
                  children: <Widget>[
                    Text(
                      "İsim:",
                      style: TextStyle(fontSize: 20, color: Color(0xffAA00AA)),
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "E-posta:",
                      style: TextStyle(fontSize: 20, color: Color(0xffAA00AA)),
                    ),
                    Text(
                      mail,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
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
                    "Şifremi Güncelle",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _sifremiGuncelle(context);
                  },
                  color: Colors.pink,
                ),
                SizedBox(
                  height: 10,
                ),
                if (superU)
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
                if (superU)
                  SizedBox(
                    height: 10,
                  ),
                RaisedButton(
                  child: Text(
                    "Oturumu Kapat",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w800),
                  ),
                  onPressed: () {
                    _cikisIcinOnayIste(context);
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

  Future<void> read(UserModel userModel) async {
    User user = await userModel.currentUser();
    setState(() {
      name = user.lastName == null
          ? "${user.userName}"
          : "${user.userName} ${user.lastName}";
      mail = user.email;
      superU = user.superUser;
    });
  }

  Future<void> _sifremiGuncelle(BuildContext context) async {
    setState(() {
      result = "Şifre Güncelleniyor...";
    });

    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      UserModel _userModel = Provider.of<UserModel>(context, listen: false);
      try{
        bool sonuc = await _userModel.updatePassword(password);
        if (sonuc== true || sonuc == null) {
          PlatformDuyarliAlertDialog(
            baslik: "Şifreniz Güncellendi :)",
            icerik: "Şifreniz Başarılı Bir Şekilde Güncellendi",
            anaButonYazisi: "Tamam",
          ).goster(context);
          setState(() {
            result = "Şifre Güncellendi";
          });
        } else {
          final sonuc = await PlatformDuyarliAlertDialog(
            baslik: "Şifreniz Güncellenemedi :(",
            icerik: "Şifreniz Güncellenirken Bir Sorun Oluştu\n" +
                "Yeni şifreniz alanı boş geçilemez\n" +
                "Tekrar giriş yapmanız gerekiyor",
            anaButonYazisi: "Tamam",
          ).goster(context);
          setState(() {
            result = "Şifre güncellenirken hata oluştu";
            _userModel.signOut();
          });
          if(sonuc){
            Navigator.pop(context);
          }
        }
      }on PlatformException catch (e) {
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

  Future<void> _cikisyap(BuildContext context) async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      await _auth.signOut();
      final sonuc = await PlatformDuyarliAlertDialog(
        baslik: "Oturumunuz Kapatıldı :(",
        icerik: "Oturumunuz başarıyla kapatıldı\n" + "Yine Bekleriz...",
        anaButonYazisi: "Tamam",
      ).goster(context);
      if (sonuc) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("sign out hata:" + e.toString());
    }
  }

  Future<void> _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Oturumu kapatmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc) {
      _cikisyap(context);
    }
  }
}
