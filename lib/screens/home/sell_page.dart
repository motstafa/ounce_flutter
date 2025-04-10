import 'dart:io'; // Import this for File class
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../providers/notification_provider.dart';
import 'package:flutter/cupertino.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  XFile? _imageFile;
  final _formKey = GlobalKey<FormState>();


  // Function to delete the selected image
  void _deleteImage() {
    Navigator.of(context).pop();
    setState(() {
      _imageFile = null;
    });
  }

  // Make the SwitchButton stateful within this class
  late SwitchButton switcher;

  TextEditingController priceController = TextEditingController();
  String? unitTypeController;
  TextEditingController numberOfUnitsController = TextEditingController();
  TextEditingController expiresInController = TextEditingController();

  // Add a state variable to track the selected expiration time
  int _selectedExpirationTime = 1;

  final List<String> unitTypes = ['swiss', 'italy', 'england'];

  bool isProcessing = false; // Track whether the button is being processed

  @override
  void initState() {
    super.initState();
    // Initialize the switcher in initState
    switcher = SwitchButton();
  }

  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 200,
          child: ListView.builder(
            itemCount: 60, // Example: Select minutes from 1 to 60
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${index + 1} minutes'),
                onTap: () {
                  setState(() {
                    // Ensure UI updates
                    expiresInController.text = '${index + 1}';
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  // Function to show image in a dialog
  void _showImagePreview() {
    if (_imageFile == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child:  GestureDetector(
            onTap: _imageFile == null ? _selectImage : _showImagePreview,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _imageFile == null
                  ? Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(Icons.add_a_photo, size: 40),
                    Text(
                      S.of(context).uploadOncePictureLabel,
                      style: TextStyle(),
                    ),
                  ],
                ),
              )
                  : Stack(
                children: [
                  Image.file(
                    File(_imageFile!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: _showImagePreview,
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed:   _deleteImage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    BalanceProvider balanceProvider =
    Provider.of<BalanceProvider>(context, listen: false);
    balanceProvider.callToGetBalance();

    return FutureBuilder(
      future: balanceProvider.fetchBalance('sell'),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
          return Text('${S.of(context).error}: ${snapshot.error}');
        } else {
          print(snapshot.data);
          final sellBalance = snapshot.data ?? 0;
          if (sellBalance == 0) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: CustomAppBar(
                  pageName: S.of(context).sellPageTitle,
                  balanceType: "sell",
                  sellPage: true),
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
              appBar: CustomAppBar(
                  pageName: S.of(context).sellPageTitle,
                  balanceType: "sell",
                  sellPage: true),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).requiredField;
                        }
                        return null;
                      },
                    ),
                    // SizedBox(height: 16.0),
                    // DropdownButtonFormField<String>(
                    //   value: unitTypeController,
                    //   decoration: InputDecoration(
                    //     labelText: S.of(context).unitTypeLabel,
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: unitTypes
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   onChanged: (String? newValue) {
                    //     setState(() {
                    //       unitTypeController = newValue;
                    //     });
                    //   },
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return S.of(context).requiredField;
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: S.of(context).numberOfUnitsLabel,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      controller: numberOfUnitsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).requiredField;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _showPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              expiresInController.text.isNotEmpty
                                  ? '${expiresInController.text} minutes'
                                  : S.of(context).expireIn,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    switcher,
                    GestureDetector(
                      onTap: _imageFile == null
                          ? _selectImage
                          : _showImagePreview,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _imageFile == null
                            ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.add_a_photo, size: 40),
                              Text(
                                S.of(context).uploadOncePictureLabel,
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        )
                            : Stack(
                          children: [
                            Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(Icons.fullscreen, color: Colors.white),
                                onPressed: _showImagePreview,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_imageFile == null)
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text(
                          S.of(context).requiredField,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: isProcessing
                          ? null
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          if (_imageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).imageRequired),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isProcessing = true; // Disable the button
                          });

                          _formKey.currentState!.save();

                          if (sellBalance == 0) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(S
                                      .of(context)
                                      .insufficientBalanceTitle),
                                  content: Text(S
                                      .of(context)
                                      .insufficientBalanceMessage),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                          S.of(context).okButtonLabel),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            final operationProvider =
                            Provider.of<OperationProvider>(context,
                                listen: false);

                            double? price =
                            double.tryParse(priceController.text);
                            int? numberOfUnits = int.tryParse(
                                numberOfUnitsController.text);

                            bool result = await operationProvider.sell(
                              priceController.text,
                              _imageFile,
                              numberOfUnitsController.text,
                              expiresInController.text,
                              switcher.getValue() ? 1 : 0,
                            );

                            setState(() {
                              isProcessing =
                              false; // Enable the button after processing
                            });

                            if (result) {
                              setState(() {
                                priceController.clear();
                                numberOfUnitsController.clear();
                                unitTypeController = null;
                                expiresInController.clear();
                                _imageFile = null;
                                balanceProvider.callToGetBalance();
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(S
                                        .of(context)
                                        .insufficientBalanceTitle),
                                    content: Text(S
                                        .of(context)
                                        .insufficientBalanceMessage),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            S.of(context).okButtonLabel),
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
                      child: isProcessing
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(S.of(context).submitButtonLabel),
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

// The SwitchButton class remains unchanged
class SwitchButton extends StatefulWidget {
  bool? isRetail;

  SwitchButton({Key? key, this.isRetail}) : super(key: key);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();

  bool getValue() {
    return isRetail ?? false;
  }
}

class _SwitchWidgetState extends State<SwitchButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            S.of(context).allowRetail,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 10),
          Switch(
            value: widget.isRetail ?? false,
            onChanged: (value) {
              setState(() {
                widget.isRetail = value;
              });
            },
          )
        ],
      ),
    );
  }
}