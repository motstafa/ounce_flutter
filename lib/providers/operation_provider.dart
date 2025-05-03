import 'dart:async';
import 'package:ounce/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/main.dart';
import 'package:ounce/services/operation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:ounce/models/operation_model.dart';

class OperationProvider with ChangeNotifier {
  final OperationService operationservice = OperationService();
  List<Operation> _operations = [];
  Operation? sellerOperation;

  List<Operation> get operations => _operations;

  set operations(List<Operation> operations) {
    _operations = operations;
    notifyListeners();
  }

  setOperations(Operation operation) {
    if (!isOperationlist(operation)) {
      _operations.add(operation);
    } else {
      _operations.removeWhere((element) => element.id == operation.id);
    }
    notifyListeners();
  }

  isOperationlist(Operation operation) {
    if (_operations.indexWhere((element) => element.id == operation.id) == -1) {
      return false;
    }
    return true;
  }

  Future<void> loadSellerOperations() async {
    try {
      var response = await operationservice.loadSelledOperations();
      if (response != null) {
        sellerOperation = response;
      } else {
        sellerOperation = null;
      }
      notifyListeners();
    } catch (e) {
      // print('Error fetching operations: $e');
    }
  }

  Future<void> loadOperations() async {
    try {
      _operations = await operationservice.getOperations();
      // Now you have the list of operations in the 'operations' variable
      // You can use this list to populate your BuyPage widget
      print('Number of operations: ${operations.length}');
      // notifyListeners();
    } catch (e) {
      print('Error fetching operations: $e');
    }
  }

  Future<bool> refreshPage() async {
    try {
      _operations = await operationservice.getOperations();
      // Now you have the list of operations in the 'operations' variable
      // You can use this list to populate your BuyPage widget
      print('Number of operations: ${operations.length}');
      notifyListeners();
      return true;
    } catch (e) {
      // print('Error fetching operations: $e');
      return false;
    }
  }

  void startPollingUpdatedOperations() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      await refreshPage(); // Fetch new data every 10 seconds
    });
  }

  Future<Map<String, dynamic>> Buy(int id, int selectedItems) async {
    try {
      var result = await operationservice.Buy(id, selectedItems);
      // Now handling the Map<String, dynamic> response from the service
      return result;
    } catch (e) {
      return {
        'success': false,
        'error_code': 'PROVIDER_ERROR',
        'message': e.toString()
      };
    }
  }

  Future<bool> checkDeliveries(int id) async {
    try {
      if (await operationservice.checkDeliveries(id)) {
        return true;
      }
    } catch (e) {
      // print('Error fetching operations: $e');
    }
    return false;
  }

  Future<bool> sell(unitPrice, XFile? img, unitsNumber,
      expiresIn, retail) async {
    try {
      bool result = await operationservice.sell(
          unitPrice, img, unitsNumber, expiresIn, retail.toString());
      print('after service');
      return result;
    } catch (e) {
      // print('Error fetching operations: ${e.toString()}');
      // Consider logging the stack trace for more detailed debugging information
    }
    return false;
  }
}
