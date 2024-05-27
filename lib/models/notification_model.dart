// A simple model for a notification
import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class NotificationItem {
  final int id;
  final String title;
  final String text;
  final int read;

  NotificationItem({
    required this.id,
    required this.title,
    required this.text,
    required this.read,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
        id: json['id'],
        title: json['title'],
        text: json['text'],
        read: json['read']);
  }
}
