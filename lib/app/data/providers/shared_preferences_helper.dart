import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;
  // static const _keyAdmin = "admin";
  static const _keyName = "name";
  static const _keyUserId = "id";
  static const _keyEmail = "email";
  static const _keyToken = "token";
  static const _keyUserType = "userType";
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future saveUserDetails(
      {required int id,
      required String name,
      required String email,
      required String token,
      required int userType}) async {
    await _preferences?.setString(_keyEmail, email);
    await _preferences?.setString(_keyName, name);
    await _preferences?.setString(_keyToken, token);
    await _preferences?.setInt(_keyUserType, userType);
    await _preferences?.setInt(_keyUserId, id);
    // await _preferences?.setBool(_keyAdmin, isAdmin);
  }

  static String getEmail() {
    return _preferences?.getString(_keyEmail) ?? '';
  }

  static String getName() {
    return _preferences?.getString(_keyName) ?? '';
  }

  static int getUserId() {
    return _preferences?.getInt(_keyUserId) ?? 0;
  }

  static int getuserType() {
    return _preferences?.getInt(_keyUserType) ?? 0;
  }

  static String? getToken() {
    return _preferences?.getString(_keyToken);
  }

  static Future clearUserData() async {
    await _preferences?.clear();
  }

  static destroyData() {
    _preferences?.clear();
  }
}
