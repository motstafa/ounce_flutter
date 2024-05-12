import 'package:flutter/cupertino.dart';
import 'package:ounce/models/product_model.dart';
import 'package:ounce/services/operation_tracks_service.dart';
import 'package:ounce/services/product_service.dart';
import '../models/pending_operation_model.dart';

class OperationTracksProvider with ChangeNotifier {

  List<PendingOperation> _pendingItems = [];

  List<PendingOperation> get pendingItems => _pendingItems;

  Future<void> fetchPendingOperations() async {
    // Your HTTP request logic to fetch pending items
    // Parse the JSON data into a list of PendingItem models
    _pendingItems = await OperationTracks().getPendingOperations();
    notifyListeners(); // Notify listeners to rebuild the UI
  }

}
