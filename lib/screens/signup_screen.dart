import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../generated/l10n.dart';
import '/theme/theme.dart';
import '/widgets/custom_scaffold.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  int _currentStep = 0;

  // Define _imageFile variable here
  XFile? _imageFile;

  // Function to handle image selection
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

// Define a list of zones
  List<String> zones = ['Zone A', 'Zone B', 'Zone C']; // Add your zones here

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Theme(
                data: ThemeData(
                  colorScheme: const ColorScheme.light(
                    primary: Colors.blue, // Change primary color
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(
                      color: Colors.black87, // Set the default text color
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          Colors.blue, // Change outline button color
                    ),
                  ),
                ),
                child: Stepper(
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(S.of(context).cancel),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 80),
                        // Adjust the width as needed for the space between buttons
                        TextButton(
                          onPressed: details.onStepContinue,
                          child: Text(S.of(context).next),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                  currentStep: _currentStep,
                  onStepContinue: () {
                    setState(() {
                      if (_currentStep < 1) {
                        _currentStep += 1;
                      } else {
                        // Handle submitting the form or any other action on last step
                        if (_formSignupKey.currentState!.validate() &&
                            agreePersonalData) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).processing),
                            ),
                          );
                        } else if (!agreePersonalData) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.of(context).pleaseAgree),
                            ),
                          );
                        }
                      }
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep >= 1) {
                        _currentStep -= 1;
                      }
                    });
                  },
                  steps: [
                    Step(
                      title: Text(
                        S.of(context).personalInfo,
                        style: const TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                      isActive: _currentStep == 0,
                      content: Form(
                        key: _formSignupKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseFullName;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(S.of(context).fullName),
                                hintText: S.of(context).enterFullName,
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            // email
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterEmail;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(S.of(context).email),
                                hintText: S.of(context).enterEmail,
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            // password
                            TextFormField(
                              obscureText: true,
                              obscuringCharacter: '*',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleasePass;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: Text(S.of(context).password),
                                hintText: S.of(context).enterPassword,
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            // Profile Picture
                            GestureDetector(
                              onTap: _selectImage,
                              // Call _selectImage function when tapped
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _imageFile == null
                                    ? Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          S.of(context).uploadProfile,
                                          style: const TextStyle(
                                            color: Colors.black26,
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        File(_imageFile!.path),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: Text(
                        S.of(context).address,
                        style: const TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                      isActive: _currentStep == 1,
                      content: Column(
                        children: [
                          const SizedBox(height: 10),
                          // Store Name
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseStoreName;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).storeName,
                              hintText: S.of(context).enterStoreName,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          // store picture
                          GestureDetector(
                            onTap: _selectImage,
                            // Call _selectImage function when tapped
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _imageFile == null
                                  ? Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        S.of(context).storePic,
                                        style: const TextStyle(
                                          color: Colors.black26,
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Phone Number
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              // Handle phone number input changes
                            },
                            onInputValidated: (bool value) {
                              // Handle phone number validation
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            initialValue: PhoneNumber(isoCode: 'LB'),
                            // Set initial country code
                            textFieldController: TextEditingController(),
                            inputDecoration: InputDecoration(
                              labelText: S.of(context).phone,
                              hintText: S.of(context).enterPhone,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Widget for the dropdown menu
                          DropdownButtonFormField<String>(
                            value: zones[0],
                            onChanged: (String? newValue) {
                              setState(() {
                                zones[0] = newValue!;
                              });
                            },
                            items: zones
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: S.of(context).zone,
                              hintText: S.of(context).selectZone,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Prefecture
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleasePrefecture;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).prefecture,
                              hintText: S.of(context).enterPrefecture,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // City_Town
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseCity;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).city,
                              hintText: S.of(context).enterCity,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Ward
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseWard;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).wardLabel,
                              hintText: S.of(context).enterWard,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Street Address
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseStreetAddress;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).streetAddressLabel,
                              hintText: S.of(context).enterStreetAddress,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Building
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseBuilding;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).buildingLabel,
                              hintText: S.of(context).enterBuilding,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Floor
                          TextFormField(
                            keyboardType: TextInputType
                                .number, // Set keyboard type to number
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseFloor;
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: S.of(context).floorLabel,
                              hintText: S.of(context).enterFloor,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black12, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          // i agree to the processing
                          Row(
                            children: [
                              Checkbox(
                                value: agreePersonalData,
                                onChanged: (bool? value) {
                                  setState(() {
                                    agreePersonalData = value!;
                                  });
                                },
                                activeColor: lightColorScheme.primary,
                              ),
                              Text(
                                S.of(context).agreeProcessingText,
                                style: const TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                S.of(context).personalDataText,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
