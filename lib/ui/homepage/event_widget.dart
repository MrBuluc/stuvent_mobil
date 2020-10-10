import 'package:flutter/material.dart';

import '../../model/event.dart';

class EventWidget extends StatefulWidget {
  final Event event;
  const EventWidget({Key key, this.event}) : super(key: key);

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(31.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
                child: Text(
              widget.event.title,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            )),
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
              child: Hero(
                tag: widget.event.title,
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/loading.gif",
                  image: widget.event.imageURL,
                  height: 150.0,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
