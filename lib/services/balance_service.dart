import 'dart:convert';

import 'package:ounce/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AuthService {
  String baseUrl = Constants.apiUri;

  Future<Map<String, int>> getTraderBalance() async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };
    final response =
        await http.get(Uri.parse('$baseUrl/userBalance'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // add commissions to shared preferences
      await prefs.setInt('commissions', data['commissions']);

      Map<String, int> balance = {};

      balance['sell_balance'] = data['sell_balance'];
      balance['buy_balance'] = data['buy_balance'];
      return balance;
    } else {
      return {};
    }
  }
}
