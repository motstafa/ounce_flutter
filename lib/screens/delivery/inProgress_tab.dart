import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';

import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../models/pending_operation_model.dart';
import '../../widgets/location_detail.dart';

class InProgressTab extends StatefulWidget {
  @override
  _InProgressTabState createState() => _InProgressTabState();
}

class _InProgressTabState extends State<InProgressTab> {
  @override
  void initState() {
    super.initState();
    // Load the data when the widget is first added to the widget tree
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OperationTracksProvider>(context, listen: false)
          .fetchInProgressOperations();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the provider but don't listen to changes to avoid unnecessary rebuilds
    var inProgressProvider =
        Provider.of<OperationTracksProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        // Call the method to fetch pending operations when the user swipes to refresh
        await inProgressProvider.fetchInProgressOperations();
      },
      child: Consumer<OperationTracksProvider>(
        builder: (context, provider, child) {
          // Use the provider's data to build the ListView
          return ListView.builder(
            itemCount: provider.inProgressItems.length,
            itemBuilder: (context, index) {
              final item = provider.inProgressItems[index];
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
                      return InProgressDialog(item: item);
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

class InProgressDialog extends StatefulWidget {
  final PendingOperation item;

  const InProgressDialog({super.key, required this.item});

  @override
  _InProgressDialogState createState() => _InProgressDialogState();
}

class _InProgressDialogState extends State<InProgressDialog> {
  bool _isChecked = false; // Define this in your state class
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).deliveryDetailsTitle),
      content: Container(
          width: double.maxFinite,
          height: 200,
          child:  PageView(
            children: [
              LocationDetail(address:widget.item.sellerAddress),
              LocationDetail(address:widget.item.buyerAddress)],
          )),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(S.of(context).agreeToMoveToCompletedText),
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value!;
                });
              },
            ),
          ],
        ),
        TextButton(
          child: Text(S.of(context).moveToCompletedButton),
          onPressed: _isChecked
              ? () async {
                  var inProgressProvider = Provider.of<OperationTracksProvider>(
                      context,
                      listen: false);

                  // Logic to transfer the item to 'Completed'
                  await inProgressProvider
                      .moveToComplete(widget.item.operationId);
                  Navigator.of(context).pop(); // Close the dialog
                }
              : null, // Button is disabled if _isChecked is false
        ),
      ],
    );
  }
}
