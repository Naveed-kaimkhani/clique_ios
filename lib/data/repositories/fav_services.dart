import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorite_ids';

  // Update the return type to List<String> (product IDs as String)
  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    // Return the list of strings directly without converting
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  // Update the parameter type to List<String> (product IDs as String)
  Future<void> saveFavoriteIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    // Store the list of strings directly
    await prefs.setStringList(_favoritesKey, ids);
  }
}
