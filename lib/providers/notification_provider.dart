import 'package:flutter/material.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:provider/provider.dart';
import 'package:ounce/services/balance_service.dart';
import 'package:ounce/theme/theme.dart';
import 'package:sizer/sizer.dart';



class NotificationProvider with ChangeNotifier{

late int notificationCount=1;

}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  late String pageName;
  late String balanceType;

  CustomAppBar({required this.pageName,required this.balanceType});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$pageName Page'),
      backgroundColor: Colors.black,
      actions: <Widget>[
        Consumer<NotificationProvider>(
          builder: (context, provider, child) {
            return Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 20.0.w), // 20% of screen width
                  child: displayBalance(balanceType: '$balanceType'),
                ),
                   IconButton(
                    icon: Icon(Icons.notifications),
                    iconSize: 24, // Fixed icon size
                    onPressed: () {
                      // Navigate to notifications page
                    },
                  ),
                if (provider.notificationCount > 0)
                  Positioned(
                    right: 12, // Adjusted to position the badge on the bell icon based on the fixed icon size
                    top: 10, // Adjusted to position the badge correctly above the bell icon
                    child: Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints:const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${provider.notificationCount}', // Dynamic notification count
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8, // Fixed font size
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );

  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

