import 'package:firebase_auth/firebase_auth.dart';

import 'package:stuventmobil/model/user.dart';
import 'package:stuventmobil/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    } else {
      return User(userID: user.uid, email: user.email, userName: user.displayName, superUser: false);
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
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        AuthResult sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        FirebaseUser _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<User> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser) async {
    AuthResult sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail, password: password);
    List<String> etkinlikler = [];
    return User(
        userID: sonuc.user.uid,
        email: mail,
        userName: name,
        lastName: lastname,
        superUser: superUser,
        etkinlikler: etkinlikler);
  }

  @override
  Future<User> signInWithEmailandPassword(String email, String sifre) async {
    AuthResult sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  Future<bool> sifreGuncelle(String password) async {
    try {
      await _firebaseAuth.currentUser().then((user) async {
        print("user:" + user.displayName);
        await user.updatePassword(password).then((a){
          return true;
        }).catchError((e) {
          print("Şifre güncellenirken hata oluştu $e");
          signOut();
          return false;
        });
      }).catchError((e) {
        print("Kullanıcı getirilirken hata oluştu\n");
        print("Yeni şifreniz alanı boş geçilemez\n");
        print("Hata: "+ e.toString());
        return false;
      });
    } catch (e) {
      print("Şifre Güncelleme hata: " + e.toString());
      return false;
    }
  }
}
