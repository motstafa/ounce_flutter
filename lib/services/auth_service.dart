import 'dart:convert';

import 'package:ounce/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  String baseUrl = Constants.apiUri;

  final storage = const FlutterSecureStorage();

  Future<UserModel> register({
   required String name,
   required String username,
   required String email,
   required String password,
  }) async {
    var url = '$baseUrl/register';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'name': name,
      'username': username,
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
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];

      return user;
    } else {
      throw Exception('Gagal Register');
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
      // UserModel user = UserModel.fromJson(data['user']);
      // user.token = 'Bearer ' + data['access_token'];
      UserModel user = UserModel();
      user.token=data['token'];

      // save in the shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', data['token']);
      prefs.setInt('role',data['role']);
      storeToken(data['token'],data['role']);
      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }


  // Store token
  Future<void> storeToken(String token,int role) async {
    await storage.write(key: 'sanctum_token', value: token);
    await storage.write(key: 'role', value: role.toString());
  }

}
