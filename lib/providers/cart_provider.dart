import 'package:flutter/cupertino.dart';
import 'package:ounce/models/cart_model.dart';
import 'package:ounce/models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> _carts = [];

  List<CartModel> get carts => _carts;

  set carts(List<CartModel> carts) {
    _carts = carts;
    notifyListeners();
  }


  addCart(ProductModel product) {
    if (productExist(product)) {
      int index = _carts.indexWhere((element) => element.product?.id == product.id);
      if (index != -1) {
        _carts[index].quantity = (_carts[index].quantity ?? 0) + 1; // Ensure quantity is not null
      }
    } else {
      _carts.add(
        CartModel(
          id: _carts.length,
          product: product,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }


  removeCart(int id) {
    _carts.removeAt(id);
    notifyListeners();
  }


  addQuantity(int id) {
    _carts[id].quantity=(_carts[id].quantity ?? 0) + 1;
    notifyListeners();
  }

  reduceQuantity(int id) {
    if (id >= 0 && id < _carts.length) {
      _carts[id].quantity = (_carts[id].quantity ?? 0) - 1; // Ensure quantity is not null
      if (_carts[id].quantity == 0) {
        _carts.removeAt(id);
      }
      notifyListeners();
    }
  }

  totalItems() {
    int total = 0;
    for (var item in _carts) {
      total += item.quantity!;
    }
    return total;
  }

  totalPrice() {
    double total = 0;
    for (var item in _carts) {
      total += (item.quantity ??0) * (item.product?.price ??0);
    }
    return total;
  }

  productExist(ProductModel product) {
    if (_carts.indexWhere((element) => element.product?.id == product.id) ==
        -1) {
      return false;
    } else {
      return true;
    }
  }
}
