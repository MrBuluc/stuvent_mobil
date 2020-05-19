import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/event.dart';
import 'package:stuventmobil/ui/QrCode/generate.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  final String uId;

  const EventDetailsPage({Key key, this.event, this.uId}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final Firestore _firestore = Firestore.instance;
  bool superU = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    superUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              heightFactor: 2.0,
              child: Hero(
                tag: widget.event.title,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/loading.gif",
                  image: widget.event.imageURL,
                  height: 300.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Color(0xFFFF4700),
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScanScreen(widget.uId)),
                      );
                    },
                    child: const Text('Yoklama al')),
              ),
              if (superU)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: RaisedButton(
                      color: Color(0xFFFF4700),
                      textColor: Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GenerateScreen(widget.event.title)),
                        );
                      },
                      child: const Text('QR oluştur')),
                ),
            ])
          ],
        ),
      ),
    );
  }

  Future<void> superUser() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.document("Users/${widget.uId}").get();

    setState(() {
      superU = documentSnapshot.data["SuperUser"];
    });
  }
}
