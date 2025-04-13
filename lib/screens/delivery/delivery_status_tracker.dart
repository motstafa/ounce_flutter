import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../providers/operation_tracks_provider.dart';
import '../../theme/theme.dart';

class DeliveryStatusTracker extends StatelessWidget {
  final int operationId;
  final String initialStatus;

  const DeliveryStatusTracker({
    Key? key,
    required this.operationId,
    required this.initialStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OperationTracksProvider>(
      builder: (context, provider, child) {
        // Get current status from provider or use initial if not found
        final currentStatus = provider.getOperationById(operationId)?.operationStatus ?? initialStatus;

        return _DeliveryStatusTrackerContent(
          operationId: operationId,
          currentStatus: currentStatus,
        );
      },
    );
  }
}

class _DeliveryStatusTrackerContent extends StatefulWidget {
  final int operationId;
  final String currentStatus;

  const _DeliveryStatusTrackerContent({
    required this.operationId,
    required this.currentStatus,
  });

  @override
  __DeliveryStatusTrackerContentState createState() => __DeliveryStatusTrackerContentState();
}

class __DeliveryStatusTrackerContentState extends State<_DeliveryStatusTrackerContent> {
  final List<String> _statusSteps = [
    'accepted',
    'en_route_to_seller',
    'at_seller',
    'picked_up',
    'en_route_to_buyer',
    'delivered'
  ];

  final TextEditingController _timeController = TextEditingController();
  bool _showTimeField = false;
  String _nextStatusForTimeInput = '';

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'accepted': return S.of(context).statusAccepted;
      case 'en_route_to_seller': return S.of(context).statusEnRouteToSeller;
      case 'at_seller': return S.of(context).statusAtSeller;
      case 'picked_up': return S.of(context).statusPickedUp;
      case 'en_route_to_buyer': return S.of(context).statusEnRouteToBuyer;
      case 'delivered': return S.of(context).statusDelivered;
      default: return status;
    }
  }

  int _getCurrentStatusIndex() {
    return _statusSteps.indexOf(widget.currentStatus);
  }

  bool _isCurrentStatus(String status) {
    return widget.currentStatus == status;
  }

  bool _isCompletedStatus(String status) {
    int currentIndex = _getCurrentStatusIndex();
    int statusIndex = _statusSteps.indexOf(status);
    return statusIndex < currentIndex;
  }

  bool _isNextStatus(String status) {
    int currentIndex = _getCurrentStatusIndex();
    int statusIndex = _statusSteps.indexOf(status);
    return statusIndex == currentIndex + 1;
  }

  bool _requiresTimeInput(String currentStatus, String nextStatus) {
    return (currentStatus == 'accepted' && nextStatus == 'en_route_to_seller') ||
        (currentStatus == 'picked_up' && nextStatus == 'en_route_to_buyer');
  }

  String _getTimeInputLabel(String nextStatus) {
    if (nextStatus == 'en_route_to_seller') {
      return S.of(context).estimatedTimeToSeller;
    } else if (nextStatus == 'en_route_to_buyer') {
      return S.of(context).estimatedTimeToBuyer;
    }
    return '';
  }

  void _showTimeInputField(String nextStatus) {
    setState(() {
      _showTimeField = true;
      _nextStatusForTimeInput = nextStatus;
      _timeController.clear();
    });
  }

  Future<void> _updateStatus(String newStatus) async {
    if (_requiresTimeInput(widget.currentStatus, newStatus)) {
      _showTimeInputField(newStatus);
      return;
    }

    final provider = Provider.of<OperationTracksProvider>(context, listen: false);
    await provider.updateOperationStatus(widget.operationId, newStatus);
  }

  Future<void> _updateStatusWithTime() async {
    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).pleaseEnterTime))
      );
      return;
    }

    int estimatedTime = int.tryParse(_timeController.text) ?? 0;
    if (estimatedTime <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).invalidTimeValue))
      );
      return;
    }

    final provider = Provider.of<OperationTracksProvider>(context, listen: false);

    if (_nextStatusForTimeInput == 'en_route_to_seller') {
      await provider.updateOperationStatusWithTimeToSeller(
          widget.operationId,
          _nextStatusForTimeInput,
          estimatedTime
      );
    } else if (_nextStatusForTimeInput == 'en_route_to_buyer') {
      await provider.updateOperationStatusWithTimeToBuyer(
          widget.operationId,
          _nextStatusForTimeInput,
          estimatedTime
      );
    }

    setState(() {
      _showTimeField = false;
      _nextStatusForTimeInput = '';
    });
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
        if (_showTimeField)
          _buildTimeInputField(),
      ],
    );
  }

  Widget _buildTimeInputField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _getTimeInputLabel(_nextStatusForTimeInput),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _timeController,
            decoration: InputDecoration(
              hintText: S.of(context).enterTimeInMinutes,
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _showTimeField = false;
                    _nextStatusForTimeInput = '';
                  });
                },
                child: Text(S.of(context).cancel),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: _updateStatusWithTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GoldInBetween,
                ),
                child: Text(S.of(context).confirm),
              ),
            ],
          ),
        ],
      ),
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
          if (isNext && !_showTimeField)
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