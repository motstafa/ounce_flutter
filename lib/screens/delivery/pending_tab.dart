import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ounce/models/pending_operation_model.dart';
import 'package:ounce/screens/delivery/operation_details.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import '../../constants/constants.dart';
import '../../generated/l10n.dart';
import '../../widgets/location_detail.dart';

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
      Provider.of<OperationTracksProvider>(context, listen: false)
          .startPollingPendingOperations();
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
                subtitle: Text(Constants().getOperationStatusTranslation(
                    context, item.operationStatus)),
                // Assuming 'streetAdress' is the subtitle
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return OperationDetails(item: item,formSection: FormSection(item: item),);
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



class FormSection extends StatefulWidget {
  final PendingOperation item;

  const FormSection({Key? key, required this.item}) : super(key: key);

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController timeToSellerController = TextEditingController();
  final TextEditingController timeToBuyerController = TextEditingController();

  @override
  void dispose() {
    timeToSellerController.dispose();
    timeToBuyerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: timeToSellerController,
            decoration: InputDecoration(
              hintText: S
                  .of(context)
                  .estimatedTimeToSellerHint,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S
                    .of(context)
                    .pleaseEnterEstimatedTimeToSeller;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: timeToBuyerController,
            decoration: InputDecoration(
              hintText: S
                  .of(context)
                  .estimatedTimeToBuyerHint,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S
                    .of(context)
                    .pleaseEnterEstimatedTimeToSeller;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                var pendingProvider = Provider.of<OperationTracksProvider>(
                    context,
                    listen: false);

                await pendingProvider.acceptOrder(
                  widget.item.operationId,
                  timeToSellerController.text,
                  timeToBuyerController.text,
                );

                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(S
                .of(context)
                .moveToInProgressButton),
          ),
        ],
      ),
    );
  }
}
