import 'dart:io';

import 'package:flutter/material.dart';

import 'package:stuventmobil/model/user.dart';
import 'package:stuventmobil/repository/user_repository.dart';
import 'package:stuventmobil/services/auth_base.dart';
import "package:stuventmobil/locator.dart";

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  User _user;
  String emailHataMesaji;
  String sifreHataMesaji;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<User> currentUser() async {
    try {
      _user = await _userRepository.currentUser();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki signOut hata:" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("Viewmodeldeki signInWithGoogle hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser) async {
    if (_emailSifreKontrol(mail, password)) {
      try {
        state = ViewState.Busy;
        _user = await _userRepository.createUserWithEmailandPassword(
            name, lastname, mail, password, superUser);

        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;

    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalı";
      sonuc = false;
    } else
      sifreHataMesaji = null;
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailHataMesaji = null;
    return sonuc;
  }

  /*Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var indirmeLinki =
    await _userRepository.uploadFile(userID, fileType, profilFoto);
    return indirmeLinki;
  }*/

  Future<bool> sifreGuncelle(String password) async {
    try {
      state = ViewState.Busy;
      await _userRepository.sifreGuncelle(password).then((sonuc) {
        return sonuc;
      }).catchError((onError) {
        print("user_model hata: "+ onError.toString());
      });
    } catch (e) {
      print("user_model hata" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<String> uploadFile(
      String anaKlasor, File file, String etkinlikAdi, String fileName) async {
    try {
      state = ViewState.Busy;
      String url =
          await _userRepository.uploadFile(anaKlasor, file, etkinlikAdi, fileName);
      return url;
    } catch (e) {
      print("user_model hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> update(String collection, String documentName, String alan, dynamic map) async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.update(collection, documentName, alan, map);
      return sonuc;
    } catch (e) {
      print("user_model hata: " + e.toString());
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> setData(
      String s, String eventname, Map<String, dynamic> data) async {
    try {
      bool sonuc = await _userRepository.setData(s, eventname, data);
      return sonuc;
    } catch (e) {
      print("user_model hata: " + e.toString());
    }
  }

  Future<bool> eventDel(String document) async {
    try{
      bool sonuc = await _userRepository.eventDel(document);
      return sonuc;
    }
    catch (e) {
      print("user_model hata: " + e.toString());
    }
  }

  Future<List<String>> getEtkinlikler() async {
    try{
      List<String> etkinlikler = await _userRepository.getEtkinlikler();
      return etkinlikler;
    }
    catch(e){
      print("user_model hata: " + e.toString());
    }
  }

  Future<bool> sendPasswordResetEmail(String mail) async {
    try{
      bool sonuc = await _userRepository.sendPasswordResetEmail(mail);
      return sonuc;
    }
    catch (e) {
      print("user_model hata: " + e.toString());
    }
  }

  Future<bool> yoklamaAl(String userID, String eventName) async {
    try{
      bool sonuc = await _userRepository.yoklamaAl(userID, eventName);
      return sonuc;
    }
    catch (e) {
      print("user_model hata: " + e.toString());
    }
  }
}
