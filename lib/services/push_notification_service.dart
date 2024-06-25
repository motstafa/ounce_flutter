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
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Initialize the Flutter Local Notifications Plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.notificationResponseType ==
          NotificationResponseType.selectedNotification) {
        onSelectNotification(response.payload);
      }
    },);

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');
    //save token in the backend
    sendTokenToBackend(token);
    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      notificationHandler(message);
    });
  }

  void notificationHandler(RemoteMessage message) {
    // If the message also contains a notification (such as title and body),
    // we can display a notification to the user using the flutter_local_notifications plugin.
    // print('Message received: ${message.toMap()}'); // Log the entire message

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel ID',
            'channel Name',
            channelDescription: 'channel description',
            icon: android.smallIcon,
          ),
        ),
      );
    }

    String? route = message.data['route'];
    // Log the entire data map
    print('Message Data: ${message.data}');

    if (message.data.containsKey('route')) {
      String? route = message.data['route'];
      if (route != null) {
        // Handle the route as needed
        print('Route: $route');
      } else {
        print('Route key exists but value is null');
      }
    } else {
      print('Route key not found in data');
    }
    // Assuming you have a way to convert RemoteMessage to NotificationItem
    NotificationItem newNotification = NotificationItem(id:notification.hashCode,title: notification?.title ?? '',text: notification?.body ??'',titleAr:message.data['title_ar']??'' ,textAr: message.data['body_ar']??'',read: 0,route: route ??'');

    // Find the provider and call addNotification
    NotificationProvider provider = Provider.of<NotificationProvider>(
      globalContext!, // You need to have a reference to the context
      listen: false,
    );
   provider.addNotification(newNotification);
  }



  Future onSelectNotification(String? payload) async {
    // Navigate to the notifications screen
    if (globalContext != null) {
      Navigator.of(globalContext!).pushNamed('/notifications');
    }
  }

  Future<bool> sendTokenToBackend(notificationToken) async {
    final prefs = await SharedPreferences.getInstance();

    var url = '$baseUrl/saveNotificationToken';

    final token =
        prefs.getString('auth_token'); // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    var body = jsonEncode({
      'notification_token': notificationToken,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal Login');
    }
  }
}
