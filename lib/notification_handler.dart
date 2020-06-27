import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arka planda gelen data:" + message["data"].toString());
    NotificationHandler.showNotification(message);
  }

  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();

  static final NotificationHandler _singLeton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singLeton;
  }
  NotificationHandler._internal();

  initializeFCMNotification(BuildContext context) async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.subscribeToTopic("all");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
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

  static void showNotification(Map<String, dynamic> message) async {
    var bigTextStyleInformation;
    var bigPictureStyleInformation;

    if(message["data"].containsKey("bigText")){
      bigTextStyleInformation = BigTextStyleInformation(
          message["data"]["bigText"],
          htmlFormatBigText: true,
          contentTitle: message["data"]["title"],
          htmlFormatContentTitle: true,
          summaryText: message["data"]["message"],
          htmlFormatSummaryText: true);
    }
    else{
      var bigPicturePath =
      await _downloadAndSaveFile(message["data"]["image-url"], 'bigPicture');

      bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: message["data"]["title"],
          htmlFormatContentTitle: true,
          summaryText: message["data"]["message"],
          htmlFormatSummaryText: true);
    }

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1234', 'Yeni Mesaj', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
        styleInformation: message["data"].containsKey("bigText") ? bigTextStyleInformation : bigPictureStyleInformation);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"],
        message["data"]["message"], platformChannelSpecifics,
        payload: 'Bildirim tıklanınca aktarılan değer');
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      debugPrint("notification payload: " + payload);
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
