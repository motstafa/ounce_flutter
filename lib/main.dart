import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ounce/providers/balance_provider.dart';
import 'package:ounce/providers/local_provider.dart';
import 'package:ounce/providers/operation_provider.dart';
import 'package:ounce/providers/operation_tracks_provider.dart';
import 'package:ounce/providers/zone_provider.dart';
import 'package:ounce/screens/home/initial_loading_screen.dart';
import 'package:ounce/screens/welcome_screen.dart';
import 'package:ounce/theme/theme.dart';
import 'firebase_options.dart';
import 'screens/home/delivery_page.dart';
import 'screens/notification_center_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:ounce/providers/auth_provider.dart';
import 'package:ounce/screens/home/trader_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ounce/providers/notification_provider.dart';
import 'services/push_notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';
import 'package:intl/intl.dart';

late SharedPreferences prefs;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final pushNotificationService = PushNotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (e) {
    if (e.code != 'duplicate-app') {
      rethrow; // Only ignore duplicate-app errors
    }
  }
  // Initialize notification service
  await pushNotificationService.init();

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // When app is opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    pushNotificationService.notificationHandler(message);
  });

  // Add this: Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    pushNotificationService.notificationHandler(message);
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => BalanceProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ChangeNotifierProvider(create: (context) => OperationProvider()),
      ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ChangeNotifierProvider(create: (context) => ZoneProvider()),
      ChangeNotifierProvider(create: (context) => OperationTracksProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider()..getNotifications())
    ],
    child: MyApp(navigatorKey: navigatorKey),
  ));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  MyApp({required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      // Keep initial route as '/' which maps to InitialLoadingScreen
      routes: {
        '/': (context) => InitialLoadingScreen(), // Starting point for checking token
        '/welcome': (context) => const WelcomeScreen(), // Welcome screen comes after InitialLoadingScreen if no token
        '/sign-in': (context) => SignInScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/trader': (context) => TraderPage(),
        '/delivery': (context) => DeliveryPage(),
        '/notifications': (context) => NotificationCenterScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: buttonAccentColor,
          secondary: Colors.blue,
          surface: Colors.white,
          background: Colors.white,
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: buttonAccentColor,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: buttonAccentColor,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: buttonAccentColor,
            side: BorderSide(color: buttonAccentColor),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonAccentColor,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Define a top-level named handler which background/terminated messages will call.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  pushNotificationService.notificationHandler(message);
}

bool isArabic() {
  return Intl.getCurrentLocale() == 'ar';
}