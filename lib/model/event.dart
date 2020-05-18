import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title, location, imageURL;
  final Timestamp date;
  final List categoryIds;

  Event(
      {this.title, this.location, this.date, this.categoryIds, this.imageURL});
}

final List<Event> events = [];

final Firestore _firestore = Firestore.instance;

String ad, konum, url;
List categoryList;
Timestamp date;

Future<void> read() async {
  events.clear();

  QuerySnapshot querySnapshot =
      await _firestore.collection("Etkinlikler").getDocuments();

  Map map = querySnapshot.documents.asMap();
  int len = map.length;
  for (int i = 0; i < len; i++) {
    DocumentSnapshot documentSnapshot =
        await _firestore.document("Etkinlikler/$i").get();
    ad = documentSnapshot.data["Etkinlik Adı"];
    konum = documentSnapshot.data["Etkinlik Konumu"];
    url = documentSnapshot.data["Etkinlik Photo Url"];
    date = documentSnapshot.data["Etkinlik Tarihi"];
    categoryList = documentSnapshot.data["category"];

    Event event = new Event(
        title: ad,
        location: konum,
        date: date,
        categoryIds: categoryList,
        imageURL: url);
    events.add(event);
  }
}
