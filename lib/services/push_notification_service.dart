import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/models/notification_model.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
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
        alert: true, badge: true, sound: true, provisional: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // For iOS, we'll initialize the notification setup,
      // but we won't try to get the token yet - we'll do that when needed

      // Initialize local notifications
      final InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      print('Notification service initialized');
    } else {
      print('Notification permissions not granted');
    }
  }

  // Enhanced method to safely get FCM token on both platforms
  Future<String?> getValidFCMToken() async {
    try {
      // First check if we have a cached token
      String? cachedToken = await getFCMTokenFromLocal();
      if (cachedToken != null && cachedToken.isNotEmpty) {
        return cachedToken;
      }

      // If no cached token, we need to get a new one
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        // On iOS, we need to ensure APNS token is available first
        String? apnsToken = await _firebaseMessaging.getAPNSToken();
        int attempts = 0;

        // Wait up to 10 seconds for APNS token with periodic checks
        while (apnsToken == null && attempts < 10) {
          print('Waiting for APNS token, attempt ${attempts + 1}');
          await Future.delayed(Duration(seconds: 1));
          apnsToken = await _firebaseMessaging.getAPNSToken();
          attempts++;
        }

        if (apnsToken == null) {
          print('Failed to get APNS token after $attempts attempts');
          return null;
        }

        print('APNS token received: ${apnsToken.substring(0, 10)}...');
      }

      // Now get the FCM token (on iOS this requires APNS token to be set)
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        await saveFCMTokenLocally(token);
        print('FCM Token obtained: ${token.substring(0, 10)}...');
        return token;
      } else {
        print('Failed to get FCM token');
        return null;
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  void notificationHandler(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Show local notification
    if (notification != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
            'This channel is used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: android?.smallIcon,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }

    // Process notification data regardless of context availability
    if (message.data['type'] == 'new_operation_assigned') {
      // Use a separate method to handle operation updates to ensure it works regardless of context
      print(message.data['type']);
      _handleNewOperationAssigned();
    }

    // Update notification provider if context is available
    if (globalContext != null) {
      try {
        NotificationItem newNotification = NotificationItem(
          id: message.messageId.hashCode,
          title: notification?.title ?? message.data['title'] ?? '',
          text: notification?.body ?? message.data['body'] ?? '',
          titleAr: message.data['title_ar'] ?? '',
          textAr: message.data['body_ar'] ?? '',
          read: 0,
          route: message.data['route'] ?? '',
        );

        // Update notification count in UI
        Future.microtask(() {
          final provider = Provider.of<NotificationProvider>(
            globalContext!,
            listen: false,
          );
          provider.addNotification(newNotification);
        });
      } catch (e) {
        print("Error updating notification UI: $e");
      }
    }
  }

  // New method to handle operation updates
  void _handleNewOperationAssigned() {
    if (globalContext != null) {
      try {
        Provider.of<OperationTracksProvider>(globalContext!, listen: false)
            .fetchPendingOperations();
      } catch (e) {
        print("Error updating operations after notification: $e");
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
}