import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../../providers/notification_provider.dart';

class TraderHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.black,
      appBar: CustomAppBar(
          pageName: S
              .of(context)
              .homeLabel, balanceType: null),
      );
  }
}
