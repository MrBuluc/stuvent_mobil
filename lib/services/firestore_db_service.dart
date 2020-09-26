import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuventmobil/model/userC.dart';
import 'package:stuventmobil/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<UserC> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("Users").doc(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data();

    UserC _okunanUserNesnesi = UserC.userfromMap(_okunanUserBilgileriMap);

    return _okunanUserNesnesi;
  }

  Future<bool> update(String collection, String documentName, String alan,
      dynamic newData) async {
    await _firebaseDB
        .collection(collection)
        .doc(documentName)
        .update({alan: newData}).then((value) {
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
        .doc(userID)
        .update({'profilURL': profilFotoURL});
    return true;
  }

  @override
  Future<bool> setData(
      String collection, String document, Map<String, dynamic> map) async {
    await _firebaseDB
        .collection(collection)
        .doc(document)
        .set(map)
        .catchError((onError) {
      print("db setData hata: " + onError.toString());
    });
    return true;
  }

  @override
  Future<bool> eventDel(String document) async {
    await _firebaseDB
        .collection("Etkinlikler")
        .doc(document)
        .delete()
        .catchError((onError) {
      print("db setData hata: " + onError.toString());
      return false;
    });
    return true;
  }

  Future<List<String>> getEtkinlikler() async {
    QuerySnapshot querySnapshot =
        await _firebaseDB.collection("Etkinlikler").get();

    List<DocumentSnapshot> documentSnapshotList = querySnapshot.docs;

    List<String> etkinlikler = [];
    documentSnapshotList.forEach((documentSnapshot) {
      Map<String, dynamic> data = documentSnapshot.data();
      etkinlikler.add(data["Etkinlik Adı"]);
    });

    return etkinlikler;
  }

  bool yoklamaAl(String userID, String eventName) {
    try {
      final DocumentReference eventRef = _firebaseDB.doc("Users/$userID");

      List etkinlik;
      _firebaseDB.runTransaction((Transaction transaction) async {
            DocumentSnapshot eventData = await eventRef.get();
            Map<String, dynamic> data = eventData.data();
            etkinlik = data["Etkinlikler"];
            etkinlik.add(eventName);
            transaction.update(eventRef, {"Etkinlikler": etkinlik});
          });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
