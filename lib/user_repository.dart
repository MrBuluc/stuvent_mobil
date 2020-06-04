import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserDurum {Idle, OturumAcilmamis, OturumAciliyor, OturumAcik}

class UserRepository with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Firestore _firestore;
  UserDurum _durum = UserDurum.Idle;
  String uId;

  UserRepository(){
    _auth = FirebaseAuth.instance;
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
    _firestore = Firestore.instance;
  }

  UserDurum get durum => _durum;

  set durum(UserDurum value) {
    _durum = value;
  }

  FirebaseUser get user => _user;

  set user(FirebaseUser value) {
    _user = value;
  }

  Future<bool> signIn(String email, String sifre) async {
    try{
      _durum = UserDurum.OturumAciliyor;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: sifre).then((u) {
        _user = u.user;
        uId = _user.uid;
      });
      return true;
    } catch (e) {
      _durum = UserDurum.OturumAcilmamis;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    durum = UserDurum.OturumAcilmamis;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser user) async {
    if(user == null){
      _durum = UserDurum.OturumAcilmamis;
    }else{
      _user = user;
      _durum = UserDurum.OturumAcik;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> read() async {
    Map<String, dynamic> userMap = new Map();
    await _auth.currentUser().then((user) async {
      uId = user.uid;

      DocumentSnapshot documentSnapshot =
          await _firestore.document("Users/$uId").get();

      String ad = documentSnapshot.data["Ad"];
      String email = documentSnapshot.data["E-mail"];
      bool superuser = documentSnapshot.data["SuperUser"];

      userMap["Ad"] = ad;
      userMap["E-mail"] = email;
      userMap["SuperUser"] = superuser;
    });
    return userMap;
  }
}