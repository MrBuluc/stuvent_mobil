import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stuventmobil/model/user.dart';
import 'package:stuventmobil/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final Firestore _firebaseDB = Firestore.instance;

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
    await _firebaseDB.collection("Users").document(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data;

    User _okunanUserNesnesi = User.userfromMap(_okunanUserBilgileriMap);

    return _okunanUserNesnesi;
  }

  Future<bool> update(String collection, String documentName, String alan,
      dynamic newData) async {
    await _firebaseDB
        .collection(collection)
        .document(documentName)
        .updateData({alan: newData}).then((value) {
      return true;
    }).catchError((onError) {
      print("db_service update hata: " + onError.toString());
      return false;
    });
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _firebaseDB
        .collection("users")
        .document(userID)
        .updateData({'profilURL': profilFotoURL});
    return true;
  }

  @override
  Future<bool> setData(String collection, String document,
      Map<String, dynamic> map) async {
    await _firebaseDB
        .collection(collection)
        .document(document)
        .setData(map)
        .catchError((onError) {
      print("db setData hata: " + onError.toString());
    });
    return true;
  }

  @override
  Future<bool> eventDel(String document) async {
    await _firebaseDB
        .collection("Etkinlikler")
        .document(document)
        .delete()
        .catchError((onError) {
      print("db setData hata: " + onError.toString());
      return false;
    });
    return true;
  }

  Future<List<String>> getEtkinlikler() async {
    QuerySnapshot querySnapshot =
    await _firebaseDB.collection("Etkinlikler").getDocuments();

    List<DocumentSnapshot> documentSnapshotList = querySnapshot.documents;

    List<String> etkinlikler = [];
    documentSnapshotList.forEach((documentSnapshot) {
      etkinlikler.add(documentSnapshot.data["Etkinlik Adı"]);
    });

    return etkinlikler;
  }
}
