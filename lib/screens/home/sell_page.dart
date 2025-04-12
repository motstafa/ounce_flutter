import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/widgets/imageService.dart';
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
  bool _isImageTooLarge = false;

  void _deleteImage() {
    Navigator.of(context).pop();
    setState(() {
      _imageFile = null;
      _isImageTooLarge = false;
    });
  }

  late SwitchButton switcher;
  TextEditingController priceController = TextEditingController();
  String? unitTypeController;
  TextEditingController numberOfUnitsController = TextEditingController();
  TextEditingController expiresInController = TextEditingController();
  int _selectedExpirationTime = 1;
  final List<String> unitTypes = ['swiss', 'italy', 'england'];
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    switcher = SwitchButton();
  }

  Future<void> _showImageSourceDialog() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(S.of(context).selectImageSource),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _selectImage(ImageSource.camera);
            },
            child: Text(S.of(context).takePhoto),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _selectImage(ImageSource.gallery);
            },
            child: Text(S.of(context).chooseFromGallery),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final image = await ImageService.pickAndCompressImage(context, source);
      if (image != null) {
        final imageFile = File(image.path);
        final fileSize = await imageFile.length();
        final isTooLarge = fileSize > 2048 * 1024;

        setState(() {
          // Always set the image file, even if it's too large
          _imageFile = image;
          _isImageTooLarge = isTooLarge;
        });

        if (_isImageTooLarge) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).sizeWarning)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).sizeWarning)),
      );
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 200,
          child: ListView.builder(
            itemCount: 60,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${index + 1} minutes'),
                onTap: () {
                  setState(() {
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

  void _showImagePreview() {
    if (_imageFile == null) return;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.file(
                  File(_imageFile!.path),
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: _deleteImage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePickerWidget() {
    return Column(
      children: [
        GestureDetector(
          onTap: _imageFile == null ? _showImageSourceDialog : _showImagePreview,
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
        if (_isImageTooLarge)
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              S.of(context).sizeWarning,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildNumberInputField({
    required TextEditingController controller,
    required String label,
    bool isDecimal = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      keyboardType: isDecimal
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).requiredField;
        }
        return null;
      },
      textInputAction: TextInputAction.next,
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('${S.of(context).error}: ${snapshot.error}');
        } else {
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
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    _buildNumberInputField(
                      controller: priceController,
                      label: S.of(context).unitPriceLabel,
                      isDecimal: true,
                    ),
                    SizedBox(height: 16.0),
                    _buildNumberInputField(
                      controller: numberOfUnitsController,
                      label: S.of(context).numberOfUnitsLabel,
                    ),
                    SizedBox(height: 16.0),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _showPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
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
                    SizedBox(height: 16.0),
                    _buildImagePickerWidget(),
                    SizedBox(height: 24.0),
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

                          if (_isImageTooLarge) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(S.of(context).sizeWarning)),
                            );
                            return;
                          }

                          setState(() => isProcessing = true);
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

                            bool result = await operationProvider.sell(
                              priceController.text,
                              _imageFile,
                              numberOfUnitsController.text,
                              expiresInController.text,
                              switcher.getValue() ? 1 : 0,
                            );

                            setState(() => isProcessing = false);

                            if (result) {
                              setState(() {
                                priceController.clear();
                                numberOfUnitsController.clear();
                                unitTypeController = null;
                                expiresInController.clear();
                                _imageFile = null;
                                _isImageTooLarge = false;
                                balanceProvider.callToGetBalance();
                              });
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