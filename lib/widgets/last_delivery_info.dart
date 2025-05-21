import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ounce/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ounce/theme/theme.dart';
import '../../generated/l10n.dart';

class LastDeliveryInfo extends StatefulWidget {
  @override
  _LastDeliveryInfoState createState() => _LastDeliveryInfoState();
}

class _LastDeliveryInfoState extends State<LastDeliveryInfo> {
  bool _isLoading = true;
  Map<String, dynamic>? _lastDelivery;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLastDelivery();
  }

  Future<void> _fetchLastDelivery() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String? token = await Constants().getTokenFromSecureStorage();
      final response = await http.get(
        Uri.parse('${Constants.apiUri}/last-delivered-operation'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _lastDelivery = data;
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _lastDelivery = null;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load delivery information';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy - HH:mm').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      color: BoxBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: buttonAccentColor, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Last Delivered Operation",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: buttonAccentColor,
              ),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      TextButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text("Retry"),
                        onPressed: _fetchLastDelivery,
                      ),
                    ],
                  ),
                ),
              )
            else if (_lastDelivery == null)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 40),
                        SizedBox(height: 8),
                        Text(
                          "No deliveries completed yet",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      icon: Icons.access_time,
                      label: "Completed On",
                      value: _formatDateTime(_lastDelivery!['updated_at']),
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.attach_money,
                      label: "Unit Price",
                      value: "\$${_lastDelivery!['unit_price']}",
                    ),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.shopping_bag,
                      label: "Number Of Units",
                      value: "${_lastDelivery!['number_of_units']}",
                    ),
                    SizedBox(height: 12),
                    Divider(color: buttonAccentColor.withOpacity(0.5)),
                    SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.monetization_on,
                      label: "Total Amount",
                      value: "\$${_lastDelivery!['total_amount']}",
                      highlight: true,
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: Icon(Icons.receipt_long, size: 18),
                        label: Text("Operation #${_lastDelivery!['operation_id']}"),
                        onPressed: () {
                          // Optionally, navigate to operation details
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: buttonAccentColor,
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: highlight ? GoldInBetween : buttonAccentColor,
          size: highlight ? 24 : 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: highlight ? GoldInBetween : Colors.white,
                  fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
                  fontSize: highlight ? 18 : 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}