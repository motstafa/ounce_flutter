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
        Provider.of<BalanceProvider>(context,listen: false);

    if (operationProvider.operations.isEmpty) {
      operationProvider.loadOperations();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(pageName: S.of(context).buyPageTitle, balanceType: 'buy'),
      body: Consumer<OperationProvider>(
        builder: (context, provider, child) {
          // Use a FutureBuilder to wait for the loadOperations future to complete
          return FutureBuilder(
            future: provider.loadOperations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${S.of(context).error}: ${snapshot.error}'));
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
        border:
            Border.all(color: buttonAccentColor), // Gold border for emphasis
      ),
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
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            operationNumber,
                            style: TextStyle(
                              color: GoldColor, // Gold text color for emphasis
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.inventory_2, color: buttonAccentColor),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '${S.of(context).numberOfOuncesLabel}: ${operation.numberOfUnits}',
                            style: TextStyle(
                              color: buttonAccentColor, // Light text color for contrast
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.merge_type, color: buttonAccentColor),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '${S.of(context).typeOfOuncesLabel}: ${operation.unitType}',
                            style: TextStyle(
                              color: buttonAccentColor, // Light text color for contrast
                            ),
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
                              color: buttonAccentColor, // Light text color for contrast
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.date_range, color: buttonAccentColor),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            '${S.of(context).dateOfOperationLabel}: ${operation.dateOfOperation}',
                            style: TextStyle(
                              color: buttonAccentColor, // Light text color for contrast
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10,top:40),
                width: 85.0,
                height: 85.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: Image.network(
                  operation.picOfUnits ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    // Return default asset image when network image fails to load
                    return Image.asset('assets/images/ounce.png', fit: BoxFit.cover);
                  },
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              // Adjust the value as needed
              child: ElevatedButton(
                onPressed: () {
                  showBuyItemDialog(context, operation);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                          color: buttonAccentColor), // Gold border for emphasis
                    ),
                  ),
                  padding: MaterialStateProperty.all(EdgeInsets
                      .zero), // Needed to make the Container fill the button
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: GoldButton, // Replace with your gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    constraints: BoxConstraints(
                        minWidth: double.infinity, minHeight: 50.0),
                    // Set minimum size for the button
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).buyButtonText,
                      style:const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .white, // Choose a color that contrasts well with the gradient
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )

          // Add other relevant information from your Operation model
          // For example: unit type, number of units, total, etc.
        ],
      ),
    );
  }

  // prompt box when pressing buy button
  void showBuyItemDialog(BuildContext context, Operation operation) {
    SharedPreferences.getInstance().then((prefs) {
      BalanceProvider balanceProvider = Provider.of<BalanceProvider>(context,listen: false);

      var unitPrice = operation.unitPrice;
      int? calculatedValue = 0;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          int selectedItems = 0; // Default selected number of items
          return Dialog(child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              // To make the dialog compact
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 50),
                          width: 85.0,
                          // Set your desired width for the image
                          height: 85.0,
                          // Set your desired height for the image
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Image.network(
                            operation.picOfUnits ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception,
                                StackTrace? stackTrace) {
                              // Return default asset image when network image fails to load
                              return Image.asset('assets/images/ounce.png', fit: BoxFit.cover);
                            },
                          ),
                        ),
                      ],
                    ),
                    // ... other widgets
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${S.of(context).numberOfOuncesDialogLabel}: '),
                    DropdownButton<int>(
                      value: selectedItems,
                      items: [
                        const DropdownMenuItem<int>(
                          value: 0,
                          child:
                              Text('0'), // This represents your default value
                        ),
                        ...List.generate(
                          operation.numberOfUnits,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('${index + 1}'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedItems = value ?? 0; // Set to 0 if null
                          calculatedValue = Constants().CalculatePrice(
                              selectedItems, operation.unitPrice);
                        });
                      },
                    ),
                    const SizedBox(width: 50),
                    // Space between dropdown and text
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$calculatedValue',
                        // This text will update when setState is called
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Perform purchase action
                      final operationProvider = Provider.of<OperationProvider>(
                          context,
                          listen: false);
                      bool result = await operationProvider.Buy(
                          operation.id, selectedItems);
                      if (result) {
                        await operationProvider.refreshPage();
                        balanceProvider.callToGetBalance();
                        Navigator.of(context, rootNavigator: true)
                            .pop(); // This will close the topmost dialog
                      }
                    },
                    child: Text(S.of(context).buyDialogButtonText),
                  ),
                )
              ],
            );
          }));
        },
      );
    });
  }
}
