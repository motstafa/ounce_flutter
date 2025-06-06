import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ounce/main.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/screens/home/delivery_page.dart';
import 'package:ounce/screens/home/trader_page.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '/screens/signup_screen.dart';
import '/widgets/custom_scaffold.dart';
import '../theme/theme.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/constants/constants.dart';

class SignInScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const SignInScreen({Key? key, this.initialEmail, this.initialPassword})
      : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.initialEmail);
    passwordController = TextEditingController(text: widget.initialPassword);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    BalanceProvider balanceProvider =
        Provider.of<BalanceProvider>(context, listen: false);

    handleSignIn() async {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      // Perform login and await response
      bool loginSuccessful = await authProvider.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (loginSuccessful) {
        // Use our improved method to safely get the FCM token
        String? fcmToken = await pushNotificationService.getValidFCMToken();

        if (fcmToken != null) {
          try {
            await Constants().sendTokenToBackend(fcmToken);
            print('Successfully sent FCM token to backend');
          } catch (e) {
            print('Error sending token to backend: $e');
            // Continue with login process even if token sending fails
          }
        } else {
          print('Could not retrieve FCM token, continuing without it');
          // Continue with login process without FCM token
        }

        int? role = prefs.getInt('role'); // Retrieve the stored role

        // Once the token is sent, check for role and navigate
        if (role == Constants.userRoles['trader']) {
          // If user is a trader, fetch the balance before navigating
          bool balanceFetched = await balanceProvider.callToGetBalance();
          if (balanceFetched) {
            setState(() {
              isLoading = false; // Set loading to false
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TraderPage()),
            );
          } else {
            setState(() {
              isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to fetch balance.'),
              ),
            );
          }
        } else {
          // If user is not a trader, navigate directly to DeliveryPage
          setState(() {
            isLoading = false; // Set loading to false
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DeliveryPage()),
          );
        }
      } else {
        // If login fails, show error message
        setState(() {
          isLoading = false; // Set loading to false
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong username or password', textAlign: TextAlign.center),
          ),
        );
      }
    }

    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).welcome,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: buttonAccentColor,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).emailValidator;
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                          label: Text(S.of(context).email),
                          hintText: S.of(context).enterEmail,
                          hintStyle: TextStyle(
                            color: buttonAccentColor,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: buttonAccentColor, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: buttonAccentColor, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: '*',
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).pleasePass;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: Text(S.of(context).password),
                          hintText: S.of(context).enterPassword,
                          hintStyle: TextStyle(
                            color: buttonAccentColor,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: buttonAccentColor, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: buttonAccentColor, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: buttonAccentColor,
                              ),
                              Text(
                                S.of(context).rememberMe,
                                style: TextStyle(
                                  color: buttonAccentColor,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            child: Text(
                              S.of(context).forgetPassword,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: buttonAccentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formSignInKey.currentState!.validate() &&
                                rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).processing),
                                ),
                              );
                              handleSignIn();
                            } else if (!rememberPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(S.of(context).pleaseAgree)),
                              );
                            }
                          },
                          child: Text(S.of(context).signin),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      // don't have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).dontHaveAccount,
                            style: TextStyle(
                              color: buttonAccentColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              S.of(context).signUp,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: buttonFocusedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
