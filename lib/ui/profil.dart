import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profil extends StatefulWidget {
  String uID;

  Profil(this.uID);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final Firestore _firestore = Firestore.instance;

  final formKey = GlobalKey<FormState>();
  TextEditingController ctrl;

  String name, mail, mailYeni, password;
  String result = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    ctrl.dispose();
    super.dispose();

  }
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
            read();
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.refresh),
        ),
        appBar: AppBar(
          title: Text("Profil"),
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: ListView(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text("Ad: $name"),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: ctrl,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail),
                  labelText: "E-posta adresiniz",
                  border: OutlineInputBorder(),
                ),
                onSaved: (String value) => mailYeni = value,
              ),
            ],),
          ),
        ),
      ),
    );
  }

  Future<void> read() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.document("Users/${widget.uID}").get();

    setState(() {
      name = documentSnapshot.data["Ad"];
      mail = documentSnapshot.data["E-mail"];
      ctrl = TextEditingController.fromValue(TextEditingValue(text: mail));
    });
  }
}
