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
            "documentsList: $documentsMap \n"+
            "imageURL: $imageURL \n";
  }

  Event(
      {this.title,
      this.location,
      this.categoryIds,
      this.imageURL,
      this.documentsMap});
}

final List<Event> events = [];

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

String ad, konum, url;
List categoryList;
Map<String, dynamic> docMap;

Future<void> read() async {
  events.clear();

  QuerySnapshot querySnapshot =
      await _firestore.collection("Etkinlikler").get();

  List<DocumentSnapshot> documentSnapshotList = querySnapshot.docs;

  documentSnapshotList.forEach((documentSnapshot) {
    try{
      Map<String, dynamic> data = documentSnapshot.data();
      ad = data["Etkinlik Adı"];
      konum = data["Etkinlik Konumu"];
      url = data["Etkinlik Photo Url"];
      categoryList = data["category"];
      docMap = data["Dosyalar"];


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
