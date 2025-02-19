import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ounce/theme/theme.dart';

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

  @override
  void initState() {
    super.initState();
    fetchGoldData();
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
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isError = true;
        });
      }
      print('Error fetching data: $error');
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
            onPressed: fetchGoldData,
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: GoldColor!, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            // Simple Border
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
              if (isError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Using default data due to error',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
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
