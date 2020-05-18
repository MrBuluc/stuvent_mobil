import 'package:flutter/material.dart';
import 'package:stuventmobil/styleguide.dart';
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
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/loading.gif",
                image: widget.event.imageURL,
                height: 150.0,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.event.title,
                          style: eventTitleTextStyle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        FittedBox(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                widget.event.location,
                                style: eventLocationTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.event.date.toString(),
                      textAlign: TextAlign.right,
                      style: eventLocationTextStyle.copyWith(
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
