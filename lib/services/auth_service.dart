import 'dart:convert';

import 'package:ounce/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class AuthService {
  String baseUrl = Constants.apiUri;

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
      if(data['role']==Constants.userRoles['trader']){
          getTraderBalance();
      }
      return user;
    } else {
      throw Exception('Gagal Login');
    }
  }


  Future getTraderBalance() async {
    final token =
    prefs.getString('auth_token'); // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };
    print('inside getTraderBalance function $token');
    final response =
    await http.get(Uri.parse('$baseUrl/userBalance'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      prefs.setInt('sell_balance', data['sell_balance']);
      prefs.setInt('buy_balance', data['buy_balance']);
      prefs.setInt('commissions', data['commissions']);

    } else {
      throw Exception('Failed to load operations');
    }
  }

}
