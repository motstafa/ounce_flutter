import 'dart:convert';
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
        try {
          Provider.of<OperationTracksProvider>(globalContext!, listen: false)
              .fetchPendingOperations();
        } catch (e) {
          print("Error updating operations after notification: $e");
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
