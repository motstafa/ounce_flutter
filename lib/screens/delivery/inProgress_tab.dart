import 'package:flutter/material.dart';
import 'package:ounce/screens/delivery/operation_details.dart';
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
                      return OperationDetails(item: item,formSection:  CompletionSection(item: item,));
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

class CompletionSection extends StatefulWidget {
  final PendingOperation item;

  const CompletionSection({Key? key, required this.item}) : super(key: key);

  @override
  State<CompletionSection> createState() => _CompletionSectionState();
}

class _CompletionSectionState extends State<CompletionSection> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return 
      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: 
      Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(S.of(context).agreeToMoveToCompletedText),
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isChecked
              ? () async {
            var inProgressProvider =
            Provider.of<OperationTracksProvider>(context, listen: false);

            // Logic to transfer the item to 'Completed'
            await inProgressProvider.moveToComplete(widget.item.operationId);

            if (mounted) {
              Navigator.of(context).pop(); // Close the dialog
            }
          }
              : null, // Button is disabled if _isChecked is false
          child: Text(S.of(context).moveToCompletedButton),
        ),
      ],
    ));
  }
}

