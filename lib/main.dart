import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import 'package:ounce/theme/theme.dart';
import 'firebase_options.dart';
import 'screens/home/delivery_page.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/screens/home/trader_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ounce/providers/notification_provider.dart';

late SharedPreferences prefs;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => BalanceProvider()),
          ChangeNotifierProvider(create: (context) => NotificationProvider()),
          ChangeNotifierProvider(create: (context) => OperationProvider()),
          ChangeNotifierProvider(create: (context) => OperationTracksProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => SignInScreen(),
            '/sign-in': (context) => SignInScreen(),
            '/sign-up': (context) => SignUpScreen(),
            '/trader': (context) => TraderPage(),
            '/delivery': (context) => DeliveryPage(),
          },
          theme: ThemeData(
            colorScheme: ColorScheme(
              primary: buttonAccentColor,
              // Your custom color
              secondary: Colors.blue,
              // Choose a secondary color
              surface: Colors.white,
              background: Colors.white,
              error: Colors.red,
              onPrimary: Colors.white,
              // Text color on top of the primary color
              onSecondary: Colors.white,
              // Text color on top of the secondary color
              onSurface: buttonAccentColor,
              onBackground: buttonAccentColor,
              onError: Colors.white,
              brightness: Brightness
                  .light, // Choose Brightness.light or Brightness.dark
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(
                color: buttonAccentColor, // Set the default text color
              ),
              // Add other text styles if needed
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                backgroundColor: buttonAccentColor,
                // Change text color of the button
                side:
                    BorderSide(color: buttonAccentColor), // Change border color
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonAccentColor,
                // Change background color of the button
                foregroundColor:
                    Colors.white, // Change text color of the button
              ),
            ),
            // Add other theme properties if needed
          ),
        ));
  }
}

