import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/models/user_model.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import 'package:ounce/theme/theme.dart';
import 'package:ounce/widgets/product_card.dart';
import 'package:ounce/widgets/products_tile.dart';



class PendingTab extends StatefulWidget {
  @override
  _PendingTabState createState() => _PendingTabState();
}

class _PendingTabState extends State<PendingTab> {
  @override
  void initState() {
    super.initState();
    // Load the data when the widget is first added to the widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperationTracksProvider>(context, listen: false)
          .fetchPendingOperations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider but don't listen to changes to avoid unnecessary rebuilds
    var pendingProvider =
        Provider.of<OperationTracksProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        // Call the method to fetch pending operations when the user swipes to refresh
        await pendingProvider.fetchPendingOperations();
      },
      child: Consumer<OperationTracksProvider>(
        builder: (context, provider, child) {
          // Use the provider's data to build the ListView
          return ListView.builder(
            itemCount: provider.pendingItems.length,
            itemBuilder: (context, index) {
              final item = provider.pendingItems[index];
              return ListTile(
                title: Text(item.operationId.toString()),
                // Assuming 'operationStatus' is the title
                subtitle: Text(item.operationStatus),
                // Assuming 'streetAdress' is the subtitle
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delivery Details'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('Address: ${item.address.fullName}'),
                              // Use the actual address data
                              // Add more details here
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Transfer to In-progress'),
                            onPressed: () {
                              // Logic to transfer the item to 'In-progress'
                              Navigator.of(context).pop(); // Close the dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
