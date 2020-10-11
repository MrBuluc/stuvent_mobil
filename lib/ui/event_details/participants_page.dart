import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/merkez_widget.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

class ParticipantsPage extends StatefulWidget {
  String eventName;

  ParticipantsPage({@required this.eventName});

  @override
  _ParticipantsPageState createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  List<dynamic> participants = [];

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    readParticipants(_userModel, widget.eventName);
    return Scaffold(
      appBar: AppBar(
        title: Text("Katılımcılar Listesi"),
        backgroundColor: Color(0xFFFF4700),
      ),
      body: participants.length == 0
          ? MerkezWidget(
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
            )
          : ListView(
              children: participants
                  .map((participant) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Text(
                            (participants.indexOf(participant) + 1).toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          title: Text(
                            participant,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  Future<void> readParticipants(UserModel userModel, String eventName) async {
    try {
      participants = await userModel.readParticipants(eventName);
    } catch (e) {
      print("readParticipants hata: " + e.toString());
    }
  }
}
