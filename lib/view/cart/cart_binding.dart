import 'package:clique/view_model/address_controller.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/order_view_model.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:get/get.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductViewModel());
    Get.lazyPut(() => OrderViewModel());
    Get.lazyPut(() => AddressController());
    Get.lazyPut(() => CartQuantityController());
  }
}
