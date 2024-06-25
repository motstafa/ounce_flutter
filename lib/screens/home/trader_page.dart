import 'package:flutter/material.dart';
import 'package:ounce/screens/home/buy_page.dart';
import 'package:ounce/screens/home/trader_home_page.dart';
import 'package:ounce/screens/home/profile_page.dart';
import 'package:ounce/screens/home/sell_page.dart';
import 'package:ounce/theme/theme.dart';

import '../../generated/l10n.dart';
import '../../providers/notification_provider.dart';

class TraderPage extends StatefulWidget {
  @override
  _TraderPageState createState() => _TraderPageState();
}

class _TraderPageState extends State<TraderPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4.0), // Adjust the padding as needed
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: GoldColor ?? Colors.amber, // Set your special border color here
              width: 1.5, // Set the width of the border
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: GoldInBetween,
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
                    color: currentIndex == 0 ? GoldInBetween : buttonAccentColor.withOpacity(0.5),
                  ),
                  label: S.of(context).homeLabel,
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/icons/buy.png'),
                    color: currentIndex == 1 ? GoldInBetween : buttonAccentColor.withOpacity(0.5),
                  ),
                  label: S.of(context).buyDialogButtonText,
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/icons/sell.png'),
                    color: currentIndex == 2 ? GoldInBetween : buttonAccentColor.withOpacity(0.5),
                  ),
                  label: S.of(context).sellLabel,
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/icons/profile.png'),
                    color: currentIndex == 3 ? GoldInBetween : buttonAccentColor.withOpacity(0.5),
                  ),
                  label: S.of(context).profileLabel,
                ),
              ],
            ),
          ),
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