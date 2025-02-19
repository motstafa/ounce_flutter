import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/services/balance_service.dart';
import 'package:ounce/theme/theme.dart';
import '../generated/l10n.dart';

class BalanceProvider with ChangeNotifier {
  late int _sellingBalance;
  late int _buyingBalance;



  // Method to fetch the selling balance asynchronously
  Future<int> fetchBalance(String balanceType) async {
    try {
      // Simulate a network request with a delay
      await Future.delayed(Duration(seconds: 1));
      // Return the fetched balance
      if(balanceType=='buy')
        return _buyingBalance;
      return _sellingBalance;
    } catch (e) {
      // Handle any errors here
      throw e;
    }
  }


  int get sellingBalance => _sellingBalance;

  int get buyingBalance => _buyingBalance;

  void updateSellingBalance(int amount) {
    _sellingBalance += amount;
    notifyListeners();
  }

  void updateBuyingBalance(int amount) {
    _buyingBalance += amount;
    notifyListeners();
  }

  callToGetBalance() async {
    try {
      Map<String, int> balance = await AuthService().getTraderBalance();

      _sellingBalance = balance['sell_balance'] as int;
      _buyingBalance = balance['buy_balance'] as int;
      // notifyListeners();
      return true;
    } catch (e) {
      return {};
    }
  }
}

// Usage in a widget
class BalanceDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context,listen: false);
    return Column(
      children: [
        Text('Selling Balance: ${balanceProvider.sellingBalance}'),
        Text('Buying Balance: ${balanceProvider.buyingBalance}'),
      ],
    );
  }
}

class displayBalance extends StatelessWidget{

  String balanceType;
  int? Balance;
  displayBalance({required this.balanceType});

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context,listen: false);
    return FutureBuilder<int>(
      future: balanceProvider.fetchBalance(balanceType), // Assuming this returns a Future<double>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            'Your Balance: Loading...', // Show a loading message while fetching data
            style: TextStyle(color: buttonAccentColor),
            textAlign: TextAlign.center,
          );
        } else if (snapshot.hasError) {
          return Text(
            'Error fetching balance', // Handle error case
            style: TextStyle(color: buttonAccentColor),
            textAlign: TextAlign.center,
          );
        } else {
          Balance = (snapshot.data)?.toInt() ?? 0; // Default to 0.0 if data is null
          return Text(
            '${S.of(context).yourBalance} $Balance',
            style: TextStyle(color: buttonAccentColor,fontWeight:FontWeight.w600,fontSize: 17),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
