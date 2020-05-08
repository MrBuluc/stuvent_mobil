import 'package:flutter/material.dart';
import 'package:stuventmobil/ui/Generate_Event/GeneratEvent.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'ui/homepage/home_page.dart';
import 'login_page.dart';

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
        "/": (context) => LoginPage(),
        "/home" : (context) => HomePage(),
        "/scan" : (context) => ScanScreen(),
        "/generatevent": (context) => GeneratEvent(),
      },
      onUnknownRoute: (RouteSettings settings) => MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        primaryColor: Color(0xFFFF4700),
      ),
    );
  }
}
