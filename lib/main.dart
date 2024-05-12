import 'package:flutter/material.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import 'package:ounce/theme/theme.dart';
import 'screens/home/delivery_page.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/screens/home/trader_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ounce/providers/notification_provider.dart';
import 'package:sizer/sizer.dart';

late SharedPreferences prefs ;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return MyApp();
      },
    ),
  );
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return

      MultiProvider(providers:[
        ChangeNotifierProvider(create: (context) =>AuthProvider()),
        ChangeNotifierProvider(create: (context) =>BalanceProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context)=>OperationProvider()),
        ChangeNotifierProvider(create: (context)=>OperationTracksProvider())
      ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => WelcomePage(),
          '/sign-in': (context) => SignInScreen(),
          '/sign-up': (context) => SignUpScreen(),
          '/trader': (context) => TraderPage(),
          '/delivery':(context)=>DeliveryPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme(
            primary: buttonAccentColor, // Your custom color
            secondary: Colors.blue, // Choose a secondary color
            surface: Colors.white,
            background: Colors.white,
            error: Colors.red,
            onPrimary: Colors.white, // Text color on top of the primary color
            onSecondary: Colors.white, // Text color on top of the secondary color
            onSurface: buttonAccentColor,
            onBackground: buttonAccentColor,
            onError: Colors.white,
            brightness: Brightness.light, // Choose Brightness.light or Brightness.dark
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(
              color:buttonAccentColor, // Set the default text color
            ),
            // Add other text styles if needed
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              backgroundColor: buttonAccentColor, // Change text color of the button
              side: BorderSide(color: buttonAccentColor), // Change border color
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonAccentColor, // Change background color of the button
              foregroundColor: Colors.white, // Change text color of the button
            ),
          ),
          // Add other theme properties if needed
        ),

      ));
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Add navigation to your sign-up page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child:const Text(
                'Sign Up',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add navigation to your sign-in page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

