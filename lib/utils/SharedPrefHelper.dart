import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_models/get_categories/ticket_category_model.dart';
import '../data_models/login_datamodel/user_model.dart';
import '../utils/Constants.dart';

class SharedPrefHelper {
  static late SharedPreferences _prefs;
  static const String _lastClearTimestampKey = 'last_database_clear_timestamp';

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
    print("Session saved: $isLogin, Success: $success");
  }

  static bool getSession() {
    return _prefs.getBool(Constants.IsLogin) ?? false;
  }

  static Future<void> removeUser() async {
    await _prefs.remove(Constants.userKey);
    await _prefs.remove(Constants.IsLogin);
  }

  static Future<void> removedCategories() async {
    await _prefs.remove(Constants.saveCategories);
  }

  static Future<void> clearAll() async {
    await removeUser();
    await removedCategories();
    await _prefs.clear();
  }
  static Future<void> saveLastClearTimestamp(DateTime timestamp) async {
    await _prefs.setString(_lastClearTimestampKey, timestamp.toIso8601String());
    print("Last clear timestamp saved: ${timestamp.toIso8601String()}");
  }
  static DateTime? getLastClearTimestamp() {
    String? timestamp = _prefs.getString(_lastClearTimestampKey);
    if (timestamp != null) {
      print(" Last clear timestamp: $timestamp");
    } else {
      print(" No last clear timestamp found");
    }
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }
  static bool shouldClearDatabase() {
    DateTime? lastClear = getLastClearTimestamp();
    DateTime now = DateTime.now();
    if (lastClear == null) {
      print("Database never cleared before - should clear");
      return true;
    }
    DateTime todayMidnight = DateTime(now.year, now.month, now.day);
    bool shouldClear = lastClear.isBefore(todayMidnight);

    print("Current time: ${now.toIso8601String()}");
    print("Today's midnight: ${todayMidnight.toIso8601String()}");
    print("Last clear: ${lastClear.toIso8601String()}");
    print("Should clear: $shouldClear");

    return shouldClear;
  }
  static int getHoursUntilNextClear() {
    DateTime now = DateTime.now();
    DateTime tomorrowMidnight = DateTime(now.year, now.month, now.day).add(Duration(days: 1));
    Duration difference = tomorrowMidnight.difference(now);
    return difference.inHours;
  }
  static String getTimeUntilNextClear() {
    DateTime now = DateTime.now();
    DateTime tomorrowMidnight = DateTime(now.year, now.month, now.day).add(Duration(days: 1));
    Duration difference = tomorrowMidnight.difference(now);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    return '$hours hours $minutes minutes';
  }


  static const _lastServerTimeKey = 'last_server_time';
  static const _lastLocalTimeKey = 'last_local_time';

  static Future<void> saveTrustedTime(DateTime serverTime) async {
    final prefs = _prefs;
    await prefs.setString(_lastServerTimeKey, serverTime.toIso8601String());
    await prefs.setString(_lastLocalTimeKey, DateTime.now().toIso8601String());
  }

  static DateTime? getLastServerTime() {
    final value = _prefs.getString(_lastServerTimeKey);
    return value != null ? DateTime.parse(value) : null;
  }

  static DateTime? getLastLocalTime() {
    final value = _prefs.getString(_lastLocalTimeKey);
    return value != null ? DateTime.parse(value) : null;
  }

}