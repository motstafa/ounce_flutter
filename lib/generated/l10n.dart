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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
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

  /// `Welcome Back`
  String get welcome {
    return Intl.message('Welcome Back', name: 'welcome', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Enter Email`
  String get enterEmail {
    return Intl.message('Enter Email', name: 'enterEmail', desc: '', args: []);
  }

  /// `Please Enter Email`
  String get emailValidator {
    return Intl.message(
      'Please Enter Email',
      name: 'emailValidator',
      desc: '',
      args: [],
    );
  }

  /// `Please Enter Password`
  String get pleasePass {
    return Intl.message(
      'Please Enter Password',
      name: 'pleasePass',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
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
    return Intl.message('Remember me', name: 'rememberMe', desc: '', args: []);
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
    return Intl.message('Sign In', name: 'signin', desc: '', args: []);
  }

  /// `Sign Up With`
  String get signUpWith {
    return Intl.message('Sign Up With', name: 'signUpWith', desc: '', args: []);
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
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
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
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
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

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Please enter First Name`
  String get pleaseFirstName {
    return Intl.message(
      'Please enter First Name',
      name: 'pleaseFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter First Name`
  String get enterFirstName {
    return Intl.message(
      'Enter First Name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Please enter Last Name`
  String get pleaseLastName {
    return Intl.message(
      'Please enter Last Name',
      name: 'pleaseLastName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Last Name`
  String get enterLastName {
    return Intl.message(
      'Enter Last Name',
      name: 'enterLastName',
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
    return Intl.message('Address Info', name: 'address', desc: '', args: []);
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
    return Intl.message('Store Name', name: 'storeName', desc: '', args: []);
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
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
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
    return Intl.message('Zone', name: 'zone', desc: '', args: []);
  }

  /// `Select Zone`
  String get selectZone {
    return Intl.message('Select Zone', name: 'selectZone', desc: '', args: []);
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
    return Intl.message('Prefecture', name: 'prefecture', desc: '', args: []);
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
    return Intl.message('City Or Town', name: 'city', desc: '', args: []);
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
    return Intl.message('Ward', name: 'wardLabel', desc: '', args: []);
  }

  /// `Enter Ward`
  String get enterWard {
    return Intl.message('Enter Ward', name: 'enterWard', desc: '', args: []);
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
    return Intl.message('Building', name: 'buildingLabel', desc: '', args: []);
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
    return Intl.message('Floor', name: 'floorLabel', desc: '', args: []);
  }

  /// `Enter Floor`
  String get enterFloor {
    return Intl.message('Enter Floor', name: 'enterFloor', desc: '', args: []);
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
    return Intl.message('Name', name: 'nameLabel', desc: '', args: []);
  }

  /// `estimated time to seller per minutes`
  String get estimatedTimeToSellerHint {
    return Intl.message(
      'estimated time to seller per minutes',
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

  /// `estimated time to buyer per minutes`
  String get estimatedTimeToBuyerHint {
    return Intl.message(
      'estimated time to buyer per minutes',
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
    return Intl.message('Pending', name: 'pendingTab', desc: '', args: []);
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
    return Intl.message('Completed', name: 'completedTab', desc: '', args: []);
  }

  /// `Buy Page`
  String get buyPageTitle {
    return Intl.message('Buy Page', name: 'buyPageTitle', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
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

  /// `Type`
  String get typeOfOuncesLabel {
    return Intl.message('Type', name: 'typeOfOuncesLabel', desc: '', args: []);
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

  /// `Buy`
  String get buyButtonText {
    return Intl.message('Buy', name: 'buyButtonText', desc: '', args: []);
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
    return Intl.message('Buy', name: 'buyDialogButtonText', desc: '', args: []);
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
    return Intl.message('Home', name: 'homeLabel', desc: '', args: []);
  }

  /// `Profile`
  String get profileLabel {
    return Intl.message('Profile', name: 'profileLabel', desc: '', args: []);
  }

  /// `Sell Page`
  String get sellPageTitle {
    return Intl.message('Sell Page', name: 'sellPageTitle', desc: '', args: []);
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
    return Intl.message('Unit Type', name: 'unitTypeLabel', desc: '', args: []);
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
    return Intl.message('OK', name: 'okButtonLabel', desc: '', args: []);
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
    return Intl.message('Sell', name: 'sellLabel', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Store location information`
  String get locationInformation {
    return Intl.message(
      'Store location information',
      name: 'locationInformation',
      desc: '',
      args: [],
    );
  }

  /// `Jnaah`
  String get zone1 {
    return Intl.message('Jnaah', name: 'zone1', desc: '', args: []);
  }

  /// `Bir AL Abed`
  String get zone2 {
    return Intl.message('Bir AL Abed', name: 'zone2', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Retail Purchase`
  String get retailLabel {
    return Intl.message(
      'Retail Purchase',
      name: 'retailLabel',
      desc: '',
      args: [],
    );
  }

  /// `True`
  String get trueLabel {
    return Intl.message('True', name: 'trueLabel', desc: '', args: []);
  }

  /// `False`
  String get falseLabel {
    return Intl.message('False', name: 'falseLabel', desc: '', args: []);
  }

  /// `All deliveries are currently busy.`
  String get busy {
    return Intl.message(
      'All deliveries are currently busy.',
      name: 'busy',
      desc: '',
      args: [],
    );
  }

  /// `Your order may take an additional 20 minutes.`
  String get delayed {
    return Intl.message(
      'Your order may take an additional 20 minutes.',
      name: 'delayed',
      desc: '',
      args: [],
    );
  }

  /// `Your order may take from 5 to 10 minutes.`
  String get noDelay {
    return Intl.message(
      'Your order may take from 5 to 10 minutes.',
      name: 'noDelay',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get operationDone {
    return Intl.message('Done', name: 'operationDone', desc: '', args: []);
  }

  /// `In Progress`
  String get operationInProgress {
    return Intl.message(
      'In Progress',
      name: 'operationInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get operationPending {
    return Intl.message(
      'Pending',
      name: 'operationPending',
      desc: '',
      args: [],
    );
  }

  /// `Failed`
  String get operationFailed {
    return Intl.message('Failed', name: 'operationFailed', desc: '', args: []);
  }

  /// `Paused`
  String get operationPaused {
    return Intl.message('Paused', name: 'operationPaused', desc: '', args: []);
  }

  /// `Canceled`
  String get operationCanceled {
    return Intl.message(
      'Canceled',
      name: 'operationCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Allow retail puchase?`
  String get allowRetail {
    return Intl.message(
      'Allow retail puchase?',
      name: 'allowRetail',
      desc: '',
      args: [],
    );
  }

  /// `Your Balance:`
  String get yourBalance {
    return Intl.message(
      'Your Balance:',
      name: 'yourBalance',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Failed`
  String get purchaseFailed {
    return Intl.message(
      'Purchase Failed',
      name: 'purchaseFailed',
      desc: '',
      args: [],
    );
  }

  /// `You do not have enough balance to complete the purchase.`
  String get purchaseFailedText {
    return Intl.message(
      'You do not have enough balance to complete the purchase.',
      name: 'purchaseFailedText',
      desc: '',
      args: [],
    );
  }

  /// `Buyer Location`
  String get buyerLocation {
    return Intl.message(
      'Buyer Location',
      name: 'buyerLocation',
      desc: '',
      args: [],
    );
  }

  /// `Seller Location`
  String get sellerLocation {
    return Intl.message(
      'Seller Location',
      name: 'sellerLocation',
      desc: '',
      args: [],
    );
  }

  /// `Number Of Units`
  String get numberOfUnits {
    return Intl.message(
      'Number Of Units',
      name: 'numberOfUnits',
      desc: '',
      args: [],
    );
  }

  /// `Selling Expires In`
  String get expireIn {
    return Intl.message(
      'Selling Expires In',
      name: 'expireIn',
      desc: '',
      args: [],
    );
  }

  /// `the displayed item`
  String get selledItem {
    return Intl.message(
      'the displayed item',
      name: 'selledItem',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `It looks like you haven't posted anything for sale yet.\nList an item now and start selling!`
  String get NoListingYet {
    return Intl.message(
      'It looks like you haven\'t posted anything for sale yet.\nList an item now and start selling!',
      name: 'NoListingYet',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account? This action cannot be undone.`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account? This action cannot be undone.',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Account deleted successfully`
  String get accountDeletedSuccessfully {
    return Intl.message(
      'Account deleted successfully',
      name: 'accountDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting account. Please try again.`
  String get errorDeletingAccount {
    return Intl.message(
      'Error deleting account. Please try again.',
      name: 'errorDeletingAccount',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Error verifying password`
  String get errorVerifyingPassword {
    return Intl.message(
      'Error verifying password',
      name: 'errorVerifyingPassword',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Buy Balance`
  String get buyBalance {
    return Intl.message('Buy Balance', name: 'buyBalance', desc: '', args: []);
  }

  /// `Sell Balance`
  String get sellBalance {
    return Intl.message(
      'Sell Balance',
      name: 'sellBalance',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `This field is required`
  String get requiredField {
    return Intl.message(
      'This field is required',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Product image is required`
  String get imageRequired {
    return Intl.message(
      'Product image is required',
      name: 'imageRequired',
      desc: '',
      args: [],
    );
  }

  /// `Select Quantity`
  String get selectQuantity {
    return Intl.message(
      'Select Quantity',
      name: 'selectQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Image size must be less than 2MB`
  String get sizeWarning {
    return Intl.message(
      'Image size must be less than 2MB',
      name: 'sizeWarning',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Select image source`
  String get selectImageSource {
    return Intl.message(
      'Select image source',
      name: 'selectImageSource',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo`
  String get takePhoto {
    return Intl.message('Take a photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Delivery Status`
  String get deliveryStatusTitle {
    return Intl.message(
      'Delivery Status',
      name: 'deliveryStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get statusDelivered {
    return Intl.message(
      'Delivered',
      name: 'statusDelivered',
      desc: '',
      args: [],
    );
  }

  /// `En route to buyer`
  String get statusEnRouteToBuyer {
    return Intl.message(
      'En route to buyer',
      name: 'statusEnRouteToBuyer',
      desc: '',
      args: [],
    );
  }

  /// `Picked up`
  String get statusPickedUp {
    return Intl.message(
      'Picked up',
      name: 'statusPickedUp',
      desc: '',
      args: [],
    );
  }

  /// `At seller`
  String get statusAtSeller {
    return Intl.message(
      'At seller',
      name: 'statusAtSeller',
      desc: '',
      args: [],
    );
  }

  /// `En route to seller`
  String get statusEnRouteToSeller {
    return Intl.message(
      'En route to seller',
      name: 'statusEnRouteToSeller',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get statusAccepted {
    return Intl.message('Accepted', name: 'statusAccepted', desc: '', args: []);
  }

  /// `Update Status`
  String get updateStatusBtn {
    return Intl.message(
      'Update Status',
      name: 'updateStatusBtn',
      desc: '',
      args: [],
    );
  }

  /// `Enter time in minutes`
  String get enterTimeInMinutes {
    return Intl.message(
      'Enter time in minutes',
      name: 'enterTimeInMinutes',
      desc: '',
      args: [],
    );
  }

  /// `Invalid time value`
  String get invalidTimeValue {
    return Intl.message(
      'Invalid time value',
      name: 'invalidTimeValue',
      desc: '',
      args: [],
    );
  }

  /// `Please enter time`
  String get pleaseEnterTime {
    return Intl.message(
      'Please enter time',
      name: 'pleaseEnterTime',
      desc: '',
      args: [],
    );
  }

  /// `Estimated time to seller`
  String get estimatedTimeToSeller {
    return Intl.message(
      'Estimated time to seller',
      name: 'estimatedTimeToSeller',
      desc: '',
      args: [],
    );
  }

  /// `Estimated time to buyer`
  String get estimatedTimeToBuyer {
    return Intl.message(
      'Estimated time to buyer',
      name: 'estimatedTimeToBuyer',
      desc: '',
      args: [],
    );
  }

  /// `By accepting this order, you agree to proceed with the delivery process.`
  String get acceptOrderDescription {
    return Intl.message(
      'By accepting this order, you agree to proceed with the delivery process.',
      name: 'acceptOrderDescription',
      desc: '',
      args: [],
    );
  }

  /// `Seller Amount`
  String get sellerAmount {
    return Intl.message(
      'Seller Amount',
      name: 'sellerAmount',
      desc: '',
      args: [],
    );
  }

  /// `Buyer Amount`
  String get buyerAmount {
    return Intl.message(
      'Buyer Amount',
      name: 'buyerAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter personal details to your employee account`
  String get welcomeSubtitle {
    return Intl.message(
      'Enter personal details to your employee account',
      name: 'welcomeSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload Government ID or Passport`
  String get uploadGovernmentId {
    return Intl.message(
      'Upload Government ID or Passport',
      name: 'uploadGovernmentId',
      desc: '',
      args: [],
    );
  }

  /// `Government ID or Passport is required`
  String get governmentIdRequired {
    return Intl.message(
      'Government ID or Passport is required',
      name: 'governmentIdRequired',
      desc: '',
      args: [],
    );
  }

  /// `Image size must be less than 2MB`
  String get imageSizeLimit {
    return Intl.message(
      'Image size must be less than 2MB',
      name: 'imageSizeLimit',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Zone is required`
  String get zoneRequired {
    return Intl.message(
      'Zone is required',
      name: 'zoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password requirements:`
  String get passwordRequirements {
    return Intl.message(
      'Password requirements:',
      name: 'passwordRequirements',
      desc: '',
      args: [],
    );
  }

  /// `At least 8 characters`
  String get minChars {
    return Intl.message(
      'At least 8 characters',
      name: 'minChars',
      desc: '',
      args: [],
    );
  }

  /// `At least one uppercase letter`
  String get upperCase {
    return Intl.message(
      'At least one uppercase letter',
      name: 'upperCase',
      desc: '',
      args: [],
    );
  }

  /// `At least one lowercase letter`
  String get lowerCase {
    return Intl.message(
      'At least one lowercase letter',
      name: 'lowerCase',
      desc: '',
      args: [],
    );
  }

  /// `At least one number`
  String get numberReq {
    return Intl.message(
      'At least one number',
      name: 'numberReq',
      desc: '',
      args: [],
    );
  }

  /// `At least one special character`
  String get specialChar {
    return Intl.message(
      'At least one special character',
      name: 'specialChar',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get languageSwitchLabel {
    return Intl.message(
      'Change Language',
      name: 'languageSwitchLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get invalidPasswordLength {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'invalidPasswordLength',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least 1 uppercase letter`
  String get invalidPasswordUppercase {
    return Intl.message(
      'Password must contain at least 1 uppercase letter',
      name: 'invalidPasswordUppercase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least 1 lowercase letter`
  String get invalidPasswordLowercase {
    return Intl.message(
      'Password must contain at least 1 lowercase letter',
      name: 'invalidPasswordLowercase',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least 1 number`
  String get invalidPasswordNumber {
    return Intl.message(
      'Password must contain at least 1 number',
      name: 'invalidPasswordNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least 1 special character`
  String get invalidPasswordSpecial {
    return Intl.message(
      'Password must contain at least 1 special character',
      name: 'invalidPasswordSpecial',
      desc: '',
      args: [],
    );
  }

  /// `Image size must be less than 2MB`
  String get governmentIdSizeWarning {
    return Intl.message(
      'Image size must be less than 2MB',
      name: 'governmentIdSizeWarning',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Ounce`
  String get welcomeToOunce {
    return Intl.message(
      'Welcome to Ounce',
      name: 'welcomeToOunce',
      desc: '',
      args: [],
    );
  }

  /// `Your platform for safe and quick trading`
  String get welcomePlatformDesc {
    return Intl.message(
      'Your platform for safe and quick trading',
      name: 'welcomePlatformDesc',
      desc: '',
      args: [],
    );
  }

  /// `This item has just been purchased by someone else and is no longer available.`
  String get itemNoLongerAvailable {
    return Intl.message(
      'This item has just been purchased by someone else and is no longer available.',
      name: 'itemNoLongerAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Only available`
  String get onlyAvailable {
    return Intl.message(
      'Only available',
      name: 'onlyAvailable',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get items {
    return Intl.message('items', name: 'items', desc: '', args: []);
  }

  /// `Refreshing...`
  String get refreshing {
    return Intl.message(
      'Refreshing...',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Last Operation`
  String get lastOperation {
    return Intl.message(
      'Last Operation',
      name: 'lastOperation',
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
