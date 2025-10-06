
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorites_v1';
  SharedPreferences? _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<String>> getAll() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getStringList(_key) ?? [];
  }

  Future<void> add(String item) async {
    _prefs ??= await SharedPreferences.getInstance();
    final list = _prefs!.getStringList(_key) ?? [];
    if (!list.contains(item)) {
      list.add(item);
      await _prefs!.setStringList(_key, list);
    }
  }

  Future<void> remove(String item) async {
    _prefs ??= await SharedPreferences.getInstance();
    final list = _prefs!.getStringList(_key) ?? [];
    list.remove(item);
    await _prefs!.setStringList(_key, list);
  }

  Future<bool> contains(String item) async {
    _prefs ??= await SharedPreferences.getInstance();
    final list = _prefs!.getStringList(_key) ?? [];
    return list.contains(item);
  }
}
