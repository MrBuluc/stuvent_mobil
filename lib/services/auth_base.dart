import 'package:stuventmobil/model/userC.dart';

abstract class AuthBase {
  Future<UserC> currentUser();
  Future<bool> signOut();
  Future<UserC> signInWithGoogle();
  Future<UserC> signInWithEmailandPassword(String email, String sifre);
  Future<UserC> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser);
  Future<bool> sifreGuncelle(String password);
  Future<bool> sendPasswordResetEmail(String mail);
}
