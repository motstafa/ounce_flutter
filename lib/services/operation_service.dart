import 'dart:convert';
import 'package:ounce/models/operation_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../main.dart';
import 'package:mime/mime.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

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

  Future Buy(int operationId, int itemsCount) async {
    var url = '$baseUrl/buy';
    final token =
        prefs.getString('auth_token'); // Retrieve token from shared preferences

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

  Future<bool> sell(unitPrice, String unitType, XFile? img, unitsNumber,retail) async {
    final token =
        prefs.getString('auth_token'); // Retrieve token from shared preferences
    var url = '$baseUrl/operation';
    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['unit_price'] = unitPrice
      ..fields['unit_type'] = unitType
      ..fields['number_of_units'] = unitsNumber
      ..fields['retail']=retail
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
    final token =
        prefs.getString('auth_token'); // Retrieve token from shared preferences

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
}
