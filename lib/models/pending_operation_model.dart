import 'address_model.dart';

class PendingOperation {
  final int id;
  final int operationId;
  final int zoneId;
  final String operationStatus;
  final Address address;

  PendingOperation({
    required this.id,
    required this.operationId,
    required this.zoneId,
    required this.operationStatus,
    required this.address,
  });

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'],
      operationId: json['operation_id'],
      zoneId: json['zone_id'],
      operationStatus: json['operation_status'],
      address:  Address(
        country: json['country'],
        fullName: json['full_name'],
        phone: json['phone_number'],
        storePicture: json['store_picture'],
        prefecture: json['prefecture'],
        cityTown: json['city_town'],
        ward: json['ward'],
        streetAdress: json['street_adress'],
        building: json['building'],
        floor: json['floor'],
      ),
    );
  }



}
