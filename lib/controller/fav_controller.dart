import 'package:get/get.dart';

class FavoriteController extends GetxController {
  var isFavorite = false.obs; // Observable variable

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value; // Toggle favorite state
  }
}
