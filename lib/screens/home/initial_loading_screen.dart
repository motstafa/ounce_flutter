import 'package:flutter/material.dart';
import 'package:ounce/constants/constants.dart';
import 'package:ounce/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../providers/balance_provider.dart';

class InitialLoadingScreen extends StatefulWidget {
  @override
  _InitialLoadingScreenState createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  bool _isSystemStopped = false; // Flag to track if the system is stopped

  @override
  void initState() {
    super.initState();
    // Schedule the _checkToken function to be called after the build method.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkToken();
    });
  }

  Future<void> _checkToken() async {
    // Now the context includes the InitialLoadingScreen and its ancestors.
    BalanceProvider balanceProvider = Provider.of<BalanceProvider>(context, listen: false);

    String? token = await Constants().getTokenFromSecureStorage();
    int? role = await Constants().getRoleFromSecureStorage();
    AuthService authService = AuthService();
    if (token != null) {
      bool isValid = await authService.validateToken(token);
      if (isValid) {
        if (role == Constants.userRoles['trader']) {
          dynamic balanceResponse = await balanceProvider.callToGetBalance();
          if (balanceResponse is Map && balanceResponse.isEmpty) {
            // If the response is an empty map, set the flag to true
            setState(() {
              _isSystemStopped = true;
            });
          } else {
            Navigator.pushReplacementNamed(context, '/trader');
          }
        } else {
          Navigator.pushReplacementNamed(context, '/delivery');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/sign-in');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isSystemStopped
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The system is currently stopped.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Please wait until we reopen our services.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for your patience!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        )
            : CircularProgressIndicator(), // Show progress indicator by default
      ),
    );
  }
}