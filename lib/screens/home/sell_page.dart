import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/theme/theme.dart';
import 'package:ounce/main.dart';
import 'dart:html' as html;
// Conditional import
import 'dart:io';
import 'package:ounce/providers/operation_provider.dart';
import 'package:provider/provider.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  XFile? _imageFile;

  final sellBalance = prefs.getInt('sell_balance');

  final _formKey = GlobalKey<FormState>();
  double? priceController;
  String? unitTypeController;
  int? numberOfUnitsController;

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'Sell Page',
            style: TextStyle(color: buttonAccentColor),
            textAlign: TextAlign.center,
          ),
          Text(
            'Your Balance: $sellBalance',
            style: TextStyle(color: buttonAccentColor),
            textAlign: TextAlign.center,
          )
        ]),
      ),
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
              onSaved: (value) {
                priceController = double.tryParse(value ?? '');
              },
            ),
            SizedBox(height: 16.0),

            DropdownButtonFormField<String>(
              value: unitTypeController,
              decoration: const InputDecoration(
                labelText: 'Unit Type',
                border: OutlineInputBorder(),
              ),
              items: unitTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  unitTypeController = newValue;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Number of Units',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                numberOfUnitsController = int.tryParse(value ?? '');
              },
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _selectImage, // Call _selectImage function when tapped
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
                          'Upload Store Picture',
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
                        Provider.of<OperationProvider>(context, listen: false);
                    bool result = await operationProvider.sell(
                        priceController!,
                        unitTypeController!,
                        _imageFile!,
                        numberOfUnitsController!);
                    if (result) {
                      setState(() {});
                      Navigator.of(context, rootNavigator: true)
                          .pop(); // This will close the topmost dialog
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
