import 'dart:math';

class Operation {
  final int id;
  final int sellerId;
  final int zoneId;
  final String dateOfOperation;
  final int unitPrice;
  final String unitType;
  String? picOfUnits;
  final int retail;
  final int numberOfUnits;
  final int total;

  Operation({
    required this.id,
    required this.sellerId,
    required this.zoneId,
    required this.dateOfOperation,
    required this.unitPrice,
    required this.unitType,
    this.picOfUnits,
    required this.retail,
    required this.numberOfUnits,
    required this.total,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
      id: json['id'],
      sellerId: json['seller_id'],
      zoneId: json['zone_id'],
      dateOfOperation: json['date_of_operation'],
      unitPrice: json['unit_price'],
      unitType: json['unit_type'],
      picOfUnits: json['pic_of_units'],
      retail: json['retail'],
      numberOfUnits: json['number_of_units'],
      total: json['total'],
    );
  }


  static String generateBigFakeNumber(int id) {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Format the date and time as a string (you can adjust the format as per your requirement)
    String datePart = "${now.year}${now.month}${now.day}";
    String timePart = "${now.hour}${now.minute}${now.second}${now.millisecond}";

    // Combine the date, time, and given ID to create the fake ID
    String fakeID = "$datePart$timePart$id";

    return fakeID;
  }

}
