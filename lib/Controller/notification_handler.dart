import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('message received background : ${message.notification?.title}');
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'channel_notification', 'High Importance Notification',
      description: 'User For Notification',
      importance: Importance.defaultImportance);

  final _localNotification = FlutterLocalNotificationsPlugin();

  //allow user
  Future<void> initPushNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    print('User granted permission : ${settings.authorizationStatus}');

    //get token
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token : $token');
    });

    //handler terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("terminatedNotification : ${message!.notification?.title}");
    });

    //handler onbackground message
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //foreground
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification== null) return;
      _localNotification.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  _androidChannel.id, _androidChannel.name,
                  channelDescription: _androidChannel.description,
                  icon: '@drawable/ic_launcher')),
          payload: jsonEncode(message.toMap()));
      print(
          'message received while app is in foreground : ${message.notification?.title}');
    });

    //open message
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message opened from notification : ${message.notification?.title}');
    });
  }

  Future initLocalNotification() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);
    await _localNotification.initialize(settings);
  }
}
