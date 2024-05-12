import 'dart:convert';
import 'package:ounce/models/operation_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import '../main.dart';
import '../models/pending_operation_model.dart';

class OperationTracks {
  String baseUrl = Constants.apiUri;

  Future<List<PendingOperation>> getPendingOperations() async {
    final token =
    prefs.getString('auth_token'); // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response =
    await http.get(Uri.parse('$baseUrl/pendingOperations'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var lenght= data.length;
      print('operation service $lenght');
      return data.map<PendingOperation>((json) => PendingOperation.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load operations');
    }
  }

}
