import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/landing_page.dart';
import 'package:stuventmobil/locator.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        title: 'Stuvent Etkinlik Habercisi',
        debugShowCheckedModeBanner: false,
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