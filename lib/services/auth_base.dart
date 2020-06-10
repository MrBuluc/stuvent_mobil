import 'package:stuventmobil/model/user.dart';

abstract class AuthBase {
  Future<User> currentUser();
  Future<bool> signOut();
  Future<User> signInWithGoogle();
  Future<User> signInWithEmailandPassword(String email, String sifre);
  Future<User> createUserWithEmailandPassword(String name, String lastname,
      String mail, String password, bool superUser);
}
