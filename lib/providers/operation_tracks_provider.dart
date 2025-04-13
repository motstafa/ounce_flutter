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
    final operations = await OperationTracks().getPendingOperations();

    // Use a Set to track IDs we've already processed
    final Set<int> processedIds = {};
    _pendingItems = [];

    for (var operation in operations) {
      // Only add if we haven't seen this ID before
      if (!processedIds.contains(operation.operationId)) {
        _pendingItems.add(operation);
        processedIds.add(operation.operationId);
      }
    }

    await _updateOperationsMap(_pendingItems);
    notifyListeners();
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



  // Add these methods to your OperationTracksProvider class

  Future<bool> updateOperationStatusWithTimeToSeller(int operationId, String newStatus, int estimatedTime) async {
    bool success = await OperationTracks().updateOperationStatusWithTimeToSeller(operationId, newStatus, estimatedTime);

    if (success) {
      // Update the operation in the map
      if (_operationsMap.containsKey(operationId)) {
        _operationsMap[operationId] = _operationsMap[operationId]!.copyWith(
            operationStatus: newStatus
        );
        // Refresh the appropriate lists
        await fetchInProgressOperations();
      }
    }

    return success;
  }

  Future<bool> updateOperationStatusWithTimeToBuyer(int operationId, String newStatus, int estimatedTime) async {
    bool success = await OperationTracks().updateOperationStatusWithTimeToBuyer(operationId, newStatus, estimatedTime);

    if (success) {
      // Update the operation in the map
      if (_operationsMap.containsKey(operationId)) {
        _operationsMap[operationId] = _operationsMap[operationId]!.copyWith(
            operationStatus: newStatus
        );
        // Refresh the appropriate lists
        await fetchInProgressOperations();
      }
    }

    return success;
  }


// Updated acceptOrder method
  Future<bool> acceptOrder(int operationId) async {
    if (await OperationTracks().deliveryAcceptOperation(operationId)) {
      await fetchPendingOperations();
      await fetchInProgressOperations();
      return true;
    }
    return false;
  }

  Future moveToComplete(operationId) async {
    if (await OperationTracks().deliveryCompleteOperation(operationId)) {
      await fetchInProgressOperations();
      await fetchCompleteOperations();
    }
  }
}