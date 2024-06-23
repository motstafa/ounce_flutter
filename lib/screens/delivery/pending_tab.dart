import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ounce/models/pending_operation_model.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';

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
                subtitle: Text(Constants().getOperationStatusTranslation(context,item.operationStatus)),
                // Assuming 'streetAdress' is the subtitle
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return PendingDialog(item: item);
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

class PendingDialog extends StatefulWidget {
  final PendingOperation item;

  const PendingDialog({super.key, required this.item});

  @override
  _PendingDialogState createState() => _PendingDialogState();
}

class _PendingDialogState extends State<PendingDialog> {
  TextEditingController timeTobuyerController = TextEditingController();
  TextEditingController timeToSellerController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                children: <Widget>[
                  Flexible(
                    child: Text('${S.of(context).nameLabel}: ${widget.item.address.fullName}'),
                  ),
                  Flexible(
                    child: Text('${S.of(context).phone}: ${widget.item.address.phone}'),
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
                        Text('${S.of(context).prefecture}: ${widget.item.address.prefecture}'),
                  ),
                  Flexible(
                    child:
                        Text('${S.of(context).city}: ${widget.item.address.cityTown}'),
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
                      child: Text('${S.of(context).wardLabel}: ${widget.item.address.ward}'),
                    ),
                    Flexible(
                      child:
                          Text('${S.of(context).streetAddressLabel}: ${widget.item.address.streetAdress}'),
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
                      child: Text('${S.of(context).buildingLabel}: ${widget.item.address.building}'),
                    ),
                    Flexible(
                      child: Text('${S.of(context).floorLabel}: ${widget.item.address.floor}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Form(
            key: _formKey, // Make sure this is defined in your state class
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: timeToSellerController,
                        decoration: InputDecoration(
                          hintText: S.of(context).estimatedTimeToSellerHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).pleaseEnterEstimatedTimeToSeller;
                          }
                          return null; // The field is valid
                        },
                        // Add other properties and methods as needed
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Spacing between the input fields
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: timeTobuyerController,
                        decoration: InputDecoration(
                          hintText: S.of(context).estimatedTimeToBuyerHint,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).pleaseEnterEstimatedTimeToSeller;
                          }
                          return null; // The field is valid
                        },
                        // Add other properties and methods as needed
                      ),
                    ),
                  ],
                ),
                TextButton(
                  child: Text(S.of(context).moveToInProgressButton),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Check if form is valid
                      var pendingProvider =
                          Provider.of<OperationTracksProvider>(context,
                              listen: false);

                      await pendingProvider.acceptOrder(
                          widget.item.operationId,
                          timeToSellerController.text,
                          timeTobuyerController.text);
                      // Use a mounted check before calling Navigator.of(context).pop()
                      if (mounted) {
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ]);
  }
}
