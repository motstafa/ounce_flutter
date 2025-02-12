import 'package:flutter/material.dart';

double defaultMargin = 30;

Color primaryColor = Color(0XFF6C5ECF);
Color secondaryColor = Color(0XFF38ABBE);
Color alertColor = Color(0XFFED6363);
Color priceColor = Color(0XFF2C96f1);
Color backgroundColor1 = Color(0XFF1F1D2B);
Color backgroundColor2 = Color(0XFF2B2937);
Color backgroundColor3 = Color(0XFF242231);
Color backgroundColor4 = Color(0XFF252836);
Color backgroundColor5 = Color(0XFF282844);
Color backgroundColor6 = Color(0XFFECEDEF);
Color primaryTextColor = Color(0XFFF1F0F2);
Color secondaryTextColor = Color(0XFF999999);
Color subtitleColor = Color(0XFF504F5E);
Color transparentColor = Colors.transparent;
Color blackColor = Color(0xff2E2E2E);

Color? GoldColor= Color.lerp(Color(0xFFd1b071), Color(0xFFff991b), 0 / 3); // RGB values for gold color
Color buttonFocusedColor = Color(0xFFff991b);
Color buttonAccentColor = Color(0xFFc5a567);
Color GoldInBetween = Color(0xFFEC9D34);
Color BoxBackground = Color(0xFF2e2d2c);
List<Color> GoldButton = [Color(0xFFfefdf3),Color(0xFF926300),Color(0xFFfefdf3)];



FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF416FDF),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF6EAEE7),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFCFDF6),
  onBackground: Color(0xFF1A1C18),
  shadow: Color(0xFF000000),
  outlineVariant: Color(0xFFC2C8BC),
  surface: Color(0xFFF9FAF3),
  onSurface: Color(0xFF1A1C18),
);

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: lightColorScheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        lightColorScheme.primary, // Slightly darker shade for the button
      ),
      foregroundColor:
      MaterialStateProperty.all<Color>(Colors.white), // text color
      elevation: MaterialStateProperty.all<double>(5.0), // shadow
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Adjust as needed
        ),
      ),
    ),
  ),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,
);