import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:stuventmobil/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadFile(
      String anaKlasor, File dosya, String etkinlikAdi, String dosyaAdi) async {
    _storageReference = _firebaseStorage
        .ref()
        .child(anaKlasor)
        .child(etkinlikAdi)
        .child(dosyaAdi);
    var uploadTask = _storageReference.putFile(dosya);
    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    return url;
  }

  @override
  Future<bool> deleteFile(String anaKlasor, String etkinlikAdi, String dosyaAdi) {
    _storageReference = _firebaseStorage
        .ref()
        .child(anaKlasor)
        .child(etkinlikAdi)
        .child(dosyaAdi);
    _storageReference
        .delete()
        .then((value) => true)
        .catchError((onError) => false);
    return Future.value(false);
  }

  @override
  Future<bool> delFiles(String anaKlasor, String etkinlikAdi, List<String> files) {
    for(String fileName in files){
      _storageReference = _firebaseStorage.ref().child(anaKlasor).child(etkinlikAdi).child(fileName);
      _storageReference
          .delete()
          .then((value) => true)
          .catchError((onError) => false);
    }
    _storageReference = _firebaseStorage.ref().child(anaKlasor).child(etkinlikAdi).child("event_photo.png");
    _storageReference.delete().then((value) => true).catchError((onError) => false);
    return Future.value(false);
  }
}
