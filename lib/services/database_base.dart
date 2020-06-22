import 'package:stuventmobil/model/user.dart';

abstract class DBBase {
  Future<bool> setData(String collection, String document, Map<String, dynamic> map);
  Future<User> readUser(String userID);
  Future<bool> updateProfilFoto(String userID, String profilFotoURL);
  Future<bool> eventDel(String document);
}