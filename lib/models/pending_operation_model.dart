import 'address_model.dart';

class PendingOperation {
  final int id;
  final int operationId;
  final int numberOfUnits;
  final int amount;
  final int zoneId;
  final String operationStatus;
  final Address buyerAddress;
  final Address sellerAddress;

  PendingOperation({
    required this.id,
    required this.operationId,
    required this.numberOfUnits,
    required this.amount,
    required this.zoneId,
    required this.operationStatus,
    required this.buyerAddress,
    required this.sellerAddress,
  });

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'],
      operationId: json['operation_id'],
      numberOfUnits: json['number_of_units'],
      amount: json['amount'],
      zoneId: json['zone_id'],
      operationStatus: json['operation_status'],
      buyerAddress:  Address(
        country: json['buyer_country'],
        fullName: json['buyer_name'],
        phone: json['buyer_phone_number'],
        storePicture: json['buyer_store_picture'],
        prefecture: json['buyer_prefecture'],
        cityTown: json['buyer_city_town'],
        ward: json['buyer_ward'],
        streetAdress: json['buyer_street_adress'],
        building: json['buyer_building'],
        floor: json['buyer_floor'],
      ),
      sellerAddress: Address(
        country: json['seller_country'],
        fullName: json['seller_name'],
        phone: json['seller_phone_number'],
        storePicture: json['seller_store_picture'],
        prefecture: json['seller_prefecture'],
        cityTown: json['seller_city_town'],
        ward: json['seller_ward'],
        streetAdress: json['seller_street_adress'],
        building: json['seller_building'],
        floor: json['seller_floor'],
      )
    );
  }



}
