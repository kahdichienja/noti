import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationSetUp {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotification() async {
    AwesomeNotifications().initialize('resource://drawable/res_launcher_icon', [
      NotificationChannel(
        channelKey: 'high_importance_channel',
        channelName: 'Chat notifications',
        importance: NotificationImportance.Max,
        vibrationPattern: highVibrationPattern,
        channelShowBadge: true,
        channelDescription: 'Chat notifications.',
      ),
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void configurePushNotifications(BuildContext context) async {
    initializeNotification();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) getIOSPermission();

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("================");
      print("=========${message.notification!.body}=======");
      print("================");
      if (message.notification != null) {
        createOrderNotifications(
          title: message.notification!.title,
          body: message.notification!.body,
        );
      }
    });
  }

  Future<void> createOrderNotifications({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 0,
      channelKey: 'high_importance_channel',
      title: title,
      body: body,
    ));
  }

  void eventListenerCallback(BuildContext context) {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  void getIOSPermission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }
}

@pragma("vm:entry-point")
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedNotification receivedNotification) async {


    // Your code goes here
  }
}
