import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuventmobil/app/landing_page.dart';
import 'package:stuventmobil/locator.dart';
import 'package:stuventmobil/viewmodel/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

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
  void initState() {
    // TODO: implement initState
    super.initState();
    setupNotification();
  }

  void setupNotification() async {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

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
