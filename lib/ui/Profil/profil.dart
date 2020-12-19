import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/model/userC.dart';
import 'package:stuventmobil/ui/Generate_Event/GeneratEvent.dart';
import 'package:stuventmobil/ui/Generate_Notification/GenerateNotification.dart';
import 'package:stuventmobil/ui/Profil/update_password_page.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final formKey = GlobalKey<FormState>();

  String name = "", mail = "", password;
  bool superU = false;
  bool otomatikKontrol = false;

  String hBLinkedin = "https://www.linkedin.com/in/hakkican-buluc/";

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
                RaisedButton(
                  child: Text(
                    "Şifremi Güncelle",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdatePasswordPage()));
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
                SizedBox(
                  height: 10,
                ),
                if (superU)
                  RaisedButton(
                    child: Text(
                      "Yeni Duyuru Bildirimi Oluştur",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GenerateNotification()),
                      );
                    },
                    color: Colors.blue,
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
                    _cikisIcinOnayIste(context, _userModel);
                  },
                  color: Colors.red,
                ),
                SizedBox(
                  height: 90,
                ),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      children: [
                        Text("© 2020 IEEE MSKU - Tüm Hakları Sakldır."),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Created by ",
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (await canLaunch(hBLinkedin)) {
                                  await launch(hBLinkedin);
                                } else {
                                  debugPrint("Could not launch: $hBLinkedin");
                                }
                              },
                              child: Text(
                                "Mr. Bülüç",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> read(UserModel userModel) async {
    UserC user = await userModel.currentUser();
    setState(() {
      name = user.lastName == null
          ? "${user.userName}"
          : "${user.userName} ${user.lastName}";
      mail = user.email;
      superU = user.superUser;
    });
  }

  Future<void> _cikisyap(BuildContext context, UserModel userModel) async {
    try {
      await userModel.signOut();

      final sonuc = await PlatformDuyarliAlertDialog(
        baslik: "Oturumunuz Kapatıldı 😞",
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

  Future<void> _cikisIcinOnayIste(
      BuildContext context, UserModel userModel) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Oturumu kapatmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc) {
      _cikisyap(context, userModel);
    }
  }
}
