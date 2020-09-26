import 'package:flutter/material.dart';
import 'package:qr_flutter/src/qr_image.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class GenerateScreen extends StatefulWidget {
  String text;
  GenerateScreen(this.text);
  @override
  State<StatefulWidget> createState() => GenerateScreenState(text);




}

class GenerateScreenState extends State<GenerateScreen> {

  String _dataString;
  GenerateScreenState(this._dataString);

  // static const double _topSectionTopPadding = 50.0;
  // static const double _topSectionBottomPadding = 20.0;
  // static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  //String _inputErrorText;
  //final TextEditingController _textController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_dataString Event QR'),
      ),
      body: _contentWidget(),
    );
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: _dataString,
                  size: 0.5 * bodyHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}