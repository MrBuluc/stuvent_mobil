import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title, location, imageURL;
  final List categoryIds;
  final List<dynamic> documentsList;

  @override
  String toString() {
    return "title: $title \n"+
            "location: $location \n"+
            "categoryIds: $categoryIds \n"+
            "documentsList: $documentsList \n";
  }

  Event(
      {this.title,
      this.location,
      this.categoryIds,
      this.imageURL,
      this.documentsList});
}

final List<Event> events = [];

final Firestore _firestore = Firestore.instance;

String ad, konum, url;
List categoryList;
List<dynamic> docList;

Future<void> read() async {
  events.clear();

  QuerySnapshot querySnapshot =
      await _firestore.collection("Etkinlikler").getDocuments();

  List<DocumentSnapshot> documentSnapshotList = querySnapshot.documents;

  documentSnapshotList.forEach((documentSnapshot) {
    ad = documentSnapshot.data["Etkinlik Adı"];
    konum = documentSnapshot.data["Etkinlik Konumu"];
    url = documentSnapshot.data["Etkinlik Photo Url"];
    categoryList = documentSnapshot.data["category"];
    docList = documentSnapshot.data["Dosyalar"];

    Event event = new Event(
        title: ad,
        location: konum,
        categoryIds: categoryList,
        imageURL: url,
        documentsList: docList);
    events.add(event);
  });
}
