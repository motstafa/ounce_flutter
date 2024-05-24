import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/constants.dart';

class PushNotificationService {
  String baseUrl = Constants.apiUri;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Request permission for notifications
    await _firebaseMessaging.requestPermission();

    // Initialize the Flutter Local Notifications Plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'channel ID', // You can name this whatever you want
            'channel Name', // You can name this whatever you want
            channelDescription: 'channel description',
            // You can name this whatever you want
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
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
