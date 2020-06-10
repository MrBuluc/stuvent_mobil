import 'dart:io';

import 'package:stuventmobil/locator.dart';
import 'package:stuventmobil/model/user.dart';
import 'package:stuventmobil/services/auth_base.dart';
import 'package:stuventmobil/services/firebase_auth_service.dart';
import 'package:stuventmobil/services/firestore_db_service.dart';
import "package:stuventmobil/services/firebase_storage_service.dart";

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Future<User> currentUser() async {
    User _user = await _firebaseAuthService.currentUser();
    if (_user != null)
      return await _firestoreDBService.readUser(_user.userID);
    else
      return null;
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  @override
  Future<User> signInWithGoogle() async {
    User _user = await _firebaseAuthService.signInWithGoogle();
    if (_user != null) {
      Map<String, dynamic> data = _user.toMap();
      bool _sonuc =
          await _firestoreDBService.setData("Users", _user.userID, data);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        await _firebaseAuthService.signOut();
        return null;
      }
    } else
      return null;
  }

  @override
  Future<User> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser) async {

    User _user = await _firebaseAuthService.createUserWithEmailandPassword(
        name, lastname, mail, password, superUser);
    Map<String, dynamic> data = _user.toMap();

    bool _sonuc =
        await _firestoreDBService.setData("Users", _user.userID, data);

    if (_sonuc) {
      return await _firestoreDBService.readUser(_user.userID);
    } else
      return null;
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    User _user =
        await _firebaseAuthService.signInWithEmailandPassword(email, sifre);

    return await _firestoreDBService.readUser(_user.userID);
  }

  Future<bool> sifreGuncelle(String password) async {
    return await _firebaseAuthService.sifreGuncelle(password);
  }

  uploadFile(
      String anaKLasor, File file, String etkinlikAdi, String fileName) async {
    return await _firebaseStorageService.uploadFile(
        anaKLasor, file, etkinlikAdi, fileName);
  }

  Future<bool> update(String collection, String documentName, String alan, dynamic map) async {
    return await _firestoreDBService.update(collection, documentName, alan, map);
  }

  setData(String s, String event_name, Map<String, dynamic> data) async {
    return await _firestoreDBService.setData(s, event_name, data);
  }

  /*Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    }
  }*/

}