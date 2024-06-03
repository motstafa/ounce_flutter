import 'package:flutter/material.dart';
import 'package:ounce/screens/home/buy_page.dart';
import 'package:ounce/screens/home/trader_home_page.dart';
import 'package:ounce/screens/home/profile_page.dart';
import 'package:ounce/screens/home/sell_page.dart';
import 'package:ounce/theme/theme.dart';

import '../../generated/l10n.dart';

class TraderPage extends StatefulWidget {
  @override
  _TraderPageState createState() => _TraderPageState();
}

class _TraderPageState extends State<TraderPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                color: currentIndex == 0 ? buttonFocusedColor : buttonAccentColor.withOpacity(0.5),
              ),
              label: S.of(context).homeLabel,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/buy.png'),
                color: currentIndex == 1 ? buttonFocusedColor : buttonAccentColor.withOpacity(0.5),
              ),
              label: S.of(context).buyDialogButtonText,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/sell.png'),
                color: currentIndex == 2 ? buttonFocusedColor : buttonAccentColor.withOpacity(0.5),
              ),
              label: S.of(context).sellLabel,
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/icons/profile.png'),
                color: currentIndex == 3 ? buttonFocusedColor : buttonAccentColor.withOpacity(0.5),
              ),
              label: S.of(context).profileLabel,
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
        return TraderHomePage();
      case 1:
        return BuyPage();
      case 2:
        return SellPage();
      case 3:
        return ProfilePage();
      default:
        return TraderHomePage();
    }
  }
}