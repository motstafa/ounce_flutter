// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `wrong username or password`
  String get loginError {
    return Intl.message(
      'wrong username or password',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `welcome back`
  String get welcome {
    return Intl.message(
      'Welcome Back',
      name: 'Welcome',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'Email',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// `enter email`
  String get enterEmail {
    return Intl.message(
      'Enter Email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `please enter Email`
  String get emailValidator {
    return Intl.message(
      'please enter Email',
      name: 'emailValidator',
      desc: '',
      args: [],
    );
  }

  /// `please enter Password`
  String get pleasePass {
    return Intl.message(
      'please enter Password',
      name: 'pleasePass',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get rememberMe {
    return Intl.message(
      'Remember me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password?`
  String get forgetPassword {
    return Intl.message(
      'Forget Password?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Processing Data`
  String get processing {
    return Intl.message(
      'Processing Data',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Please agree to the processing of personal data`
  String get pleaseAgree {
    return Intl.message(
      'Please agree to the processing of personal data',
      name: 'pleaseAgree',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signin {
    return Intl.message(
      'Sign In',
      name: 'signin',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up With`
  String get signUpWith {
    return Intl.message(
      'Sign Up With',
      name: 'signUpWith',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personalInfo {
    return Intl.message(
      'Personal Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Full Name`
  String get pleaseFullName {
    return Intl.message(
      'Please enter Full Name',
      name: 'pleaseFullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Full Name`
  String get enterFullName {
    return Intl.message(
      'Enter Full Name',
      name: 'enterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter Email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Upload Profile Picture`
  String get uploadProfile {
    return Intl.message(
      'Upload Profile Picture',
      name: 'uploadProfile',
      desc: '',
      args: [],
    );
  }

  /// `Address Info`
  String get address {
    return Intl.message(
      'Address Info',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Store Name`
  String get pleaseStoreName {
    return Intl.message(
      'Please enter Store Name',
      name: 'pleaseStoreName',
      desc: '',
      args: [],
    );
  }

  /// `Store Name`
  String get storeName {
    return Intl.message(
      'Store Name',
      name: 'storeName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Store Name`
  String get enterStoreName {
    return Intl.message(
      'Enter Store Name',
      name: 'enterStoreName',
      desc: '',
      args: [],
    );
  }

  /// `Upload Store Picture`
  String get storePic {
    return Intl.message(
      'Upload Store Picture',
      name: 'storePic',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone Number`
  String get enterPhone {
    return Intl.message(
      'Enter Phone Number',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Zone`
  String get zone {
    return Intl.message(
      'Zone',
      name: 'zone',
      desc: '',
      args: [],
    );
  }

  /// `Select Zone`
  String get selectZone {
    return Intl.message(
      'Select Zone',
      name: 'selectZone',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Prefecture`
  String get pleasePrefecture {
    return Intl.message(
      'Please enter Prefecture',
      name: 'pleasePrefecture',
      desc: '',
      args: [],
    );
  }

  /// `Prefecture`
  String get prefecture {
    return Intl.message(
      'Prefecture',
      name: 'prefecture',
      desc: '',
      args: [],
    );
  }

  /// `Enter Prefecture`
  String get enterPrefecture {
    return Intl.message(
      'Enter Prefecture',
      name: 'enterPrefecture',
      desc: '',
      args: [],
    );
  }

  /// `Please enter City Or Town`
  String get pleaseCity {
    return Intl.message(
      'Please enter City Or Town',
      name: 'pleaseCity',
      desc: '',
      args: [],
    );
  }

  /// `City Or Town`
  String get city {
    return Intl.message(
      'City Or Town',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Enter City Or Town`
  String get enterCity {
    return Intl.message(
      'Enter City Or Town',
      name: 'enterCity',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Ward`
  String get pleaseWard {
    return Intl.message(
      'Please enter Ward',
      name: 'pleaseWard',
      desc: '',
      args: [],
    );
  }

  /// `Ward`
  String get wardLabel {
    return Intl.message(
      'Ward',
      name: 'wardLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter Ward`
  String get enterWard {
    return Intl.message(
      'Enter Ward',
      name: 'enterWard',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Street Address`
  String get pleaseStreetAddress {
    return Intl.message(
      'Please enter Street Address',
      name: 'pleaseStreetAddress',
      desc: '',
      args: [],
    );
  }

  /// `Street Address`
  String get streetAddressLabel {
    return Intl.message(
      'Street Address',
      name: 'streetAddressLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter Street Address`
  String get enterStreetAddress {
    return Intl.message(
      'Enter Street Address',
      name: 'enterStreetAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Building`
  String get pleaseBuilding {
    return Intl.message(
      'Please enter Building',
      name: 'pleaseBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Building`
  String get buildingLabel {
    return Intl.message(
      'Building',
      name: 'buildingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter Building`
  String get enterBuilding {
    return Intl.message(
      'Enter Building',
      name: 'enterBuilding',
      desc: '',
      args: [],
    );
  }

  /// `Please enter Floor`
  String get pleaseFloor {
    return Intl.message(
      'Please enter Floor',
      name: 'pleaseFloor',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floorLabel {
    return Intl.message(
      'Floor',
      name: 'floorLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter Floor`
  String get enterFloor {
    return Intl.message(
      'Enter Floor',
      name: 'enterFloor',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the processing of`
  String get agreeProcessingText {
    return Intl.message(
      'I agree to the processing of',
      name: 'agreeProcessingText',
      desc: '',
      args: [],
    );
  }

  /// `Personal data`
  String get personalDataText {
    return Intl.message(
      'Personal data',
      name: 'personalDataText',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notification {
    return Intl.message(
      'Notifications',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Details`
  String get deliveryDetailsTitle {
    return Intl.message(
      'Delivery Details',
      name: 'deliveryDetailsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameLabel {
    return Intl.message(
      'Name',
      name: 'nameLabel',
      desc: '',
      args: [],
    );
  }

  /// `estimated time to seller`
  String get estimatedTimeToSellerHint {
    return Intl.message(
      'estimated time to seller',
      name: 'estimatedTimeToSellerHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter estimated time to seller`
  String get pleaseEnterEstimatedTimeToSeller {
    return Intl.message(
      'Please enter estimated time to seller',
      name: 'pleaseEnterEstimatedTimeToSeller',
      desc: '',
      args: [],
    );
  }

  /// `estimated time to buyer`
  String get estimatedTimeToBuyerHint {
    return Intl.message(
      'estimated time to buyer',
      name: 'estimatedTimeToBuyerHint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter estimated time to buyer`
  String get pleaseEnterEstimatedTimeToBuyer {
    return Intl.message(
      'Please enter estimated time to buyer',
      name: 'pleaseEnterEstimatedTimeToBuyer',
      desc: '',
      args: [],
    );
  }

  /// `Move to In-progress`
  String get moveToInProgressButton {
    return Intl.message(
      'Move to In-progress',
      name: 'moveToInProgressButton',
      desc: '',
      args: [],
    );
  }

  /// `Agree to move to completed`
  String get agreeToMoveToCompletedText {
    return Intl.message(
      'Agree to move to completed',
      name: 'agreeToMoveToCompletedText',
      desc: '',
      args: [],
    );
  }

  /// `Move to Completed`
  String get moveToCompletedButton {
    return Intl.message(
      'Move to Completed',
      name: 'moveToCompletedButton',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pendingTab {
    return Intl.message(
      'Pending',
      name: 'pendingTab',
      desc: '',
      args: [],
    );
  }

  /// `In-progress`
  String get inProgressTab {
    return Intl.message(
      'In-progress',
      name: 'inProgressTab',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completedTab {
    return Intl.message(
      'Completed',
      name: 'completedTab',
      desc: '',
      args: [],
    );
  }

  /// `Buy Page`
  String get buyPageTitle {
    return Intl.message(
      'Buy Page',
      name: 'buyPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Operation Number`
  String get operationNumberLabel {
    return Intl.message(
      'Operation Number',
      name: 'operationNumberLabel',
      desc: '',
      args: [],
    );
  }

  /// `Number Of Ounces`
  String get numberOfOuncesLabel {
    return Intl.message(
      'Number Of Ounces',
      name: 'numberOfOuncesLabel',
      desc: '',
      args: [],
    );
  }

  /// `Type Of Ounces`
  String get typeOfOuncesLabel {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get totalPriceLabel {
    return Intl.message(
      'Total Price',
      name: 'totalPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Date of Operation`
  String get dateOfOperationLabel {
    return Intl.message(
      'Date of Operation',
      name: 'dateOfOperationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Buy Button`
  String get buyButtonText {
    return Intl.message(
      'Buy Button',
      name: 'buyButtonText',
      desc: '',
      args: [],
    );
  }

  /// `number of ounces`
  String get numberOfOuncesDialogLabel {
    return Intl.message(
      'number of ounces',
      name: 'numberOfOuncesDialogLabel',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buyDialogButtonText {
    return Intl.message(
      'Buy',
      name: 'buyDialogButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Operations Progress`
  String get operationsProgressPageTitle {
    return Intl.message(
      'Operations Progress',
      name: 'operationsProgressPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeLabel {
    return Intl.message(
      'Home',
      name: 'homeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileLabel {
    return Intl.message(
      'Profile',
      name: 'profileLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sell Page`
  String get sellPageTitle {
    return Intl.message(
      'Sell Page',
      name: 'sellPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `You do not have enough balance to sell items.`
  String get notEnoughBalanceMessage {
    return Intl.message(
      'You do not have enough balance to sell items.',
      name: 'notEnoughBalanceMessage',
      desc: '',
      args: [],
    );
  }

  /// `Unit Price`
  String get unitPriceLabel {
    return Intl.message(
      'Unit Price',
      name: 'unitPriceLabel',
      desc: '',
      args: [],
    );
  }

  /// `Unit Type`
  String get unitTypeLabel {
    return Intl.message(
      'Unit Type',
      name: 'unitTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Number of Units`
  String get numberOfUnitsLabel {
    return Intl.message(
      'Number of Units',
      name: 'numberOfUnitsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Upload Once's Picture`
  String get uploadOncePictureLabel {
    return Intl.message(
      'Upload Once\'s Picture',
      name: 'uploadOncePictureLabel',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient Balance`
  String get insufficientBalanceTitle {
    return Intl.message(
      'Insufficient Balance',
      name: 'insufficientBalanceTitle',
      desc: '',
      args: [],
    );
  }

  /// `You do not have enough balance to sell items.`
  String get insufficientBalanceMessage {
    return Intl.message(
      'You do not have enough balance to sell items.',
      name: 'insufficientBalanceMessage',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get okButtonLabel {
    return Intl.message(
      'OK',
      name: 'okButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submitButtonLabel {
    return Intl.message(
      'Submit',
      name: 'submitButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sellLabel {
    return Intl.message(
      'Sell',
      name: 'sellLabel',
      desc: '',
      args: [],
    );
  }

  static String operationStatus(String key) {
    final Map<String, Map<String, String>> localizedStrings = {
      'en': {
        "canceled": "Canceled",
        "done": "Done",
        "in progress": "In Progress",
        "pending": "Pending",
        "failed": "Failed",
        "paused": "Paused"
      },
      'ar': {
        "canceled": "تم الإلغاء",
        "done": "تم",
        "in progress": "قيد التقدم",
        "pending": "قيد الانتظار",
        "failed": "فشل",
        "paused": "متوقف"
      }
    };

    final locale = Intl.getCurrentLocale();

    if (localizedStrings.containsKey(locale)) {
      final localizedMap = localizedStrings[locale]!;
      if (localizedMap.containsKey(key)) {
        return localizedMap[key]!;
      }
    }

    // If the key or locale is not found, return an empty string
    return '';
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'Name',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'Username',
      desc: '',
      args: [],
    );
  }

  /// `locationInformation`
  String get locationInformation {
    return Intl.message(
      'Store location information',
      name: 'locationInformation',
      desc: '',
      args: [],
    );
  }

  /// `locationInformation`
  String get zone1 {
    return Intl.message(
      'Jnaah',
      name: 'Jnaah',
      desc: '',
      args: [],
    );
  }

  /// `locationInformation`
  String get zone2 {
    return Intl.message(
      'Bir AL Abed',
      name: 'Bir Al Abed',
      desc: '',
      args: [],
    );
  }

  /// `locationInformation`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'First Name',
      desc: '',
      args: [],
    );
  }

  /// `locationInformation`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'Last Name',
      desc: '',
      args: [],
    );
  }

  String get pleaseFirstName {
    return Intl.message(
      'Please enter First Name',
      name: 'Please enter First Name',
      desc: '',
      args: [],
    );
  }

  String get enterFirstName {
    return Intl.message(
      'Enter First Name',
      name: 'Enter First Name',
      desc: '',
      args: [],
    );
  }

  String get pleaseLastName {
    return Intl.message(
      'Please enter Last Name',
      name: 'Please enter Last Name',
      desc: '',
      args: [],
    );
  }

  String get enterLastName {
    return Intl.message(
      'Enter Last Name',
      name: 'Enter Last Name',
      desc: '',
      args: [],
    );
  }

  String get total{
    return Intl.message(
      'Total',
      name: 'Total',
      desc: '',
      args: [],
    );
  }

  String get retailLabel{
   return Intl.message(
     'Retail Purchase',
     name: 'Retail Purchase',
     desc: '',
     args: [],
   );
  }

  String get trueLabel{
    return Intl.message(
      'True',
      name: 'True',
      desc: '',
      args: [],
    );
  }

  String get falseLabel{
    return Intl.message(
      'False',
      name: 'False',
      desc: '',
      args: [],
    );
  }

}


class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
