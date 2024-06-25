import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
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
                subtitle: Text(Constants().getOperationStatusTranslation(
                    context, item.operationStatus)),
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
        title: Text(S.of(context).deliveryDetailsTitle),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align items to the start of the cross axis
                children: [
                  Text(
                      '${S.of(context).nameLabel}: ${widget.item.address.fullName}'),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align items to the start of the cross axis
                  children: [
                    Text('${S.of(context).phone}: ${widget.item.address.phone}')
                  ]),
              // Add a SizedBox for consistent spacing between rows
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align items to the start of the cross axis
                children: <Widget>[
                  Flexible(
                    child: Text(
                        '${S.of(context).prefecture}: ${widget.item.address.prefecture}'),
                  ),
                  Flexible(
                    child: Text(
                        '${S.of(context).city}: ${widget.item.address.cityTown}'),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align items to the start of the cross axis
                children: [
                  Text('${S.of(context).city}: ${widget.item.address.cityTown}')
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${S.of(context).wardLabel}: ${widget.item.address.ward}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${S.of(context).streetAddressLabel}: ${widget.item.address.streetAdress}'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${S.of(context).buildingLabel}: ${widget.item.address.building}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${S.of(context).floorLabel}: ${widget.item.address.floor}'),
                ],
              )
            ],
          ),
        ),
        actions: const <Widget>[]);
  }
}
