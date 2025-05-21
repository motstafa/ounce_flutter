import 'dart:convert';
import 'package:ounce/models/operation_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import '../main.dart';
import 'package:image_picker/image_picker.dart';

class OperationService {
  String baseUrl = Constants.apiUri;

  Future<List<Operation>> getOperations() async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences

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

  // In operation_service.dart
  Future<List<Operation>> loadSelledOperations() async {
    String? token = await Constants().getTokenFromSecureStorage();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(Uri.parse('$baseUrl/loadSelledOperation'), headers: headers);

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == "null") {
        return [];
      }

      final List<dynamic> data = jsonDecode(response.body);

      // Convert each item in the array to an Operation object
      List<Operation> operations = data.map((item) {
        final operation = Operation.fromJson(item);
        // Calculate total if not provided
        if (operation.total == null) {
          operation.total = operation.numberOfUnits * operation.unitPrice;
        }
        return operation;
      }).toList();
      return operations;
    } else {
      throw Exception('Failed to load operations');
    }
  }

  Future<Map<String, dynamic>> Buy(int id, int selectedItems) async {
    try {
      var url = '$baseUrl/buy';
      String? token = await Constants().getTokenFromSecureStorage();

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var body = jsonEncode({
        'operation_id': id,
        'amount': selectedItems,
      });

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Operation successful'};
      } else {
        // Parse the error response
        Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorCode = errorData['error_code'] ?? 'UNKNOWN_ERROR';

        // Return structured error information
        return {
          'success': false,
          'error_code': errorCode,
          'message': errorData['message'] ?? 'An error occurred',
          'data': errorData
        };
      }
    } catch (e) {
      return {'success': false, 'error_code': 'NETWORK_ERROR', 'message': e.toString()};
    }
  }

  Future<bool> sell(unitPrice, XFile? img, unitsNumber,expiresIn,retail) async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
    var url = '$baseUrl/operation';
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['unit_price'] = unitPrice
      // ..fields['unit_type'] = unitType
      ..fields['number_of_units'] = unitsNumber
      ..fields['retail']=retail
      ..fields['expiry']=expiresIn
      ..headers['Authorization'] = 'Bearer $token';

    // Add the image file to the request
    if (img != null) {
      var imageBytes = await img.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes(
        'pic_of_units', // The field name expected by your Laravel API
        imageBytes,
        filename: img.name, // To get only the file name
      ));
    }
    // Add the file to the request
    // Send the request
    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      // Read the response body to get more details about the error
      var responseBody = await response.stream.bytesToString();
      throw Exception('Operation selling failed: $responseBody');
    }
  }

  Future<bool> checkDeliveries(int operationId) async {
    var url = '$baseUrl/checkDeliveries';
    String? token = await Constants().getTokenFromSecureStorage();// Retrieve token from shared preferences

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode({'operation_id': operationId});

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data =jsonDecode(response.body);
      return data['available'];
    } else {
      throw Exception('operation buying failed');
    }
  }

  Future<bool> deleteOperation(int operationId) async {
    try {
     String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
     print('$baseUrl/operation/$operationId');
     print(token);
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var url = '$baseUrl/operation/$operationId';

      var response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete operation');
      }
    } catch (e) {
      throw Exception('Error deleting operation: $e');
    }
  }
}
