import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:ounce/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../main.dart';

class AuthService {
  String baseUrl = Constants.apiUri;

  final storage = const FlutterSecureStorage();


  Future<Map<String, dynamic>> register(
      String firstName,
      String lastName,
      String email,
      String password,
      XFile? profilePicture,
      String phoneNumber,
      XFile? storePicture,
      String prefecture,
      int zoneId,
      String cityTown,
      String ward,
      String streetAddress,
      String building,
      int floor,
      ) async {
    try {
      var url = '$baseUrl/user';
      var headers = {'Content-Type': 'multipart/form-data'};

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['first_name'] = firstName
        ..fields['last_name'] = lastName
        ..fields['email'] = email
        ..fields['password'] = password
        ..fields['phone_number'] = phoneNumber
        ..fields['zone_id'] = zoneId.toString() // Convert integer to string
        ..fields['prefecture'] = prefecture
        ..fields['city_town'] = cityTown
        ..fields['ward'] = ward
        ..fields['street_adress'] = streetAddress
        ..fields['building'] = building
        ..fields['floor'] = floor.toString(); // Convert integer to string
      // Add profile picture file
      if (profilePicture != null) {
        var imageBytes = await profilePicture.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'profile_picture',
          imageBytes,
          filename: profilePicture.name,
        ));
      }

      // Add store picture file
      if (storePicture != null) {
        var storeBytes = await storePicture.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'store_picture',
          storeBytes,
          filename: storePicture.name,
        ));
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Success: User registered successfully.');
        // Parse success response
        return {'success': true};
      } else {
        // Parse validation errors
        final responseBody = await response.stream.bytesToString();
        final decodedBody = jsonDecode(responseBody);

        return {
          'success': false,
          'errors': decodedBody['message'], // Return validation errors
        };
      }
    } catch (exception) {
      print('Exception: $exception');
      throw Exception(exception);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    var url = '$baseUrl/login';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];

      UserModel user = UserModel();
      user.token = data['token'];

      final prefs = await SharedPreferences.getInstance();

      // Ensure data is written successfully before moving forward
      await prefs.setString('auth_token', data['token']);
      await prefs.setInt('role', data['role']);

      storeToken(data['token'], data['role']);
      return user;
    } else {
      throw Exception('Invalid username or password');
    }
  }

  Future<bool> validateToken(String token) async {

    var url = '$baseUrl/checkTokenValidity';
    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({'token': token});

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyPassword(String password) async {

    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
    var url = '$baseUrl/verify-password';
    var headers = {'Content-Type': 'application/json'
    ,'Authorization': 'Bearer $token',};

    var body = jsonEncode({
      'password': password,
      });
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    if (response.statusCode == 200) {
      try {
        var decodedResponse = jsonDecode(response.body);
        bool? isVerified = decodedResponse['verified'] as bool?;
        return isVerified ?? false;
      } catch (e) {
        print('Error decoding response: $e');
        return false;
      }
    } else {
      print('Error: ${response.statusCode} - ${response.body}');
      return false;
    }
  }

  // Store token
  Future<void> storeToken(String token, int role) async {
    await storage.write(key: 'sanctum_token', value: token);
    await storage.write(key: 'role', value: role.toString());
  }

  Future<UserModel> getUser() async{

    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    final response =
    await http.get(Uri.parse('$baseUrl/userInfo'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      UserModel user = UserModel.fromJson(data);
      return user;
    } else {
      throw Exception('Failed to load operations');
    }
  }


  Future<bool> deleteUser() async {

    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
    var url = '$baseUrl/deleteUser';
    var headers = {'Content-Type': 'application/json'
      ,'Authorization': 'Bearer $token',};

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print("User deleted successfully");
      var decodedResponse=jsonDecode(response.body);
      bool? deleted= decodedResponse['status'] as bool?;
      print(deleted);
      return deleted ?? false;
    } else {
      print("Error: ${response.body}");
      return false;
    }
  }

}
