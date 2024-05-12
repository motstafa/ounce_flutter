import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/theme/theme.dart';
import 'package:ounce/main.dart';

// Conditional import
import 'dart:io';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:provider/provider.dart';

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
    BalanceProvider balanceProvider = Provider.of<BalanceProvider>(context);
    balanceProvider.callToGetBalance();
    return FutureBuilder(
      // Assume getSellBalance is a method that returns a Future<int>
      future: balanceProvider.fetchBalance('sell'),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loader while waiting for the balance value
          return Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          // Handle error state
          return Text('Error: ${snapshot.error}');
        } else {
          // Check if the balance is zero and display a message instead of the form
          final sellBalance = snapshot.data ?? 0;
          if (sellBalance == 0) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'Sell Page',
                  style: TextStyle(color: buttonAccentColor),
                  textAlign: TextAlign.center,
                ),
              ),
              body:const  Center(
                child: Text(
                  'You do not have enough balance to sell items.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: CustomAppBar(pageName:'Sell Page',balanceType:"sell"),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Unit Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: priceController,
                    ),
                    SizedBox(height: 16.0),

                    DropdownButtonFormField<String>(
                      value: unitTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Unit Type',
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
                      decoration: const InputDecoration(
                        labelText: 'Number of Units',
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
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Upload Once\'s Picture',
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
                                  title: const Text('Insufficient Balance'),
                                  content: const Text(
                                      'You do not have enough balance to sell items.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('OK'),
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
                            }
                            else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Insufficient Balance'),
                                    content: const Text(
                                        'You do not have enough balance to sell items.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
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
                      child: const Text('Submit'),
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
