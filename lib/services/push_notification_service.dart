import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/models/notification_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/constants.dart';
import '../main.dart';
import '../providers/notification_provider.dart';

class PushNotificationService {
  String baseUrl = Constants.apiUri;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  BuildContext? get globalContext => navigatorKey.currentContext;

  Future<void> init() async {
    // Request permission for notifications (for iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print("Notification permission status: ${settings.authorizationStatus}");

    // Initialize the Flutter Local Notifications Plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          onSelectNotification(response.payload);
        }
      },
    );

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');

    // Save token in the backend
    if (token != null) {
      sendTokenToBackend(token);
    }

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationHandler(message);
    });
  }

  void notificationHandler(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    AppleNotification? apple = message.notification?.apple;

    if (notification != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: android != null
              ? AndroidNotificationDetails(
            'channel ID',
            'channel Name',
            channelDescription: 'channel description',
            icon: android.smallIcon,
          )
              : null,
          iOS: apple != null
              ? DarwinNotificationDetails(
            subtitle: notification.body,
            badgeNumber: 1,
          )
              : null,
        ),
      );
    }

    String? route = message.data['route'];
    print('Message Data: ${message.data}');

    NotificationItem newNotification = NotificationItem(
      id: notification.hashCode,
      title: notification?.title ?? '',
      text: notification?.body ?? '',
      titleAr: message.data['title_ar'] ?? '',
      textAr: message.data['body_ar'] ?? '',
      read: 0,
      route: route ?? '',
    );

    NotificationProvider provider = Provider.of<NotificationProvider>(
      globalContext!,
      listen: false,
    );
    provider.addNotification(newNotification);
  }

  Future<void> onSelectNotification(String? payload) async {
    if (globalContext != null) {
      Navigator.of(globalContext!).pushNamed('/notifications');
    }
  }

  Future<bool> sendTokenToBackend(String notificationToken) async {
    final prefs = await SharedPreferences.getInstance();
    var url = '$baseUrl/saveNotificationToken';

    final token = prefs.getString('auth_token');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var body = jsonEncode({'notification_token': notificationToken});

    var response = await http.post(Uri.parse(url), headers: headers, body: body);
    print(response.body);

    return response.statusCode == 200;
  }
}
