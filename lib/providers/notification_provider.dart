import 'package:flutter/material.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/screens/home/seller_products.dart';
import 'package:ounce/screens/home/trader_home_page.dart';
import 'package:provider/provider.dart';
import '../models/notification_model.dart';
import '../services/backend_notifications.dart';

class NotificationProvider with ChangeNotifier {
  int notificationCount = 0;
  List<NotificationItem> _notifications = [];

  List<NotificationItem> get notifications => _notifications;

  Future<void> getNotifications() async {
    try {
      _notifications = await backendNotificationService().getNotifications();
      notificationCount = _notifications.where((notification) => notification.read == 0).length;
      notifyListeners();
    } catch (e) {
      print("Error fetching notifications: $e");
      // Handle error gracefully
    }
  }

  Future<void> markAsRead(int Id) async {
    try {
      if (await backendNotificationService().markAsRead(Id)) {
        // Update the local notification list to mark as read
        final index = _notifications.indexWhere((notification) => notification.id == Id);
        if (index != -1) {
          _notifications[index] = _notifications[index].copyWith(read: 1);
          notificationCount = _notifications.where((notification) => notification.read == 0).length;
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  void addNotification(NotificationItem notification) {
    // Check if notification already exists to avoid duplicates
    final existingIndex = _notifications.indexWhere((n) => n.id == notification.id);
    if (existingIndex >= 0) {
      return; // Skip if notification already exists
    }

    _notifications.insert(0, notification);
    notificationCount = _notifications.where((n) => n.read == 0).length;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications = [];
    notificationCount = 0;
    notifyListeners();
  }

}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  late String pageName;
  late String? balanceType;
  late bool? sellPage;
  CustomAppBar({required this.pageName, this.balanceType,this.sellPage});

  @override
  Widget build(BuildContext context) {
    print(sellPage);
    return AppBar(
      title: Text('$pageName'),
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Row(
                  children: [
                    if(sellPage==true)
                      IconButton(
                        icon: Icon(Icons.track_changes), // Track order icon
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SellerProducts(),)
                          );
                        },
                      ),
                    if (balanceType != null) // Conditional check at the level of Padding
                      Padding(
                        padding: const EdgeInsets.only(right: 70),
                        // 20% of screen width
                        child: displayBalance(balanceType: '$balanceType'),
                      ),
                    Stack(
                      alignment: Alignment.center, // Center the icon in the stack
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications),
                          iconSize: 24, // Fixed icon size
                          onPressed: () {
                            Navigator.pushNamed(context, '/notifications');
                          },
                        ),
                        if (provider.notificationCount > 0)
                          Positioned(
                            right: 12, // Adjust these values based on your design
                            top: 10, // Adjust these values based on your design
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${provider.notificationCount}',
                                // Dynamic notification count
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8, // Fixed font size
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              ]);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
