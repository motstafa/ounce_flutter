import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../models/pending_operation_model.dart';
import '../../providers/operation_tracks_provider.dart';
import '../../theme/theme.dart';

class DeliveryStatusTracker extends StatefulWidget {
  final PendingOperation operation;

  const DeliveryStatusTracker({Key? key, required this.operation}) : super(key: key);

  @override
  _DeliveryStatusTrackerState createState() => _DeliveryStatusTrackerState();
}

class _DeliveryStatusTrackerState extends State<DeliveryStatusTracker> {
  // Define all possible statuses in order
  final List<String> _statusSteps = [
    'accepted',
    'en_route_to_seller',
    'at_seller',
    'picked_up',
    'en_route_to_buyer',
    'delivered'
  ];

  // Translate status codes to display text
  String _getStatusText(String status) {
    switch (status) {
      case 'accepted':
        return S.of(context).statusAccepted;
      case 'en_route_to_seller':
        return S.of(context).statusEnRouteToSeller;
      case 'at_seller':
        return S.of(context).statusAtSeller;
      case 'picked_up':
        return S.of(context).statusPickedUp;
      case 'en_route_to_buyer':
        return S.of(context).statusEnRouteToBuyer;
      case 'delivered':
        return S.of(context).statusDelivered;
      default:
        return status;
    }
  }

  // Get the current status index
  int _getCurrentStatusIndex() {
    return _statusSteps.indexOf(widget.operation.operationStatus);
  }

  // Check if a particular status is active
  bool _isCurrentStatus(String status) {
    return widget.operation.operationStatus == status;
  }

  // Check if a status is complete
  bool _isCompletedStatus(String status) {
    int currentIndex = _getCurrentStatusIndex();
    int statusIndex = _statusSteps.indexOf(status);
    return statusIndex < currentIndex;
  }

  // Check if a status is next
  bool _isNextStatus(String status) {
    int currentIndex = _getCurrentStatusIndex();
    int statusIndex = _statusSteps.indexOf(status);
    return statusIndex == currentIndex + 1;
  }

  // Update operation status
  void _updateStatus(String newStatus) async {
    final provider = Provider.of<OperationTracksProvider>(context, listen: false);
    await provider.updateOperationStatus(widget.operation.operationId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            S.of(context).deliveryStatusTitle,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        for (String status in _statusSteps)
          _buildStatusStep(status),
      ],
    );
  }

  Widget _buildStatusStep(String status) {
    bool isCompleted = _isCompletedStatus(status);
    bool isCurrent = _isCurrentStatus(status);
    bool isNext = _isNextStatus(status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? Colors.green
                  : (isCurrent ? GoldInBetween : Colors.grey.withOpacity(0.5)),
              border: Border.all(
                color: isCurrent ? GoldInBetween : Colors.transparent,
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),

          // Status text
          Expanded(
            child: Text(
              _getStatusText(status),
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                color: isCompleted
                    ? Colors.green
                    : (isCurrent ? GoldInBetween : Colors.white.withOpacity(0.7)),
              ),
            ),
          ),

          // Action button for next step
          if (isNext)
            ElevatedButton(
              onPressed: () => _updateStatus(status),
              style: ElevatedButton.styleFrom(
                backgroundColor: GoldInBetween,
              ),
              child: Text(S.of(context).updateStatusBtn),
            ),
        ],
      ),
    );
  }
}