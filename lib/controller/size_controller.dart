
import 'package:get/get.dart';

class SizeController extends GetxController {
  var selectedSize = "M".obs; // Default selected size

  void selectSize(String size) {
    selectedSize.value = size;
  }
}
