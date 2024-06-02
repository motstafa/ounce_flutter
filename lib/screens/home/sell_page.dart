import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/theme/theme.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../providers/notification_provider.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  XFile? _imageFile;

  final _formKey = GlobalKey<FormState>();

  TextEditingController priceController = TextEditingController();
  String? unitTypeController;
  TextEditingController numberOfUnitsController = TextEditingController();

  // Assuming this is your static list for unit types
  final List<String> unitTypes = ['swiss', 'italy', 'england'];

  // Function to handle image selection
  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() async {
        _imageFile = pickedImage;
        // Convert XFile to File and assign to picOfUnitsController
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    BalanceProvider balanceProvider = Provider.of<BalanceProvider>(context,listen: false);
    balanceProvider.callToGetBalance();
    return FutureBuilder(
      // Assume getSellBalance is a method that returns a Future<int>
      future: balanceProvider.fetchBalance('sell'),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loader while waiting for the balance value
          return Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return Text('${S.of(context).error}: ${snapshot.error}');
        } else {
          // Check if the balance is zero and display a message instead of the form
          final sellBalance = snapshot.data ?? 0;
          if (sellBalance == 0) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  S.of(context).sellPageTitle,
                  style: TextStyle(color: buttonAccentColor),
                  textAlign: TextAlign.center,
                ),
              ),
              body: Center(
                child: Text(
                  S.of(context).notEnoughBalanceMessage,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: CustomAppBar(pageName: S.of(context).sellPageTitle, balanceType: "sell"),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context).unitPriceLabel,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: priceController,
                    ),
                    SizedBox(height: 16.0),

                    DropdownButtonFormField<String>(
                      value: unitTypeController,
                      decoration: InputDecoration(
                        labelText: S.of(context).unitTypeLabel,
                        border: OutlineInputBorder(),
                      ),
                      items: unitTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        unitTypeController = newValue;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context).numberOfUnitsLabel,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      controller: numberOfUnitsController,
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: _selectImage,
                      // Call _selectImage function when tapped
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              // Default border color
                              ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _imageFile == null
                            ? Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  S.of(context).uploadOncePictureLabel,
                                  style: TextStyle(),
                                ),
                              )
                            : Image.network(
                                _imageFile!.path,
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                      ),
                    ),
                    // Add other form fields if necessary
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Check if sellBalance is 0 and prevent selling
                          if (sellBalance == 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(S.of(context).insufficientBalanceTitle),
                                  content:Text(S.of(context).insufficientBalanceMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(S.of(context).okButtonLabel),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Perform the selling operation with the form data
                            final operationProvider =
                                Provider.of<OperationProvider>(context,
                                    listen: false);

                            double? price =
                                double.tryParse(priceController.text);
                            int? numberOfUnits =
                                int.tryParse(numberOfUnitsController.text);

                            bool result = await operationProvider.sell(
                                price!,
                                unitTypeController!,
                                _imageFile!,
                                numberOfUnits!);
                            if (result) {
                              setState(() {
                                priceController.clear();
                                numberOfUnitsController.clear();
                                unitTypeController = null;
                                _imageFile = null;
                                balanceProvider.callToGetBalance();
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(S.of(context).insufficientBalanceTitle),
                                    content: Text(S.of(context).insufficientBalanceMessage),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(S.of(context).okButtonLabel),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        }
                      },
                      child: Text(S.of(context).submitButtonLabel),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
