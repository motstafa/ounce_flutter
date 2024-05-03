import 'package:flutter/material.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/screens/signin_screen.dart';
import 'package:ounce/screens/signup_screen.dart';
import 'package:ounce/screens/home/main_page.dart';
import 'package:ounce/screens/home/buy_page.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/providers/cart_provider.dart';
import 'package:ounce/providers/product_provider.dart';
import 'package:ounce/providers/wishlist_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs ;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(providers:[
        ChangeNotifierProvider(create: (context) =>AuthProvider()),
        ChangeNotifierProvider(create: (context)=>OperationProvider())
      ],
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => WelcomePage(),
          '/sign-in': (context) => SignInScreen(),
          '/sign-up': (context) => SignUpScreen(),
          '/home': (context) => MainPage(),
        },
      ),
    );
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
              child: Text(
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
              child: Text(
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

