import 'dart:math';

class Address {
  final String country;
  final String fullName;
  final String phone;
  final String? storePicture;
  final String prefecture;
  final String cityTown;
  final String ward;
  final String streetAdress;
  final String building;
  final int floor;

  Address({
    required this.country,
    required this.fullName,
    required this.phone,
    required this.storePicture,
    required this.prefecture,
    required this.cityTown,
    required this.ward,
    required this.streetAdress,
    required this.building,
    required this.floor,
  });

factory Address.fromJson(Map<String, dynamic> json) {
      return Address(
      country: json['id'],
      fullName: json['full_name'],
      phone: json['phone_number'],
      storePicture: json['store_picture'],
      prefecture: json['prefecture'],
      cityTown: json['city_town'],
      ward: json['ward'],
      streetAdress: json['street_adress'],
      building: json['building'],
      floor: json['floor']
      );
}



}
