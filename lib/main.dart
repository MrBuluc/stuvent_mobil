import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/landing_page.dart';
import 'package:stuventmobil/locator.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: true,
        home: LandingPage(),
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          primaryColor: Color(0xFFFF4700),
          accentColor: Color(0xFFFF4700),
        ),
      ),
    );
  }
}
