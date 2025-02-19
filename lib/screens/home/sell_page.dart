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
  final SwitchButton switcher=SwitchButton();

  TextEditingController priceController = TextEditingController();
  String? unitTypeController;
  TextEditingController numberOfUnitsController = TextEditingController();

  // Assuming this is your static list for unit types
  final List<String> unitTypes = ['swiss', 'italy', 'england'];
  bool isLoading = false; // Track loading state

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
    BalanceProvider balanceProvider = Provider.of<BalanceProvider>(context, listen: false);
    balanceProvider.callToGetBalance();

    return FutureBuilder<int>(
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
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(S.of(context).sellPageTitle, style: TextStyle(color: buttonAccentColor)),
              ),
              body: Center(
                child: Text(S.of(context).notEnoughBalanceMessage, style: TextStyle(color: Colors.white, fontSize: 18)),
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
                      decoration: InputDecoration(labelText: S.of(context).unitPriceLabel, border: OutlineInputBorder()),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      controller: priceController,
                    ),
                    SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      value: unitTypeController,
                      decoration: InputDecoration(labelText: S.of(context).unitTypeLabel, border: OutlineInputBorder()),
                      items: unitTypes.map((String value) {
                        return DropdownMenuItem(value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          unitTypeController = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(labelText: S.of(context).numberOfUnitsLabel, border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      controller: numberOfUnitsController,
                    ),
                    SizedBox(height: 16.0),
                    switcher,
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                        child: _imageFile == null
                            ? Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(S.of(context).uploadOncePictureLabel),
                        )
                            : Image.network(_imageFile!.path, fit: BoxFit.cover, width: 50, height: 50),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null // Disable button while loading
                          : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (sellBalance == 0) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(S.of(context).insufficientBalanceTitle),
                                content: Text(S.of(context).insufficientBalanceMessage),
                                actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).okButtonLabel))],
                              ),
                            );
                          } else {
                            final operationProvider = Provider.of<OperationProvider>(context, listen: false);
                            setState(() => isLoading = true); // Show loading indicator

                            bool result = await operationProvider.sell(
                              priceController.text,
                              unitTypeController!,
                              _imageFile,
                              numberOfUnitsController.text,
                              switcher.getValue() ? 1 : 0,
                            );

                            setState(() => isLoading = false); // Hide loading indicator

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
                                builder: (context) => AlertDialog(
                                  title: Text(S.of(context).insufficientBalanceTitle),
                                  content: Text(S.of(context).insufficientBalanceMessage),
                                  actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(S.of(context).okButtonLabel))],
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: isLoading
                          ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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


class SwitchButton extends StatefulWidget{
   bool? isRetail;

   SwitchButton({Key? key, this.isRetail}) : super(key: key);

  @override
  _SwitchWidgetState createState()=> _SwitchWidgetState();

   bool getValue(){
     return isRetail ?? false;
   }
}

class _SwitchWidgetState extends State<SwitchButton>{
  @override
  Widget build(BuildContext context) {
   return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            S.of(context).allowRetail,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(width: 10),
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
