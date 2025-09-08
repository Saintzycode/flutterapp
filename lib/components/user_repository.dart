import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const _kUsersKey = 'users_v1';
  static late SharedPreferences _prefs;
  static List<Map<String, String>> _users = [];

  // Call this once at app start
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_kUsersKey);

    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _users = list.map((e) {
        final map = e as Map<String, dynamic>;
        return {
          'username': map['username'] as String,
          // 👇 fallback: if email doesn't exist, set it to empty string
          'email': map.containsKey('email') ? map['email'] as String : '',
          'password': map['password'] as String,
        };
      }).toList();

      // 🔄 Persist immediately if migration happened
      if (_users.any((u) => u['email'] == '')) {
        await _persist();
      }
    } else {
      _users = [];
    }
  }

  static Future<void> _persist() async {
    await _prefs.setString(_kUsersKey, jsonEncode(_users));
  }

  static bool usernameExists(String username) =>
      _users.any((u) => u['username'] == username);

  static Future<bool> addUser(String username, String email, String password) async {
    if (usernameExists(username)) return false;
    _users.add({'username': username, 'email': email, 'password': password});
    await _persist();
    return true;
  }

  static bool validateUser(String username, String password) =>
      _users.any((u) => u['username'] == username && u['password'] == password);

  static Future<void> clearAll() async {
    _users.clear();
    await _persist();
  }
}
