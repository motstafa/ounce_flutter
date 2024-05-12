import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/services/operation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:ounce/models/operation_model.dart';

class OperationProvider with ChangeNotifier {
  final OperationService operationservice = OperationService();
  List<Operation> _operations = [];

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
      print('Error fetching operations: $e');
      return false;
    }
  }

  Future<bool> Buy(int id, int selectedItems) async {
    try {
      if (await operationservice.Buy(id, selectedItems)) {
          return true;
      }
    } catch (e) {
      print('Error fetching operations: $e');
    }
    return false;
  }


  Future<bool> sell(double unitPrice, String unitType,XFile img, int unitsNumber) async {
    try {
      print('before service');
      bool result = await operationservice.sell(unitPrice, unitType, img, unitsNumber);
      print('after service');
      return result;
    } catch (e) {
      print('Error fetching operations: ${e.toString()}');
      // Consider logging the stack trace for more detailed debugging information
    }
    return false;
  }

}
