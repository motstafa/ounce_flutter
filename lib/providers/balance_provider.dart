import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ounce/services/balance_service.dart';
import 'package:ounce/theme/theme.dart';
import '../generated/l10n.dart';

class BalanceProvider with ChangeNotifier {
  int _sellingBalance = 0;
  int _buyingBalance = 0;

  Future<int> fetchBalance(String balanceType) async {
    try {
      if (balanceType == 'buy') return _buyingBalance;
      return _sellingBalance;
    } catch (e) {
      throw e;
    }
  }

  callToGetBalance() async {
    try {
      Map<String, int> balance = await AuthService().getTraderBalance();

      _sellingBalance = balance['sell_balance'] as int;
      _buyingBalance = balance['buy_balance'] as int;
      notifyListeners();
      return true;
    } catch (e) {
      return {};
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

class displayBalance extends StatelessWidget {
  final String balanceType;

  displayBalance({required this.balanceType});

  @override
  Widget build(BuildContext context) {
    // Remove listen: false to properly listen to changes
    final balanceProvider = Provider.of<BalanceProvider>(context);

    return Consumer<BalanceProvider>(
      builder: (context, balanceProvider, child) {
        return FutureBuilder<int>(
          future: balanceProvider.fetchBalance(balanceType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                'Your Balance: Loading...',
                style: TextStyle(color: buttonAccentColor),
                textAlign: TextAlign.center,
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error fetching balance',
                style: TextStyle(color: buttonAccentColor),
                textAlign: TextAlign.center,
              );
            } else {
              final balance = snapshot.data ?? 0;
              return Text(
                '${balanceType == 'sell' ? S.of(context).sellBalance : S.of(context).buyBalance} $balance',
                style: TextStyle(
                    color: buttonAccentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 17
                ),
                textAlign: TextAlign.center,
              );
            }
          },
        );
      },
    );
  }
}
