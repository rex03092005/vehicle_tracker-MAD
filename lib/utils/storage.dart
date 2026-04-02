import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static bool get isDarkMode => prefs.getBool('isDarkMode') ?? false;
  static Future<void> setDarkMode(bool value) async {
    await prefs.setBool('isDarkMode', value);
  }
}
