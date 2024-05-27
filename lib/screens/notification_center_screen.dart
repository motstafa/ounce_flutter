import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';


// The Notification Center screen
class NotificationCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Notifications'),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              var notification = provider.notifications[index];
              return ListTile(
                title: Text(notification.title),
                subtitle: Text(notification.text),
                onTap: () {
                  // Mark the notification as read
                  provider.markAsRead(notification.id as int);
                  // Navigate to the relevant screen
                  Navigator.pushNamed(context, '/details', arguments: notification);
                },
              );
            },
          );
        },
      ),
    );
  }
}