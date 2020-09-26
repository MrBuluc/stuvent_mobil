import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

class GenerateNotification extends StatefulWidget {
  @override
  _GenerateNotificationState createState() => _GenerateNotificationState();
}

class _GenerateNotificationState extends State<GenerateNotification> {
  String title, message, bigText;
  String result = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Theme(
        data: Theme.of(context).copyWith(
            accentColor: Colors.green,
            hintColor: Colors.indigo,
            errorColor: Colors.red,
            primaryColor: Colors.teal),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _bildirimOlustur(_userModel);
            },
            backgroundColor: Colors.teal,
            child: Icon(Icons.notifications),
          ),
          appBar: AppBar(
            title: Text("Bildirim Oluştur"),
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
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      hintText: "Başlık",
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: "Bildirim Başlığı",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (String value) => title = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.message),
                      hintText: "Özet",
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: "Bildirim Özeti",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (String value) => message = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.newline,
                    maxLines: 6,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.text_fields),
                      hintText: "Uzun Mesaj",
                      hintStyle: TextStyle(fontSize: 12),
                      labelText: "Bildirim Uzun Mesajı",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (String value) => bigText = value,
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
        ));
  }

  _bildirimOlustur(UserModel userModel) async {
    setState(() {
      result = "Bildirim oluşturuluyor...";
    });

    formKey.currentState.save();

    bool sonuc = await userModel.generateNotification(title, message, bigText);

    if (sonuc == true || sonuc == null) {
      await PlatformDuyarliAlertDialog(
        baslik: "Bildirim Oluşturuldu",
        icerik: "Bildirim Başarıyla Oluşturuldu",
        anaButonYazisi: "Tamam",
      ).goster(context);
      setState(() {
        result = "Bildirim oluşturuldu";
      });
    } else {
      PlatformDuyarliAlertDialog(
        baslik: "Bildirim Oluşturulamadı",
        icerik: "Bildirim Oluşturulurken sorun oluştu",
        anaButonYazisi: "Tamam",
      ).goster(context);
      setState(() {
        result = "Bildirim oluşturulamadı";
      });
    }
  }
}
