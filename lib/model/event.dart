import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Event {
  final String title, location, imageURL;
  final List categoryIds;
  final Map<String, dynamic> documentsMap;

  @override
  String toString() {
    return "title: $title \n"+
            "location: $location \n"+
            "categoryIds: $categoryIds \n"+
            "documentsList: $documentsMap \n";
  }

  Event(
      {this.title,
      this.location,
      this.categoryIds,
      this.imageURL,
      this.documentsMap});
}

final List<Event> events = [];

final Firestore _firestore = Firestore.instance;

String ad, konum, url;
List categoryList;
Map<String, dynamic> docMap;

Future<void> read() async {
  events.clear();

  QuerySnapshot querySnapshot =
      await _firestore.collection("Etkinlikler").getDocuments();

  List<DocumentSnapshot> documentSnapshotList = querySnapshot.documents;

  documentSnapshotList.forEach((documentSnapshot) {
    try{
      ad = documentSnapshot.data["Etkinlik Adı"];
      konum = documentSnapshot.data["Etkinlik Konumu"];
      url = documentSnapshot.data["Etkinlik Photo Url"];
      categoryList = documentSnapshot.data["category"];
      docMap = documentSnapshot.data["Dosyalar"];


      Event event = new Event(
          title: ad,
          location: konum,
          categoryIds: categoryList,
          imageURL: url,
          documentsMap: docMap);
      events.add(event);
    }catch(e) {
      debugPrint("Hata: $e");
    }

  });
}
