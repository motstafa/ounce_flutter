

import 'package:ounce/main.dart';

class Constants {
  //android emulator http://10.0.2.2:8000/api
  //web http://127.0.0.1:8000/api
  static const String apiUri = 'http://10.0.2.2:8000/api';
  static const userRoles = <String,dynamic>{'trader' : 1,'delivery':2};

  int CalculatePrice(int itemNumber,int itemPrice){

    var commission= prefs.getInt('commissions');
    return itemPrice*itemNumber + commission!*itemNumber;

  }

}

