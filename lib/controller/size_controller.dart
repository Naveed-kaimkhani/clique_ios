
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SizeController extends GetxController {
  var selectedSize = "M".obs; // Default selected size

  void selectSize(String size) {
    selectedSize.value = size;
  }
}
