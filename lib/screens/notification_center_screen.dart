import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../main.dart';
import '../providers/notification_provider.dart';
import '../theme/theme.dart';


// The Notification Center screen
class NotificationCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(S.of(context).notification),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.notifications.length,
            itemBuilder: (context, index) {
              var notification = provider.notifications[index];
              return
                Container(
                margin: const EdgeInsets.only(bottom: 6),
                child:ListTile(
                title: Text(isArabic() ? notification.titleAr : notification.title),
                subtitle: Text(isArabic() ? notification.textAr : notification.text),
                onTap: () async {
                  // Mark the notification as read
                  provider.markAsRead(notification.id as int);
                  // Navigate to the relevant screen

                  List<String> parts = notification.route.split(',');
                  String route = parts[0];
                  int? tabIndex;
                  if (parts.length > 1 && parts[1].isNotEmpty) {
                    tabIndex = int.tryParse(parts[1]);
                  }
                  await Navigator.of(context).pushNamed(route, arguments: tabIndex);
                  },
                tileColor: notification.read == 0 ? blackColor : Colors.transparent,
              ));
            },
          );
        },
      ),
    );
  }
}