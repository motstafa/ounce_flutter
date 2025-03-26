import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ounce/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../main.dart';

class backendNotificationService {

  final baseUrl=Constants.apiUri;



  Future <List<NotificationItem>> getNotifications() async{

    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };
    final response =
    await http.get(Uri.parse('$baseUrl/notification'), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      var length = data.length;
      return data
          .map<NotificationItem>(
              (json) => NotificationItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load operations');
    }
  }


  Future <bool> markAsRead(int notificationId) async{

    final prefs = await SharedPreferences.getInstance();

    var url = '$baseUrl/notification/read';

    String? token = await Constants().getTokenFromSecureStorage(); // Retrieve token from shared preferences
    // Retrieve token from shared preferences

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Add the token to the headers
    };

    var body = jsonEncode({
      'id': notificationId,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal Login');
    }
  }
}