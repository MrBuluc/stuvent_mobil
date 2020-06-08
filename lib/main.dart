import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/landing_page.dart';
import 'file:///C:/Users/HAKKICAN/Desktop/Sifirdan%20Flutter%20ile%20Android%20ve%20Ios%20Apps%20Development/flutter%20projeleri/stuvent_hakkican/lib/repository/user_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
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
