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

  Future <Operation?>  loadSelledOperations() async {
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response =
    await http.get(Uri.parse('$baseUrl/loadSelledOperation'), headers: headers);
    if (response.statusCode == 200) {
      print('hello it is me');
      if (response.body.isEmpty || response.body == "null") {
        return null; // Ensure returning null explicitly
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final operation = Operation.fromJson(data);
      operation.total = operation.numberOfUnits * operation.unitPrice;
      return operation;
    } else {
      throw Exception('Failed to load operations');
    }
  }

  Future Buy(int operationId, int itemsCount) async {
    var url = '$baseUrl/buy';
    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var body = jsonEncode({
      'operation_id': operationId,
      'amount': itemsCount,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print('$operationId $itemsCount $url $body');
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('operation buying failed');
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
