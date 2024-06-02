// A simple model for a notification
import 'dart:ffi';

import 'package:flutter/cupertino.dart';

class NotificationItem {
  final int id;
  final String title;
  final String text;
  final String titleAr;
  final String textAr;
  final int read;
  final String route;

  NotificationItem({
    required this.id,
    required this.title,
    required this.text,
    required this.titleAr,
    required this.textAr,
    required this.read,
    required this.route,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
        id: json['id'],
        title: json['title'],
        text: json['text'],
        titleAr: json['title_ar'],
        textAr: json['text_ar'],
        read: json['read'],
        route: json['route']);
  }
}
