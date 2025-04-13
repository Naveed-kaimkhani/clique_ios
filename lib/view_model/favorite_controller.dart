import 'package:clique/data/repositories/fav_services.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final FavoriteService _favoriteService = FavoriteService();

  // Change RxList type to store Strings (product IDs as String)
  RxList<String> favoriteIds = <String>[].obs;

  @override
  void onInit() {
    loadFavorites();
    super.onInit();
  }

  // Load favorite product IDs from SharedPreferences
  void loadFavorites() async {
    favoriteIds.value = await _favoriteService.getFavoriteIds();
  }

  // Toggle the favorite status of a product by ID (String)
  void toggleFavorite(String productId) async {
    if (isFavorite(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }
    await _favoriteService.saveFavoriteIds(favoriteIds);
  }

  // Check if a product is in the favorites list by ID (String)
  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }
}
