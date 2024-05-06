import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceProvider with ChangeNotifier {
  double _sellingBalance;
  double _buyingBalance;

  BalanceProvider(this._sellingBalance, this._buyingBalance);

  double get sellingBalance => _sellingBalance;
  double get buyingBalance => _buyingBalance;

  void updateSellingBalance(double amount) {
    _sellingBalance += amount;
    notifyListeners();
  }

  void updateBuyingBalance(double amount) {
    _buyingBalance += amount;
    notifyListeners();
  }

  
}

// Usage in a widget
class BalanceDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);
    return Column(
      children: [
        Text('Selling Balance: ${balanceProvider.sellingBalance}'),
        Text('Buying Balance: ${balanceProvider.buyingBalance}'),
      ],
    );
  }
}
