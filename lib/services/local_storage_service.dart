import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveData(String key, String value) async {
    await _initPrefs();
    await _prefs!.setString(key, value);
  }

  Future<String?> getData(String key) async {
    await _initPrefs();
    return _prefs!.getString(key);
  }

  Future<void> saveList(String key, List<String> value) async {
    await _initPrefs();
    await _prefs!.setStringList(key, value);
  }

  Future<List<String>> getList(String key) async {
    await _initPrefs();
    return _prefs!.getStringList(key) ?? [];
  }

  Future<void> removeData(String key) async {
    await _initPrefs();
    await _prefs!.remove(key);
  }

  Future<void> clearAllData() async {
    await _initPrefs();
    await _prefs!.clear();
  }
}
