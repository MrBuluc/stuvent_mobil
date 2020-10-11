import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/common_widget/merkez_widget.dart';
import 'package:stuventmobil/ui/Login/login.dart';
import "package:stuventmobil/ui/homepage/home_page.dart";
import 'package:stuventmobil/viewmodel/user_model.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context,
        listen:
            true); // "listen" default olarak "true " kabul edildigi icin bunu yazmaya da bilisiniz
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return Login();
      } else {
        return HomePage();
      }
    } else {
      return Scaffold(
        backgroundColor: Color(0xff84b7f1),
        body: MerkezWidget(
          children: [
            Image.asset(
              "assets/icon.png",
              height: 100,
              width: 100,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Stuvent'a Hoşgeldiniz",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff1c984)),
            )
          ],
        ),
      );
    }
  }
}
