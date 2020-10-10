import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app_state.dart';
import 'package:stuventmobil/model/category.dart';
import 'package:stuventmobil/model/event.dart';
import 'package:stuventmobil/notification_handler.dart';
import 'package:stuventmobil/styleguide.dart';
import 'package:stuventmobil/ui/Profil/profil.dart';
import 'package:stuventmobil/ui/event_details/event_details_page.dart';
import 'package:stuventmobil/ui/homepage/event_widget.dart';
import 'package:stuventmobil/ui/homepage/home_page_background.dart';

import 'category_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    events.clear();
    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: read,
        child: ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: Stack(
            children: <Widget>[
              HomePageBackground(
                screenHide: MediaQuery.of(context).size.height,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: (width / 12)),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "STUVENT ETKİNLİK HABERCİSİ",
                              style: fadedTextStyle,
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.person,
                                color: Color(0x99FFFFFF),
                              ),
                              tooltip: "Profil Ayarları",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Profil()),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          "Çevrendeki Etkinliklere Gözat 🥳",
                          style: whiteHeadingTextStyle,
                          textAlign: TextAlign.center,
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
                        child: FutureBuilder<void>(
                          future: read(),
                          builder: (context, sonuc) => Consumer<AppState>(
                            builder: (context, appState, _) => Column(
                              children: <Widget>[
                                for (final event in events)
                                  if (event.categoryIds
                                      .contains(appState.selectedCategoryId))
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetailsPage(
                                                event: event,
                                              ),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
