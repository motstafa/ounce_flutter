import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ounce/main.dart';

class Constants {
  //android emulator http://10.0.2.2:8000/api
  //web http://127.0.0.1:8000/api
  static const String apiUri = 'http://10.0.2.2:8000/api';
  static const userRoles = <String, dynamic>{'trader': 1, 'delivery': 2};
  final storage = const FlutterSecureStorage();

  int CalculatePrice(int itemNumber, int itemPrice) {
    var commission = prefs.getInt('commissions');
    return itemPrice * itemNumber + commission! * itemNumber;
  }

  Future<int?> getRoleFromSecureStorage() async {
    String? value = await storage.read(key: 'role');
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> getTokenFromSecureStorage() async {
    String? value= await storage.read(key: 'sanctum_token');
    return value;
  }
}
