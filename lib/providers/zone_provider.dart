import 'package:flutter/material.dart';
import 'package:ounce/models/zone_model.dart';
import '../services/zones_services.dart';

class ZoneProvider with ChangeNotifier {
  final ZoneService _zoneService = ZoneService();
  List<ZoneModel> _zones = [];
  bool _isLoading = false;
  String? _error;

  List<ZoneModel> get zones => _zones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchZones() async {
    if (_zones.isNotEmpty) {
      return; // Zones already loaded
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _zones = await _zoneService.getZones();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}