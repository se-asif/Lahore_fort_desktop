import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_models/get_categories/ticket_category_model.dart';
import '../data_models/login_datamodel/user_model.dart';
import '../utils/Constants.dart';
class SharedPrefHelper {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveUser(User user) async {
    String userJson = jsonEncode(user.toJson());
    print("user saved $user");
    await _prefs.setString(Constants.userKey, userJson);
  }

  static Future<void> saveCategoriesList(List<TicketCategory> categories) async {
     String categoriesJson = jsonEncode(categories.map((e) => e.toJson()).toList());
     await _prefs.setString(Constants.saveCategories, categoriesJson);
  }

  static List<TicketCategory> getCategoriesList() {
    String? categoriesJson = _prefs.getString(Constants.saveCategories);

    if (categoriesJson == null || categoriesJson.isEmpty) return [];

    List<dynamic> decodedList = jsonDecode(categoriesJson);
    return decodedList.map((e) => TicketCategory.fromJson(e)).toList();
  }

  static User? getUser() {
    String? userJson = _prefs.getString(Constants.userKey);
    print("User retrieved: $userJson");
    return userJson != null ? User.fromJson(jsonDecode(userJson)) : null;
  }

  static Future<void> saveSession(bool isLogin) async {
    bool success = await _prefs.setBool(Constants.IsLogin, isLogin);
    print("🔹 Session saved: $isLogin, Success: $success");
  }


  static bool getSession() {
    return _prefs.getBool(Constants.IsLogin) ?? false; // Default to false
  }


  static Future<void> removeUser() async {
    await _prefs.remove(Constants.userKey);
    await _prefs.remove(Constants.IsLogin);
  }
  static Future<void> removedCategories() async {
    await _prefs.remove(Constants.saveCategories);

  }
  static Future<void> clearAll() async {
    await _prefs.clear();
  }

}
