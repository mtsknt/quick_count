import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  readList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  saveList(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  removeList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
