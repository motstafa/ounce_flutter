import 'package:flutter/cupertino.dart';
import 'package:ounce/services/operation_tracks_service.dart';
import '../models/pending_operation_model.dart';
import 'dart:async';

class OperationTracksProvider with ChangeNotifier {
  List<PendingOperation> _pendingItems = [];
  List<PendingOperation> _inProgressItems = [];
  List<PendingOperation> _completedItems = [];
  final Map<int, PendingOperation> _operationsMap = {};

  // Getters
  List<PendingOperation> get pendingItems => _pendingItems;
  List<PendingOperation> get inProgressItems => _inProgressItems;
  List<PendingOperation> get completedItems => _completedItems;

  // Initialize the operations map when fetching data
  Future<void> _updateOperationsMap(List<PendingOperation> operations) async {
    for (var operation in operations) {
      _operationsMap[operation.operationId] = operation;
    }
    notifyListeners();
  }

  Future<void> fetchPendingOperations() async {
    _pendingItems = await OperationTracks().getPendingOperations();
    await _updateOperationsMap(_pendingItems);
  }

  Future<void> fetchInProgressOperations() async {
    _inProgressItems = await OperationTracks().getInProgressOperations();
    await _updateOperationsMap(_inProgressItems);
  }

  Future<void> fetchCompleteOperations() async {
    _completedItems = await OperationTracks().getCompleteOperations();
    await _updateOperationsMap(_completedItems);
  }

  PendingOperation? getOperationById(int operationId) {
    return _operationsMap[operationId];
  }

  Future<bool> updateOperationStatus(int operationId, String newStatus) async {
    bool success = await OperationTracks().updateOperationStatus(operationId, newStatus);

    if (success) {
      // Update the operation in the map
      if (_operationsMap.containsKey(operationId)) {
        _operationsMap[operationId] = _operationsMap[operationId]!.copyWith(
            operationStatus: newStatus
        );

        // Refresh the appropriate lists
        if (newStatus == 'delivered') {
          await fetchCompleteOperations();
          await fetchInProgressOperations();
        } else {
          await fetchInProgressOperations();
        }
      }
    }

    return success;
  }

  // Your other methods...
  Future acceptOrder(operationId, estimatedTimeToSeller, estimatedTimeToBuyer) async {
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