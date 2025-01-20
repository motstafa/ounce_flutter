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
          if (await balanceProvider.callToGetBalance()) {
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
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
