import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/library_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;
  // static const _keyAdmin = "admin";
  static const _keyName = "name";
  static const _keyUserId = "id";
  static const _keyEmail = "email";
  static const _keyToken = "token";
  static const _keyUserType = "userType";
  static const _keyFavorites = "favorites";
  static const _keyplaylater = "playlater";
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

  static List<String> _getFavorites() {
    return _preferences?.getStringList(_keyFavorites) ?? [];
  }

  static Future<void> _setFavorites(List<String> values) async {
    _preferences?.setStringList(_keyFavorites, values);
  }

  static List<String> _getPlaylater() {
    return _preferences?.getStringList(_keyplaylater) ?? [];
  }

  static void _setPlaylater(List<String> values) {
    _preferences?.setStringList(_keyplaylater, values);
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

  static void addLecturesToPlaylaters(List<LibraryItem> items) {
    _setPlaylater(items.map((e) => "${e.id}:${e.lectureId}").toList());
  }

  static String? checkIfLectureInPlaylaters(Lecture lecture) {
    final items = _getPlaylater();
    for (var i = 0; i < items.length; i++) {
      if (items[i].endsWith(lecture.id.toString())) {
        return items[i].split(':').first;

      }
    }
    return null;
  }
  static void addLecturesToFavorites(List<LibraryItem> items) {
    _setFavorites(items.map((e) => "${e.id}:${e.lectureId}").toList());
  }

  static String? checkIfLectureInFavorites(Lecture lecture) {
    final items = _getFavorites();
    for (var i = 0; i < items.length; i++) {
      if (items[i].endsWith(lecture.id.toString())) {
        return items[i].split(':').first;
      }
    }
    return null;
  }
}
