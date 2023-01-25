// ignore_for_file: unused_field, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:chat_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///=======================================================================

  static Future setUserphoneNumber(String userPhoneNumber) async =>
      await _preferences!.setString('_setUserphoneNumber', userPhoneNumber);

  static String? getUserphoneNumber() =>
      _preferences!.getString('_setUserphoneNumber');

  ///=======================================================================

  static Future setIsFrist(bool isFrist) async =>
      await _preferences!.setBool('_isFrist', isFrist);

  static bool getIsFrist() => _preferences!.getBool('_isFrist') ?? false;

  ///=======================================================================

  static Future setUserModel(UserModel userModel) async => await _preferences!
      .setString('_userModel', json.encode(userModel.toMap()));

  static String? getUserModel() => _preferences!.getString('_userModel');
}
