
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';

import '../../models/pending_operation_model.dart';



class CompletedTab extends StatefulWidget {
  @override
  _CompletedTabState createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  void initState() {
    super.initState();
    // Load the data when the widget is first added to the widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperationTracksProvider>(context, listen: false)
          .fetchCompleteOperations();
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
        await pendingProvider.fetchCompleteOperations();
      },
      child: Consumer<OperationTracksProvider>(
        builder: (context, provider, child) {
          // Use the provider's data to build the ListView
          return ListView.builder(
            itemCount: provider.completedItems.length,
            itemBuilder: (context, index) {
              final item = provider.completedItems[index];
              return ListTile(
                title: Text(item.operationId.toString()),
                // Assuming 'operationStatus' is the title
                subtitle: Text(item.operationStatus),
                // Assuming 'streetAdress' is the subtitle
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CompletedDialog(item: item);
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



class CompletedDialog extends StatefulWidget {
  final PendingOperation item;

  const CompletedDialog({super.key, required this.item});

  @override
  _CompletedDialogState createState() => _CompletedDialogState();
}

class _CompletedDialogState extends State<CompletedDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Delivery Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align items to the start of the cross axis
                children: <Widget>[
                  Flexible(
                    child: Text('Name: ${widget.item.address.fullName}'),
                  ),
                  Flexible(
                    child: Text('Phone: ${widget.item.address.phone}'),
                  ),
                ],
              ),
              // Add a SizedBox for consistent spacing between rows
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align items to the start of the cross axis
                children: <Widget>[
                  Flexible(
                    child:
                    Text('Prefecture: ${widget.item.address.prefecture}'),
                  ),
                  Flexible(
                    child:
                    Text('City or Town: ${widget.item.address.cityTown}'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text('Ward: ${widget.item.address.ward}'),
                    ),
                    Flexible(
                      child:
                      Text('Street: ${widget.item.address.streetAdress}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text('Building: ${widget.item.address.building}'),
                    ),
                    Flexible(
                      child: Text('Floor: ${widget.item.address.floor}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: const <Widget>[
         
        ]);
  }
}

