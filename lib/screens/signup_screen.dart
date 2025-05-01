import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/screens/signin_screen.dart';
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
  final _formPersonalInfoKey = GlobalKey<FormState>();
  final _formAddressKey = GlobalKey<FormState>();
  final _formLocationKey = GlobalKey<FormState>();
  final _formFinalKey = GlobalKey<FormState>();

  bool agreePersonalData = false;
  int _currentStep = 0;
  bool _obscurePassword = true;

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  XFile? governmentId;
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController prefecture = TextEditingController();
  int? zoneId;
  TextEditingController cityTown = TextEditingController();
  TextEditingController ward = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  TextEditingController building = TextEditingController();
  TextEditingController? floor = TextEditingController();

  // Password validation helpers
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSymbol = false;

  void _checkPasswordStrength(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasLowercase = value.contains(RegExp(r'[a-z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));
      hasSymbol = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // Function to handle image selection
  Future<void> _selectImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920, // Limit the image resolution to save memory
        maxHeight: 1080,
        imageQuality: 90,
      );

      if (pickedImage != null) {
        // Check file size
        final File file = File(pickedImage.path);
        final int fileSize = await file.length();

        if (fileSize > 2 * 1024 * 1024) { // 2MB in bytes
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).governmentIdSizeWarning)),
          );
          return;
        }

        setState(() {
          governmentId = pickedImage;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _formPersonalInfoKey.currentState?.validate() ?? false;
      case 1:
        return _formAddressKey.currentState?.validate() ?? false;
      case 2:
        return _formLocationKey.currentState?.validate() ?? false;
      case 3:
        return _formFinalKey.currentState?.validate() ?? false;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a list of zones
    final zones = {
      0: '',
      1: S.of(context).zone1,
      2: S.of(context).zone2,
    };

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
                    primary: buttonAccentColor,
                  ),
                  textTheme: TextTheme(
                    bodyLarge: TextStyle(
                      color: buttonAccentColor,
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: buttonAccentColor,
                    ),
                  ),
                ),
                child: Stepper(
                  physics: const ClampingScrollPhysics(),
                  controlsBuilder: (BuildContext context, ControlsDetails details) {
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
                    if (_validateCurrentStep()) {
                      if (_currentStep < 3) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        // Final step validation and submission
                        if (_formFinalKey.currentState!.validate() && agreePersonalData) {
                          if (governmentId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(S.of(context).governmentIdRequired)),
                            );
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).processing)),
                          );

                          final floorInt = int.tryParse(floor?.text ?? '') ?? 0;

                          // Perform the asynchronous registration
                          final response = await AuthProvider().register(
                              firstName.text,
                              lastName.text,
                              email.text,
                              password.text,
                              governmentId, // Pass government ID as profile picture
                              phoneNumber.text,
                              null, // No store picture
                              prefecture.text,
                              zoneId ?? 1,
                              cityTown.text,
                              ward.text,
                              streetAddress.text,
                              building.text,
                              floorInt
                          );

                          if (response['success']) {
                            // Registration successful
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(
                                  initialEmail: email.text,
                                  initialPassword: password.text,
                                ),
                              ),
                            );
                          } else {
                            // Show validation errors
                            final errors = response['errors'] as Map<String, dynamic>;
                            errors.forEach((key, value) {
                              final errorMessages = (value as List).join(', ');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$key: $errorMessages')),
                              );
                            });
                          }
                        } else if (!agreePersonalData) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(S.of(context).pleaseAgree)),
                          );
                        }
                      }
                    }
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep -= 1;
                      }
                    });
                  },
                  steps: [
                    // Step 1: Personal Information
                    Step(
                      title: Text(
                        S.of(context).personalInfo,
                        style: const TextStyle(color: Colors.white),
                      ),
                      isActive: _currentStep >= 0,
                      content: Form(
                        key: _formPersonalInfoKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5),
                            // First name field
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            // Last name field
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            // Email field
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleaseEnterEmail;
                                }
                                // Email regex validation
                                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return S.of(context).invalidEmail;
                                }
                                return null;
                              },
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                label: Text(S.of(context).email),
                                hintText: S.of(context).enterEmail,
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            // Password field
                            TextFormField(
                              obscureText: _obscurePassword,
                              obscuringCharacter: '*',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).pleasePass;
                                }
                                if (value.length < 8) {
                                  return S.of(context).invalidPasswordLength;
                                }
                                if (!value.contains(RegExp(r'[A-Z]'))) {
                                  return S.of(context).invalidPasswordUppercase;
                                }
                                if (!value.contains(RegExp(r'[a-z]'))) {
                                  return S.of(context).invalidPasswordLowercase;
                                }
                                if (!value.contains(RegExp(r'[0-9]'))) {
                                  return S.of(context).invalidPasswordNumber;
                                }
                                if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                                  return S.of(context).invalidPasswordSpecial;
                                }
                                return null;
                              },
                              controller: password,
                              onChanged: _checkPasswordStrength,
                              decoration: InputDecoration(
                                label: Text(S.of(context).password),
                                hintText: S.of(context).enterPassword,
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                    color: buttonAccentColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),

                            // Password strength indicators
                            const SizedBox(height: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).passwordRequirements,
                                  style: TextStyle(
                                    color: buttonAccentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _buildPasswordRequirement(S.of(context).minChars, hasMinLength),
                                _buildPasswordRequirement(S.of(context).upperCase, hasUppercase),
                                _buildPasswordRequirement(S.of(context).lowerCase, hasLowercase),
                                _buildPasswordRequirement(S.of(context).numberReq, hasNumber),
                                _buildPasswordRequirement(S.of(context).specialChar, hasSymbol),
                              ],
                            ),

                            const SizedBox(height: 25.0),

                            // Government ID/Passport upload
                            GestureDetector(
                              onTap: _selectImage,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.credit_card,
                                      size: 50,
                                      color: buttonAccentColor,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      S.of(context).uploadGovernmentId,
                                      style: TextStyle(color: buttonAccentColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      S.of(context).governmentIdSizeWarning,
                                      style: TextStyle(
                                        color: buttonAccentColor.withOpacity(0.7),
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (governmentId != null) ...[
                                      const SizedBox(height: 10),
                                      Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: FileImage(File(governmentId!.path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Step 2: Contact Information
                    Step(
                      title: Text(
                        S.of(context).address,
                        style: const TextStyle(color: Colors.white),
                      ),
                      isActive: _currentStep >= 1,
                      content: Form(
                        key: _formAddressKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 25.0),
                            // Phone Number
                            InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                phoneNumber.text = number.phoneNumber ?? '';
                              },
                              onInputValidated: (bool isValid) {
                                // Handle phone number validation
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return S.of(context).phoneRequired;
                                }
                                return null;
                              },
                              selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle: TextStyle(color: buttonAccentColor),
                              initialValue: PhoneNumber(isoCode: 'LB'),
                              textFieldController: phoneNumber,
                              inputDecoration: InputDecoration(
                                labelText: S.of(context).phone,
                                hintText: S.of(context).enterPhone,
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            // Zone selector
                            DropdownButtonFormField<int>(
                              value: zoneId,
                              validator: (value) {
                                if (value == null || value == 0) {
                                  return S.of(context).zoneRequired;
                                }
                                return null;
                              },
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Step 3: Location Information
                    Step(
                      title: Text(
                        S.of(context).locationInformation,
                        style: const TextStyle(color: Colors.white),
                      ),
                      isActive: _currentStep >= 2,
                      content: Form(
                        key: _formLocationKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
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
                              controller: ward,
                              decoration: InputDecoration(
                                labelText: S.of(context).wardLabel,
                                hintText: S.of(context).enterWard,
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Step 4: Final Details
                    Step(
                      title: Text(
                        S.of(context).locationInformation,
                        style: const TextStyle(color: Colors.white),
                      ),
                      isActive: _currentStep >= 3,
                      content: Form(
                        key: _formFinalKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 15),

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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            // Floor
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                                hintStyle: TextStyle(color: buttonAccentColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: buttonAccentColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),

                            // Terms agreement
                            Row(
                              children: [
                                Checkbox(
                                  value: agreePersonalData,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      agreePersonalData = value!;
                                    });
                                  },
                                  activeColor: buttonAccentColor,
                                ),
                                Expanded(
                                  child: Text(
                                    '${S.of(context).agreeProcessingText} ${S.of(context).personalDataText}',
                                    style: TextStyle(
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

  // Helper method to build password requirement indicator
  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.check_circle_outline,
            color: isMet ? Colors.green : Colors.grey,
            size: 16,
          ),
          SizedBox(width: 8),
          Text(
            requirement,
            style: TextStyle(
              color: isMet ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}