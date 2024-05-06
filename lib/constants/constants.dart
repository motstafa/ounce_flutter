

import 'package:ounce/main.dart';

class Constants {
  static const String apiUri = 'http://127.0.0.1:8000/api';
  static const userRoles = <String,dynamic>{'trader' : 1,'delivery':2};

  int CalculatePrice(int itemNumber,int itemPrice){

    var commission= prefs.getInt('commissions');
    return itemPrice!*itemNumber + commission!*itemNumber;

  }

}

