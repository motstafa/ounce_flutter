import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ounce/services/auth_service.dart';
import 'package:ounce/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  late UserModel _user;

  UserModel get user => _user;

  set user(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String password,
    XFile? profilePicture,
    String storeName,
    String phoneNumber,
    XFile? storePicture,
    String prefecture,
    int zoneId,
    String cityTown,
    String ward,
    String streetAddress,
    String building,
    int floor,
  ) async {
    try {
      if(await AuthService().register(
        firstName,
        lastName,
        email,
        password,
        profilePicture,
        storeName,
        phoneNumber,
        storePicture,
        prefecture,
        zoneId,
        cityTown,
        ward,
        streetAddress,
        building,
        floor
      )){
      return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login({
   required String email,
   required String password,
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getUser() async{
    try {
      UserModel user = await AuthService().getUser();
      _user = user;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
