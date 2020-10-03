import 'package:firebase_auth/firebase_auth.dart';

import 'package:stuventmobil/model/userC.dart';
import 'package:stuventmobil/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserC> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  UserC _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return UserC(
          userID: user.uid,
          email: user.email,
          userName: user.displayName,
          superUser: false);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  @override
  Future<UserC> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken,
          idToken: _googleAuth.idToken,
        );
        UserCredential sonuc =
            await _firebaseAuth.signInWithCredential(credential);

        User _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserC> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser) async {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail, password: password);
    List<String> etkinlikler = [];
    return UserC(
        userID: sonuc.user.uid,
        email: mail,
        userName: name,
        lastName: lastname,
        superUser: superUser,
        etkinlikler: etkinlikler);
  }

  @override
  Future<UserC> signInWithEmailandPassword(String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<bool> sifreGuncelle(String password) async {
    try {
      User user = _firebaseAuth.currentUser;
      await user.updatePassword(password).then((a) {
        return true;
      }).catchError((e) {
        print("Şifre güncellenirken hata oluştu $e");
        signOut();
        return false;
      });
    } catch (e) {
      print("Şifre Güncelleme hata: " + e.toString());
      return false;
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String mail) async {
    try {
      await _firebaseAuth
          .sendPasswordResetEmail(email: mail)
          .then((value) => true)
          .catchError((onError) => false);
    } catch (e) {
      print("sendPasswordResetEmail hata: " + e.toString());
      return false;
    }
  }
}
