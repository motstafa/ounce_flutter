import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ounce/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:ounce/models/operation_model.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/theme/theme.dart'; // Make sure this import is correct
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/providers/notification_provider.dart';

import '../../generated/l10n.dart';

class BuyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the provider and call loadOperations if not already loaded
    final operationProvider =
        Provider.of<OperationProvider>(context, listen: false);
    final BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: false);

    if (operationProvider.operations.isEmpty) {
      operationProvider.loadOperations();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
          pageName: S.of(context).buyPageTitle, balanceType: 'buy'),
      body: Consumer<OperationProvider>(
        builder: (context, provider, child) {
          // Use a FutureBuilder to wait for the loadOperations future to complete
          return FutureBuilder(
            future: provider.loadOperations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('${S.of(context).error}: ${snapshot.error}'));
              } else {
                // Once the future is complete, build the ListView
                return ListView.builder(
                  itemCount: provider.operations.length,
                  itemBuilder: (context, index) {
                    final operation = provider.operations[index];
                    return OperationItem(operation);
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}

class OperationItem extends StatelessWidget {
  Operation operation;

  // Define the controller as a member of the state class
  final TextEditingController _controller = TextEditingController();

  //Constructor
  OperationItem(this.operation);

  @override
  Widget build(BuildContext context) {
    String operationNumber =
        '${S.of(context).operationNumberLabel}: ${Operation.generateBigFakeNumber(operation.id)}';
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: BoxBackground, // Dark theme background color
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: buttonAccentColor), // Gold border for emphasis
      ),
      child: InkWell(
        onTap: () {
          showBuyItemDialog(context, operation);
        },
        borderRadius: BorderRadius.circular(10.0), // Ensures ripple effect respects container shape
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.inventory_2, color: buttonAccentColor),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              '${S.of(context).numberOfOuncesLabel}: ${operation.numberOfUnits}',
                              style: TextStyle(
                                  color: buttonAccentColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.attach_money, color: buttonAccentColor),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              '${S.of(context).totalPriceLabel}: \$${operation.total}',
                              style: TextStyle(
                                  color: buttonAccentColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showBuyItemDialog(BuildContext context, Operation operation) {
    SharedPreferences.getInstance().then((prefs) {
      BalanceProvider balanceProvider =
          Provider.of<BalanceProvider>(context, listen: false);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return PurchaseDialog(
              operation: operation, balanceProvider: balanceProvider);
        },
      );
    });
  }
}

class PurchaseDialog extends StatefulWidget {
  final Operation? operation;
  BalanceProvider? balanceProvider;

  PurchaseDialog({super.key, this.operation, this.balanceProvider});

  @override
  _PurchaseDialogState createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
  bool _isConfirming = false;
  int? calculatedValue = 0;
  int selectedItems = 0;
  bool _deliveryAvailable=false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isConfirming ? 'Confirm Delivery' : 'Confirm Purchase'),
      content: SingleChildScrollView(
        child: ListBody(
          children: _isConfirming
              ? <Widget>[
                 _deliveryAvailable ? Text(''): Text(S.of(context).busy),
                 _deliveryAvailable ? Text(S.of(context).noDelay):Text(S.of(context).delayed)
                ]
              : <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            displayBalance(balanceType: 'buy'),
                            SizedBox(height: 20),
                            // Adjust the space as needed
                          ],
                        ),
                      ),
                      // ... other widgets
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Text(
                          '${S.of(context).typeOfOuncesLabel}: ',
                          // This text will update when setState is called
                          style: TextStyle(
                            color: buttonAccentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.operation!.unitType,
                          // This text will update when setState is called
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]),
                      Container(
                        width: 85.0,
                        height: 85.0,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                          ),
                        ),
                        child: Image.network(
                          widget.operation!.picOfUnits ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/images/ounce.png',
                                fit: BoxFit.cover);
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${S.of(context).retailLabel}: ${widget.operation!.retail == 1 ? S.of(context).trueLabel : S.of(context).falseLabel}',
                        style: TextStyle(
                          color: buttonAccentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${S.of(context).numberOfOuncesDialogLabel}: '),
                      DropdownButton<int>(
                        value: widget.operation!.retail == 0
                            ? selectedItems=widget.operation!.numberOfUnits
                            : selectedItems,
                        items: [
                          const DropdownMenuItem<int>(
                            value: 0,
                            child: Text('0'), // Default value
                          ),
                          ...List.generate(
                            widget.operation!.numberOfUnits,
                            (index) => DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            ),
                          ),
                        ],
                        onChanged: widget.operation!.retail == 0
                            ? null
                            : (value) {
                                setState(() {
                                  selectedItems =
                                      value ?? 0; // Set to 0 if null
                                  calculatedValue = Constants().CalculatePrice(
                                      selectedItems,
                                      widget.operation!.unitPrice);
                                });
                              },
                      ),
                    ], // Add more product info here
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${S.of(context).total}: ',
                        // This text will update when setState is called
                        style: TextStyle(
                          color: buttonAccentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${widget.operation!.retail == 0 ? widget.operation!.total : calculatedValue} \$',
                        // This text will update when setState is called
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  )
                ],
        ),
      ),
      actions: <Widget>[
        if (!_isConfirming)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: Text(S.of(context).buyButtonText),
                onPressed: () async{
                  final operationProvider =
                  Provider.of<OperationProvider>(context, listen: false);
                  _deliveryAvailable = await operationProvider.checkDeliveries(
                      widget.operation!.id);
                  if(selectedItems>0){
                  setState(() {
                    _isConfirming = true;
                  });
                  }
                },
              ),
              ElevatedButton(
                child: Text(S.of(context).cancel),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          ),
        if (_isConfirming)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            ElevatedButton(
              child: Text(S.of(context).confirm),
              onPressed: () async {
                // Handle the confirmation action
                // Perform purchase action
                final operationProvider =
                    Provider.of<OperationProvider>(context, listen: false);
                bool result = await operationProvider.Buy(
                    widget.operation!.id, selectedItems);
                if (result) {
                  await operationProvider.refreshPage();
                  widget.balanceProvider!.callToGetBalance();
                  Navigator.of(context, rootNavigator: true).pop();
                }
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: Text(S.of(context).cancel),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            )
          ]),
      ],
    );
  }
}
