import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEDKEY';
  static String sharedPreferenceUserMailKey = 'USERMAILKEY';

  // Setting data to shared Preference
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserUserNameSharedPreference(String userName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserMailSharedPreference(String userMail) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.setString(sharedPreferenceUserMailKey, userMail);
  }

  // getting data from shared Preference
  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserUserNameSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserMailSharedPreference() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserMailKey);
  }
}
