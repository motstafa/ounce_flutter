import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:provider/provider.dart';
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
  bool agreePersonalData = false;
  int _currentStep = 0;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  XFile? profilePicture;
  TextEditingController storeName = TextEditingController();
  TextEditingController  phoneNumber= TextEditingController();
  XFile? storePicture;
  TextEditingController prefecture = TextEditingController();
  int? zoneId;
  TextEditingController cityTown = TextEditingController();
  TextEditingController ward = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController building = TextEditingController();
  TextEditingController? floor = TextEditingController();

  // Function to handle image selection
  Future<void> _selectImage(bool profile) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (profile) {
          profilePicture = pickedImage;
        } else {
          storePicture = pickedImage;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set a default value if not already selected
    // Define a list of zones
    final zones = {
      0: '',
      1: S.of(context).zone1,
      2: S.of(context).zone2,
    }; // Add your zones here
    // String? selectedZoneKey;
    var selectedZoneKey = zones.keys.first;
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    return CustomScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: buttonAccentColor, // Change primary color
                  ),
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(
                      color: buttonAccentColor, // Set the default text color
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          buttonAccentColor, // Change outline button color
                    ),
                  ),
                ),
                child: Stepper(
                  physics: const ClampingScrollPhysics(),
                  controlsBuilder:
                      (BuildContext context, ControlsDetails details) {
                    return Row(
                      children: <Widget>[
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(S.of(context).cancel),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonAccentColor),
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
                          child: Text(_currentStep == 3
                              ? S.of(context).submitButtonLabel
                              : S.of(context).next),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                buttonAccentColor),
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
                  onStepContinue: () async {
                    if (_currentStep < 3) {
                      setState(() {
                        _currentStep += 1;
                      });
                    } else {
                      // Validate and submit the form outside of setState
                      if (_formSignupKey.currentState!.validate() &&
                          agreePersonalData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).processing),
                          ),
                        );
                        var floorInt = int.tryParse(floor?.text ?? '') ?? 0;
                        // Perform the asynchronous operation without calling setState
                        await AuthProvider().register(
                            firstName.text,
                            lastName.text,
                            email.text,
                            password.text,
                            profilePicture,
                            storeName.text,
                            phoneNumber.text,
                            storePicture,
                            prefecture.text,
                            zoneId ?? 1,
                            cityTown.text,
                            ward.text,
                            streetAddress.text,
                            building.text,
                            floorInt);
                        // After the async operation, update the state if needed
                        setState(() {
                          // Update your state here if necessary after the async call
                        });
                      } else if (!agreePersonalData) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.of(context).pleaseAgree),
                          ),
                        );
                      }
                    }
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
                            const SizedBox(height: 5),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseFirstName;
                                }
                                return null;
                              },
                              controller: firstName,
                              decoration: InputDecoration(
                                label: Text(S.of(context).firstName),
                                hintText: S.of(context).enterFirstName,
                                hintStyle: TextStyle(
                                  color: buttonAccentColor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseLastName;
                                }
                                return null;
                              },
                              controller: lastName,
                              decoration: InputDecoration(
                                label: Text(S.of(context).lastName),
                                hintText: S.of(context).enterLastName,
                                hintStyle: TextStyle(
                                  color: buttonAccentColor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
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
                              controller: email,
                              decoration: InputDecoration(
                                label: Text(S.of(context).email),
                                hintText: S.of(context).enterEmail,
                                hintStyle: TextStyle(
                                  color: buttonAccentColor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
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
                              controller: password,
                              decoration: InputDecoration(
                                label: Text(S.of(context).password),
                                hintText: S.of(context).enterPassword,
                                hintStyle: TextStyle(
                                  color: buttonAccentColor,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            // Profile Picture
                            GestureDetector(
                              onTap: () async {
                                await _selectImage(true);
                              },
                              // Call _selectImage function when tapped
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        buttonAccentColor, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: profilePicture == null
                                    ? Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          S.of(context).uploadProfile,
                                          style: TextStyle(
                                            color: buttonAccentColor,
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        File(profilePicture!.path),
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
                          // Store Name
                          const SizedBox(height: 5),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseStoreName;
                              }
                              return null;
                            },
                            controller: storeName,
                            decoration: InputDecoration(
                              labelText: S.of(context).storeName,
                              hintText: S.of(context).enterStoreName,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          // store picture
                          GestureDetector(
                            onTap: () async {
                              await _selectImage(false);
                            },
                            // Call _selectImage function when tapped
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: storePicture == null
                                  ? Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        S.of(context).storePic,
                                        style: TextStyle(
                                          color: buttonAccentColor,
                                        ),
                                      ),
                                    )
                                  : Image.file(
                                      File(storePicture!.path),
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
                         // Correct extraction of phone number
                            },
                            onInputValidated: (bool isValid) {
                              // Handle phone number validation
                              // You can set a state or give feedback based on the validity
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle:
                                TextStyle(color: buttonAccentColor),
                            initialValue: PhoneNumber(isoCode: 'LB'),
                            // Initial value with Lebanon code
                            textFieldController: phoneNumber,
                            inputDecoration: InputDecoration(
                              labelText: S.of(context).phone,
                              hintText: S.of(context).enterPhone,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Step(
                      title: Text(
                        S.of(context).locationInformation,
                        style: const TextStyle(color: Colors.white),
                      ),
                      isActive: _currentStep == 2,
                      content: Column(
                        children: [
                          const SizedBox(height: 5),
                          // Widget for the dropdown menu
                          DropdownButtonFormField<int>(
                            value: zoneId,
                            onChanged: (int? newValue) {
                              setState(() {
                                zoneId = newValue;
                              });
                            },
                            items: zones.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value ?? ''),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: S.of(context).zone,
                              hintText: S.of(context).selectZone,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
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
                            controller: prefecture,
                            decoration: InputDecoration(
                              labelText: S.of(context).prefecture,
                              hintText: S.of(context).enterPrefecture,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
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
                            controller: cityTown,
                            decoration: InputDecoration(
                              labelText: S.of(context).city,
                              hintText: S.of(context).enterCity,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: Text(
                        S.of(context).locationInformation,
                        style: const TextStyle(color: Colors.white),
                      ),
                      isActive: _currentStep == 3,
                      content: Column(
                        children: [
                          const SizedBox(height: 15),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseWard;
                              }
                              return null;
                            },
                            controller: ward,
                            decoration: InputDecoration(
                              labelText: S.of(context).wardLabel,
                              hintText: S.of(context).enterWard,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
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
                            controller: streetAddress,
                            decoration: InputDecoration(
                              labelText: S.of(context).streetAddressLabel,
                              hintText: S.of(context).enterStreetAddress,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
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
                            controller: building,
                            decoration: InputDecoration(
                              labelText: S.of(context).buildingLabel,
                              hintText: S.of(context).enterBuilding,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),

                          // Floor
                          TextFormField(
                            keyboardType: TextInputType.number,
                            // Set keyboard type to number
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseFloor;
                              }
                              return null;
                            },
                            controller: floor,
                            decoration: InputDecoration(
                              labelText: S.of(context).floorLabel,
                              hintText: S.of(context).enterFloor,
                              hintStyle: TextStyle(
                                color: buttonAccentColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      buttonAccentColor, // Default border color
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          // i agree to the processing
                          Row(
                            children: [
                              Expanded(
                                child: Checkbox(
                                  value: agreePersonalData,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agreePersonalData = value!;
                                    });
                                  },
                                  activeColor: buttonAccentColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  S.of(context).agreeProcessingText,
                                  style: TextStyle(
                                    color: buttonAccentColor,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  S.of(context).personalDataText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: buttonAccentColor,
                                  ),
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
