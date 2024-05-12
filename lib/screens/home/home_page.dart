import 'package:flutter/material.dart';
import 'package:ounce/screens/delivery/pending_tab.dart';
import 'package:provider/provider.dart';
import 'package:ounce/models/user_model.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import 'package:ounce/theme/theme.dart';
import 'package:ounce/widgets/product_card.dart';
import 'package:ounce/widgets/products_tile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom:const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'In-progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            PendingTab(),
          ],
        ),
      ),
    );
  }
}
