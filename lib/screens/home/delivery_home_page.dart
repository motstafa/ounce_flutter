import 'package:flutter/material.dart';
import 'package:ounce/screens/delivery/pending_tab.dart';
import '../../generated/l10n.dart';
import '../delivery/completed_tab.dart';
import '../delivery/inProgress_tab.dart';

class DeliveryHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the tabIndex from the arguments
    final int? tabIndex = ModalRoute.of(context)?.settings.arguments as int?;

    return DefaultTabController(
      initialIndex: tabIndex ?? 0, // Use the passed tabIndex, default to 0
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          bottom:  TabBar(
            tabs: [
              Tab(text: S.of(context).pendingTab),
              Tab(text: S.of(context).inProgressTab),
              Tab(text: S.of(context).completedTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [PendingTab(), InProgressTab(), CompletedTab()],
        ),
      ),
    );
  }
}
