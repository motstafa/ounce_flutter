import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ounce/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;

class Constants {
  //android emulator http://10.0.2.2:8000/api
  //web http://127.0.0.1:8000/api
  // static const String apiUri ='http://10.0.2.2:8000/api';
  static const String apiUri = 'http://ounce-laravel-env.eba-nmpjzgug.eu-west-1.elasticbeanstalk.com/api';
  static const userRoles = <String, dynamic>{'trader': 1, 'delivery': 2};
  final storage = const FlutterSecureStorage();
  String baseUrl = Constants.apiUri;
  int CalculatePrice(int itemNumber, int itemPrice) {
    var commission = prefs.getInt('commissions');
    return itemPrice * itemNumber + commission! * itemNumber;
  }

  Future<int?> getRoleFromSecureStorage() async {
    String? value = await storage.read(key: 'role');
    return value != null ? int.tryParse(value) : null;
  }

  Future<String?> getTokenFromSecureStorage() async {
    String? value= await storage.read(key: 'sanctum_token');
    return value;
  }

  String getOperationStatusTranslation(BuildContext context, String status) {
    switch (status) {
      case 'done':
        return S.of(context).operationDone;
      case 'inProgress':
        return S.of(context).operationInProgress;
      case 'pending':
        return S.of(context).operationPending;
      case 'failed':
        return S.of(context).operationFailed;
      case 'paused':
        return S.of(context).operationPaused;
      case 'canceled':
        return S.of(context).operationCanceled;
      default:
        return status; // Or a default value or error string
    }
  }

  Future<bool> sendTokenToBackend(notificationToken) async {

      final prefs = await SharedPreferences.getInstance();
      print('send token to backedn');
      var url = '$baseUrl/saveNotificationToken';

      String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Add the token to the headers
      };

      var body = jsonEncode({
        'notification_token': notificationToken,
      });

      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print('essssend');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Gagal Login');
      }
    }
}
