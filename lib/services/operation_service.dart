import 'dart:convert';
import 'package:ounce/models/operation_model.dart';
import 'package:ounce/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ounce/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class OperationService {
  String baseUrl = Constants.apiUri;

  Future<List<Operation>> getOperations() async {
    final token =
    prefs.getString('auth_token'); // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response =
    await http.get(Uri.parse('$baseUrl/operation'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Operation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load operations');
    }
  }
}
