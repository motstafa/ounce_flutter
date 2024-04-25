import 'package:ounce/models/product_model.dart';

class CartModel {
  int? id;
  ProductModel? product;
  int? quantity;

  CartModel({
    this.id,
    this.product,
    this.quantity,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
    quantity = json['quantity'];
  }

  Map<String, dynamic> json() {
    return {
      'id': id,
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  getTotalPrice() {
    if (product != null && quantity != null) {
      return (product!.price ?? 0) * (quantity ?? 0); // Use null-aware operator
    } else {
      return 0; // Or handle the case when product or quantity is null
    }
  }
}
