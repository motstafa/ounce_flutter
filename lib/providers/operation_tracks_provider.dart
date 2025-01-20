import 'package:flutter/cupertino.dart';
import 'package:ounce/services/operation_tracks_service.dart';
import '../models/pending_operation_model.dart';
import 'dart:async';

class OperationTracksProvider with ChangeNotifier {
  List<PendingOperation> _pendingItems = [];

  List<PendingOperation> get pendingItems => _pendingItems;

  List<PendingOperation> _inProgressItems = [];

  List<PendingOperation> get inProgressItems => _inProgressItems;

  List<PendingOperation> _completedItems = [];

  List<PendingOperation> get completedItems => _completedItems;

  Future<void> fetchPendingOperations() async {
    // Your HTTP request logic to fetch pending items
    // Parse the JSON data into a list of PendingItem models
    _pendingItems = await OperationTracks().getPendingOperations();
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  Future<void> fetchInProgressOperations() async {
    // Your HTTP request logic to fetch pending items
    // Parse the JSON data into a list of PendingItem models
    _inProgressItems = await OperationTracks().getInProgressOperations();
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void startPollingPendingOperations() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      await fetchPendingOperations(); // Fetch new data every 10 seconds
    });
  }

  Future<void> fetchCompleteOperations() async {
    // Your HTTP request logic to fetch pending items
    // Parse the JSON data into a list of PendingItem models
    _completedItems = await OperationTracks().getCompleteOperations();
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  Future acceptOrder(
      operationId, estimatedTimeToSeller, estimatedTimeToBuyer) async {
    int? timeToSeller = int.tryParse(estimatedTimeToSeller);
    int? timeToBuyer = int.tryParse(estimatedTimeToBuyer);
    if (await OperationTracks()
        .deliveryAcceptOperation(operationId, timeToSeller, timeToBuyer)) {
      await fetchPendingOperations();
      await fetchInProgressOperations();
    }
  }

  Future moveToComplete(operationId) async {
    if (await OperationTracks().deliveryCompleteOperation(operationId)) {
      await fetchInProgressOperations();
      await fetchCompleteOperations();
    }
  }
}
