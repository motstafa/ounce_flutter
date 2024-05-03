import 'dart:html';
import 'dart:math';
import 'package:ounce/services/operation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:ounce/models/operation_model.dart';


class OperationProvider with ChangeNotifier {

  final OperationService operationservice= OperationService();
  List <Operation> _operations = [];

  List <Operation> get operations => _operations;

  set operations(List <Operation> operations){
    _operations=operations;
    notifyListeners();
  }

  setOperations(Operation operation){
    if(!isOperationlist(operation)){
      _operations.add(operation);
    }
    else{
      _operations.removeWhere((element) => element.id==operation.id);
    }
    notifyListeners();
  }

  isOperationlist(Operation operation){
    if(_operations.indexWhere((element) => element.id==operation.id)== -1){
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
}