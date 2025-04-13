import 'package:flutter/material.dart';
import 'package:ounce/models/pending_operation_model.dart';
import 'package:ounce/screens/delivery/delivery_status_tracker.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../providers/operation_tracks_provider.dart';
import '../../widgets/location_detail.dart';


class OperationDetails extends StatefulWidget {
  final PendingOperation item;
  final Widget formSection;

  const OperationDetails(
      {super.key, required this.item, required this.formSection});

  @override
  _OperationDetailsState createState() => _OperationDetailsState();
}

class _OperationDetailsState extends State<OperationDetails> {
  TextEditingController timeTobuyerController = TextEditingController();
  TextEditingController timeToSellerController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    timeToSellerController.dispose();
    timeTobuyerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationTracksProvider>(
      builder: (context, provider, child) {
        // Get the latest operation data from provider or use the initial item
        final currentOperation = provider.getOperationById(widget.item.operationId) ?? widget.item;

        return Scaffold(
          backgroundColor: Colors.black, // This makes the entire scaffold background black
          appBar: AppBar(
            title: Text(S.of(context).deliveryDetailsTitle),
            backgroundColor: Colors.black,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SectionHeader(
                  numberOfUnits: currentOperation.numberOfUnits,
                  sellerAmount: currentOperation.sellerAmount,
                  buyerAmount: currentOperation.buyerAmount,
                  operationStatus: currentOperation.operationStatus,
                ),

                // Delivery status tracker (show only for in-progress operations)
                if (_isInProgress(currentOperation.operationStatus))
                  DeliveryStatusTracker(
                    operationId: currentOperation.operationId,
                    initialStatus: currentOperation.operationStatus,
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 300,
                    child: PageView(
                      children: [
                        LocationDetail(
                          Location: 'seller',
                          address: currentOperation.sellerAddress,
                        ),
                        LocationDetail(
                          Location: 'buyer',
                          address: currentOperation.buyerAddress,
                        ),
                      ],
                    ),
                  ),
                ),
                if(currentOperation.operationStatus=='delivered')
                widget.formSection,
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isInProgress(String status) {
    List<String> inProgressStatuses = [
      'accepted',
      'en_route_to_seller',
      'at_seller',
      'picked_up',
      'en_route_to_buyer'
    ];
    return inProgressStatuses.contains(status);
  }

  // Helper method to check if an operation is in progress
  bool isInProgress(String status) {
    List<String> inProgressStatuses = [
      'accepted',
      'en_route_to_seller',
      'at_seller',
      'picked_up',
      'en_route_to_buyer'
    ];

    return inProgressStatuses.contains(status);
  }
}

class SectionHeader extends StatelessWidget {
  final int numberOfUnits;
  final int sellerAmount;
  final int buyerAmount;
  final String operationStatus;

  const SectionHeader({
    Key? key,
    required this.numberOfUnits,
    required this.sellerAmount,
    required this.buyerAmount,
    required this.operationStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine which amount to show based on operation status
    final bool showSellerAmount = _shouldShowSellerAmount(operationStatus);
    final int amountToShow = showSellerAmount ? sellerAmount : buyerAmount;
    final String amountLabel = showSellerAmount
        ? S.of(context).sellerAmount
        : S.of(context).buyerAmount;

    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: "${S.of(context).numberOfUnitsLabel} ",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "$numberOfUnits",
                style: TextStyle(
                    color: Colors.red, fontSize: 45),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: "$amountLabel ",
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "\$$amountToShow",
                style: TextStyle(
                    color: Colors.green, fontSize: 45),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to determine if we should show seller amount or buyer amount
  bool _shouldShowSellerAmount(String status) {
    List<String> sellerAmountStatuses = [
      'pending',
      'accepted',
      'en_route_to_seller',
      'at_seller',
      'picked_up',
    ];

    return sellerAmountStatuses.contains(status);
  }
}