import 'package:flutter/cupertino.dart';
import 'package:ounce/models/operation_model.dart';
import 'package:ounce/models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<Operation> _carts = [];

  List<Operation> get carts => _carts;

  set carts(List<Operation> carts) {
    _carts = carts;
    notifyListeners();
  }


  addCart(ProductModel product) {

  }


  removeCart(int id) {

  }


  addQuantity(int id) {

  }

  reduceQuantity(int id) {

  }

  totalItems() {

  }

  totalPrice() {

  }

  productExist(ProductModel product) {

  }
}
