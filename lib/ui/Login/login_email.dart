import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stuventmobil/ui/homepage/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginEmail extends StatefulWidget {
  String uId;
  @override
  _LoginEmailState createState() => _LoginEmailState();
}

class _LoginEmailState extends State<LoginEmail> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
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
        .then((oturumAcmisUserAuthResult){
      var userID = oturumAcmisUserAuthResult.user.uid;
      widget.uId = userID;
      if(checkBoxState){
        final DocumentReference userRef =
        _firestore.document("Users/$userID");

        _firestore.runTransaction((Transaction transaction) async {
          DocumentSnapshot userData = await userRef.get();
          bool otoGiris = userData.data["Oto_Giris"];
          otoGiris = true;
          await transaction.update(userRef, {"Oto_Giris": otoGiris}).catchError((e) {
            setState(() {
              result = "Oturum Açılırken hata oluştu";
            });
          });
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }}).catchError((e) {
      setState(() {
        result = "Email veya şifre hatalı";
      });
    });
  }
}
