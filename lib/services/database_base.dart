import 'package:stuventmobil/model/userC.dart';

abstract class DBBase {
  Future<bool> setData(String collection, String document, Map<String, dynamic> map);
  Future<UserC> readUser(String userID);
  Future<bool> updateProfilFoto(String userID, String profilFotoURL);
  Future<bool> eventDel(String document);
}