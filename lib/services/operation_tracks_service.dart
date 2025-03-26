import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import '../main.dart';
import '../models/pending_operation_model.dart';

class OperationTracks {
  String baseUrl = Constants.apiUri;

  Future<List<PendingOperation>> getPendingOperations() async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences


    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response = await http.get(Uri.parse('$baseUrl/pendingOperations'),
        headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<PendingOperation>(
              (json) => PendingOperation.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load operations');
    }
  }

  Future<List<PendingOperation>> getInProgressOperations() async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences


    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response = await http.get(Uri.parse('$baseUrl/inProgressOperations'),
        headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data
          .map<PendingOperation>(
              (json) => PendingOperation.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load operations');
    }
  }

  Future<List<PendingOperation>> getCompleteOperations() async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences


    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response = await http.get(Uri.parse('$baseUrl/completedOperations'),
        headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var length = data.length;
      return data
          .map<PendingOperation>(
              (json) => PendingOperation.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load operations');
    }
  }

  Future deliveryAcceptOperation(
      operationId, estimatedTimeToSeller, estimatedTimeToBuyer) async {
    try {
      var url = '$baseUrl/delivery/accept';
      String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences


      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'operation_id': operationId,
        'estimated_time_to_seller': estimatedTimeToSeller,
        'estimated_time_to_buyer': estimatedTimeToBuyer
      });

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('sucess ${operationId}');
        return true;
      } else {
        print(token);
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      throw Exception('operation buying failed: $e');
    }
  }


  Future deliveryCompleteOperation(operationId) async {
    try {
      var url = '$baseUrl/delivery/finish';
      String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences


      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'operation_id': operationId,
      });

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print('sucess ${operationId}');
        return true;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw Exception('operation buying failed: $e');
    }
  }
}
