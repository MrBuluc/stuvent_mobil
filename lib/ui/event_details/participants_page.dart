import 'package:flutter/material.dart';

class ParticipantsPage extends StatefulWidget {
  List<dynamic> participants;

  ParticipantsPage({@required this.participants});

  @override
  _ParticipantsPageState createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Katılımcılar Listesi"),
        backgroundColor: Color(0xFFFF4700),
      ),
      body: widget.participants.isEmpty
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 120,
                    ),
                    Text(
                      "Henüz Yoklama Yapılmamıştır",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 36),
                    )
                  ],
                ),
              ),
            )
          : ListView(
              children: widget.participants
                  .map((index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          index,
                          style: TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
