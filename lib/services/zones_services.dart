import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ounce/constants/constants.dart';
import 'package:ounce/models/zone_model.dart';

class ZoneService {
  final String baseUrl = Constants.apiUri;

  Future<List<ZoneModel>> getZones() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/zone'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ZoneModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load zones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching zones: $e');
    }
  }
}