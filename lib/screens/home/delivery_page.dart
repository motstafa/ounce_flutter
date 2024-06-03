import 'package:flutter/material.dart';
import 'package:ounce/screens/home/delivery_home_page.dart';
import 'package:ounce/screens/home/profile_page.dart';
import 'package:ounce/theme/theme.dart';
import '../../generated/l10n.dart';
import '../../providers/notification_provider.dart';

class DeliveryPage extends StatefulWidget {
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  int currentIndex = 0;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: S.of(context).operationsProgressPageTitle, balanceType: null),
      backgroundColor: currentIndex == 0 ? backgroundColor1 : backgroundColor3,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24), // Adjust the radius as needed
          topRight: Radius.circular(24), // Adjust the radius as needed
          bottomRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: buttonFocusedColor,
          unselectedItemColor: buttonAccentColor.withOpacity(0.5),
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/home.png'),
                color: currentIndex == 0
                    ? buttonFocusedColor
                    : buttonAccentColor.withOpacity(0.5),
              ),
              label: S.of(context).homeLabel,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/profile.png'),
                color: currentIndex == 1
                    ? buttonFocusedColor
                    : buttonAccentColor.withOpacity(0.5),
              ),
              label:S.of(context).profileLabel,
            ),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    switch (currentIndex) {
      case 0:
        return DeliveryHomePage();
      case 1:
        return ProfilePage();
      default:
        return DeliveryHomePage();
    }
  }
}
