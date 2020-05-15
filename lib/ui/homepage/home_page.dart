import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/model/category.dart';
import 'package:stuventmobil/model/event.dart';
import 'package:stuventmobil/styleguide.dart';
import 'package:stuventmobil/ui/event_details/event_details_page.dart';
import 'package:stuventmobil/ui/homepage/event_widget.dart';
import 'package:stuventmobil/ui/homepage/home_page_background.dart';
import 'package:stuventmobil/app_state.dart';
import 'package:stuventmobil/ui/profil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'category_widget.dart';

class HomePage extends StatefulWidget {
  String uID;

  HomePage(this.uID);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Firestore _firestore = Firestore.instance;

  String ad,konum,url,category;
  Timestamp date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: Stack(
          children: <Widget>[
            HomePageBackground(
              screenHide: MediaQuery.of(context).size.height,
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "ETKİNLİK HABERCİSİ",
                            style: fadedTextStyle,
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.person,
                              color: Color(0x99FFFFFF),
                            ),
                            tooltip: "Profil",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Profil(widget.uID)),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "IEEE MSKU 🔋",
                        style: whiteHeadingTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) =>
                            SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final category in categories)
                                CategoryWidget(category: category)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) => Column(
                          children: <Widget>[
                            for (final event in events.where((e) => e
                                .categoryIds
                                .contains(appState.selectedCategoryId)))
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailsPage(event: event),
                                  ));
                                },
                                child: EventWidget(
                                  event: event,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> read() async {
    final events = [
    ];
    events.add("0");
    QuerySnapshot querySnapshot =
        await _firestore.collection("Etkinlikler").getDocuments();

    Map map = querySnapshot.documents.asMap();
    int len = map.length;
    for(int i = 0; i<len;  i++){
      DocumentSnapshot documentSnapshot =
      await _firestore.document("Etkinlikler/$i").get();
      setState(() {
        ad = documentSnapshot.data["Etkinlik Adı"];
        konum = documentSnapshot.data["Etkinlik Konumu"];
        url = documentSnapshot.data["Etkinlik Photo Url"];
        date = documentSnapshot.data["Etkinlik Tarihi"];
        category = documentSnapshot.data["category"];

      });
      debugPrint("Ad: $ad");
      debugPrint("Konum: $konum");
      debugPrint("URL: $url");
      debugPrint("Tarih: ${date.toDate()}");
      debugPrint("Category: $category");
    }
  }
}
