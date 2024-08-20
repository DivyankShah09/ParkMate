import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCommand {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    String value = prefs.getString(key) ?? '';
    log('Shared Preferences: $key: $value');
    return value;
  }

  // check if the user is logged in
  static Future<bool> get isLoggedIn async {
    return prefs.containsKey('email');
  }

  static void clear() {
    prefs.clear();
  }
}
