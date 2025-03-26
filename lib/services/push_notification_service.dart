import 'dart:convert';
import 'package:flutter/foundation.dart';
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
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // For iOS, explicitly wait for APNS token
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        while (apnsToken == null) {
          // Wait a bit and retry
          await Future.delayed(Duration(seconds: 1));
          apnsToken = await _firebaseMessaging.getAPNSToken();
        }
      }

      // Get FCM token
      String? token = await _firebaseMessaging.getToken();

      if (token != null) {
        await saveFCMTokenLocally(token);
        print('FCM Token for iOS: $token');
      } else {
        print('Failed to get FCM token for iOS');
      }
    } else {
      print('Notification permissions not granted');
    }
  }

  Future<void> handleFCMToken() async {
    // Ensure we wait for the APNs token (iOS only)
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        print("[Error] APNs token not available. FCM token cannot be retrieved yet.");
        return;
      }
    }

    String? localToken = await getFCMTokenFromLocal();

    if (localToken == null || localToken.isEmpty) {
      String? newToken = await _firebaseMessaging.getToken();
      if (newToken != null) {
        await saveFCMTokenLocally(newToken);
        String? authToken = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences

        if (authToken != null) {
          await Constants().sendTokenToBackend(newToken);
        }
      }
    }
  }

  Future<void> saveFCMTokenLocally(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  Future<String?> getFCMTokenFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  Future<void> saveNotificationPermissionStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_permission', status);
  }

  Future<bool?> getNotificationPermissionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notification_permission');
  }

  void notificationHandler(RemoteMessage message) {
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
    print('Message Data: ${message.data}');

    if (message.data.containsKey('route')) {
      print('Route: $route');
    } else {
      print('Route key not found in data');
    }

    NotificationItem newNotification = NotificationItem(
        id: notification.hashCode,
        title: notification?.title ?? '',
        text: notification?.body ?? '',
        titleAr: message.data['title_ar'] ?? '',
        textAr: message.data['body_ar'] ?? '',
        read: 0,
        route: route ?? '');

    NotificationProvider provider = Provider.of<NotificationProvider>(
      globalContext!,
      listen: false,
    );
    provider.addNotification(newNotification);
  }

  Future onSelectNotification(String? payload) async {
    if (globalContext != null) {
      Navigator.of(globalContext!).pushNamed('/notifications');
    }
  }
}