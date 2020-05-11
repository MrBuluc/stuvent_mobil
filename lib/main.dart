import 'package:flutter/material.dart';
import 'package:stuventmobil/ui/Generate_Event/GeneratEvent.dart';
import 'package:stuventmobil/ui/QrCode/scan.dart';
import 'ui/homepage/home_page.dart';
import 'ui/Login/login.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool otoGiris = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: true,
      initialRoute: "/",
      //otoGiris ? "/" : "home",
      routes: {
        "/": (context) => Login(),
        "home": (context) => HomePage(),
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

  void read() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    try {
      final file = File("$path/user.txt");
      String contents = await file.readAsString();
      if (contents == "Oto_Giris= true") {
        debugPrint(contents);
        otoGiris = true;
        debugPrint(otoGiris.toString());
        return;
      }else{
        otoGiris = false;
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
      otoGiris = false;
    }
    return;
  }
}
