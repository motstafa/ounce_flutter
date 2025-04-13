import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import '../main.dart';
import '../models/pending_operation_model.dart';

class OperationTracks {
  String baseUrl = Constants.apiUri;

  Future<List<PendingOperation>> getPendingOperations() async {
    String? token = await Constants()
        .getTokenFromSecureStorage(); // Retrieve token from shared preferences

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
    String? token = await Constants()
        .getTokenFromSecureStorage(); // Retrieve token from shared preferences

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
    String? token = await Constants()
        .getTokenFromSecureStorage(); // Retrieve token from shared preferences

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

  Future<bool> deliveryAcceptOperation(int operationId) async {
    try {
      var url = '$baseUrl/delivery/accept';
      String? token = await Constants().getTokenFromSecureStorage();

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
        print('success ${operationId}');
        return true;
      } else {
        print(token);
        print(response.statusCode);
        return false;
      }
    } catch (e) {
      throw Exception('operation acceptance failed: $e');
    }
  }

  Future deliveryCompleteOperation(operationId) async {
    try {
      var url = '$baseUrl/delivery/finish';
      String? token = await Constants()
          .getTokenFromSecureStorage(); // Retrieve token from shared preferences

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

  Future<bool> updateOperationStatus(int operationId, String newStatus) async {
    try {
      String? token =
          await Constants().getTokenFromSecureStorage(); // Secure token
      final response = await http.post(
        Uri.parse('$baseUrl/operations/update-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'operation_id': operationId,
          'status': newStatus,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in updateOperationStatus: $e');
      return false;
    }
  }

  // Add these methods to your OperationTracks service class

  Future<bool> updateOperationStatusWithTimeToSeller(
      int operationId, String newStatus, int estimatedTime) async {
    try {
      String? token =
          await Constants().getTokenFromSecureStorage(); // Secure token
      final response = await http.post(
        Uri.parse('$baseUrl/operations/update-status-with-time'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'operation_id': operationId,
          'status': newStatus,
          'estimated_time_to_seller': estimatedTime,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update status with time to seller: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in updateOperationStatusWithTimeToSeller: $e');
      return false;
    }
  }

  Future<bool> updateOperationStatusWithTimeToBuyer(
      int operationId, String newStatus, int estimatedTime) async {
    try {
      String? token =
          await Constants().getTokenFromSecureStorage(); // Secure token
      final response = await http.post(
        Uri.parse('$baseUrl/operations/update-status-with-time'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'operation_id': operationId,
          'status': newStatus,
          'estimated_time_to_buyer': estimatedTime,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            'Failed to update status with time to buyer: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in updateOperationStatusWithTimeToBuyer: $e');
      return false;
    }
  }
}
