// Create a separate controller class
import 'package:get/get.dart';

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();
  final RxInt selectedIndex = 0.obs;


  void changeIndex(int index,int tab) {
    selectedIndex.value = index;
  }

}