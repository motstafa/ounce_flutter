import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/theme/theme.dart';
import 'package:ounce/constants/constants.dart';
import 'package:intl/intl.dart';
import '../../generated/l10n.dart'; // Import for translations

class TraderHomePage extends StatefulWidget {
  @override
  _TraderHomePageState createState() => _TraderHomePageState();
}

class _TraderHomePageState extends State<TraderHomePage> {
  final String apiUrl = 'https://www.goldapi.io/api/XAU/USD';
  final String apiToken = 'goldapi-76jbu8sm63eherp-io';
  Map<String, dynamic> goldData = {
    'metal': 'Gold',
    'currency': 'USD',
    'price': 1900.00,
    'ask': 1905.00,
    'bid': 1895.00,
    'price_gram_22k': 58.00,
    'ch': 0.00,
    'chp': 0.00,
  };
  Timer? _timer;
  bool isError = false;

  // Add last delivery data state
  bool _isLoadingDelivery = true;
  Map<String, dynamic>? _lastDelivery;

  @override
  void initState() {
    super.initState();
    fetchGoldData();
    fetchLastDelivery(); // Fetch last delivery data

    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchGoldData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchGoldData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'x-access-token': apiToken,
        },
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            goldData = json.decode(response.body);
            isError = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isError = true;
          });
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
    }
  }

  // Add method to fetch last delivery
  Future<void> fetchLastDelivery() async {
    setState(() {
      _isLoadingDelivery = true;
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
          _isLoadingDelivery = false;
        });
      } else {
        setState(() {
          _lastDelivery = null;
          _isLoadingDelivery = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _lastDelivery = null;
          _isLoadingDelivery = false;
        });
      }
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Gold Price Tracker',
          style: TextStyle(color: GoldInBetween),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: GoldInBetween),
            onPressed: () {
              fetchGoldData();
              fetchLastDelivery();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              // Gold price container
              Center(
                child: Container(
                  padding: EdgeInsets.all(50),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: GoldColor!, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: GoldInBetween.withOpacity(0.5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildInfoRow(
                        icon: Icons.workspace_premium,
                        label: 'Metal',
                        value: goldData['metal'],
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        icon: Icons.attach_money,
                        label: 'Currency',
                        value: goldData['currency'],
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        icon: Icons.price_change,
                        label: 'Price',
                        value: '\$${goldData['price'].toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        icon: Icons.trending_up,
                        label: 'Ask',
                        value: '\$${goldData['ask'].toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        icon: Icons.trending_down,
                        label: 'Bid',
                        value: '\$${goldData['bid'].toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        icon: Icons.grade,
                        label: 'Price (22K)',
                        value: '\$${goldData['price_gram_22k'].toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 16),
                      buildInfoRow(
                        icon: Icons.show_chart,
                        label: 'Change',
                        value: '${goldData['ch']} (${goldData['chp']}%)',
                        valueStyle: TextStyle(
                          color: goldData['ch'] >= 0 ? Colors.green : Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Title for the last operation section
              if (_lastDelivery != null || _isLoadingDelivery)
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: buttonAccentColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        S.of(context).lastOperation, // "Last Operation" translation
                        style: TextStyle(
                          color: buttonAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Last delivery summary - simplified
              if (_lastDelivery != null || _isLoadingDelivery)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: BoxBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: buttonAccentColor),
                  ),
                  child: _isLoadingDelivery
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(buttonAccentColor),
                      ),
                    ),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date and time
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: buttonAccentColor,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).dateOfOperationLabel, // "Date of Operation" translation
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                _formatDateTime(_lastDelivery!['updated_at']),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Unit price
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: GoldInBetween,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).unitPriceLabel, // "Unit Price" translation
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '\$${_lastDelivery!['unit_price']}',
                                style: TextStyle(
                                  color: GoldInBetween,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: GoldInBetween,
          size: 28,
        ),
        SizedBox(width: 16),
        Text(
          '$label: ',
          style: TextStyle(
            color: buttonFocusedColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
        ),
      ],
    );
  }
}