import 'package:flutter/material.dart';
import 'package:stuventmobil/ui/Generate_Event/GeneratEvent.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'ui/Login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true,
      initialRoute: "/",
      routes: {
        "/": (context) => Login(),
        "/scan": (context) => ScanScreen(),
        "/generatevent": (context) => GeneratEvent(),
      },
      onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(
        builder: (context) => Login(),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primaryColor: Color(0xFFFF4700),
      ),
    );
  }
}
