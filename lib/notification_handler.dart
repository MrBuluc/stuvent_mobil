import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:stuventmobil/ui/event_details/event_details_page.dart';
import 'model/event.dart';
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Arka planda gelen data:" + data.toString());
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
  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.subscribeToTopic("all");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        await showNotification(message);
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

  static Future<void> showNotification(Map<String, dynamic> message) async {
    var bigTextStyleInformation;
    var bigPictureStyleInformation;

    if (message["data"].containsKey("bigText")) {
      bigTextStyleInformation = BigTextStyleInformation(
          message["data"]["bigText"],
          htmlFormatBigText: true,
          contentTitle: message["data"]["title"],
          htmlFormatContentTitle: true,
          summaryText: message["data"]["message"],
          htmlFormatSummaryText: true);
    } else {
      var bigPicturePath = await _downloadAndSaveFile(
          message["data"]["image-url"], 'bigPicture');

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
        styleInformation: message["data"].containsKey("bigText")
            ? bigTextStyleInformation
            : bigPictureStyleInformation);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"],
        message["data"]["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint("notification payload: " + payload);
      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);
      Map<String, dynamic> data = gelenBildirim["data"];
      List<dynamic> categoryIds = [0];
      Map<String, dynamic> documentsMap = {};

      try {
        Event event = Event(
            title: data["title"],
            location: data["message"],
            categoryIds: categoryIds,
            imageURL: data["image-url"],
            documentsMap: documentsMap);
        print("Event: $event");

        Navigator.push(
            myContext,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(
                event: event,
              ),
            ));
      } catch (e) {
        print("Hata: $e");
      }
    }
  }

  static Future<String> _downloadAndSaveFile(
      String url, String fileName) async {
    try{
      var directory = await getApplicationDocumentsDirectory();
      var filePath = '${directory.path}/$fileName';
      var response = await http.get(url);
      var file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    }catch (e) {
      print(" _downloadAndSaveFile Hata: $e");
    }

  }
}
