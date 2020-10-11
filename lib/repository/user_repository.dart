import 'dart:io';

import 'package:stuventmobil/locator.dart';
import 'package:stuventmobil/model/userC.dart';
import 'package:stuventmobil/services/auth_base.dart';
import 'package:stuventmobil/services/bildirim_gonderme_servis.dart';
import 'package:stuventmobil/services/firebase_auth_service.dart';
import "package:stuventmobil/services/firebase_storage_service.dart";
import 'package:stuventmobil/services/firestore_db_service.dart';

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  BildirimGondermeServis _bildirimGondermeServis =
      locator<BildirimGondermeServis>();

  @override
  Future<UserC> currentUser() async {
    UserC _user = await _firebaseAuthService.currentUser();
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
  Future<UserC> signInWithGoogle() async {
    UserC _user = await _firebaseAuthService.signInWithGoogle();
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
  Future<UserC> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser) async {
    UserC _user = await _firebaseAuthService.createUserWithEmailandPassword(
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
  Future<UserC> signInWithEmailandPassword(String email, String sifre) async {
    UserC _user =
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

  Future<bool> update(
      String collection, String documentName, String alan, dynamic map) async {
    return await _firestoreDBService.update(
        collection, documentName, alan, map);
  }

  Future<bool> setData(
      String s, String eventName, Map<String, dynamic> data) async {
    var dbYazmaIslemi = await _firestoreDBService.setData(s, eventName, data);
    if (dbYazmaIslemi) {
      return await _bildirimGondermeServis.eventBildirimGonder(data);
    }
    return false;
  }

  Future<List<String>> getEtkinlikler() async {
    return await _firestoreDBService.getEtkinlikler();
  }

  Future<List<dynamic>> readParticipants(String eventName) async {
    return await _firestoreDBService.readParticipants(eventName);
  }

  Future<bool> sendPasswordResetEmail(String mail) async {
    return await _firebaseAuthService.sendPasswordResetEmail(mail);
  }

  Future<bool> yoklamaAl(
      String userName, String userID, String eventName) async {
    return await _firestoreDBService.yoklamaAl(userName, userID, eventName);
  }

  Future<bool> updatePassword(String password) async {
    return await _firebaseAuthService.sifreGuncelle(password);
  }

  Future<bool> generateNotification(
      String title, String message, String bigText) async {
    return await _bildirimGondermeServis.bigTextBildirimGonder(
        title, message, bigText);
  }

  deleteFile(String anaKlasor, String etkinlikAdi, String fileName) async {
    return await _firebaseStorageService.deleteFile(
        anaKlasor, etkinlikAdi, fileName);
  }

  delEvent(String anaKlasor, String etkinlikAdi) async {
    List<String> files =
        await _firestoreDBService.readFiles(anaKlasor, etkinlikAdi);
    return await _firebaseStorageService.delFiles(
        anaKlasor, etkinlikAdi, files);
  }

  Future<bool> eventDel(String document) async {
    return await _firestoreDBService.eventDel(document);
  }
}
