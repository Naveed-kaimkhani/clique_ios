import 'package:clique/constants/app_images.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/models/cart_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[
    CartItem(
      id: '1', 
      name: 'Jacket Boucle',
       price: 53.23, quantity: 1, imageUrl: AppSvgIcons.product, size: 'XL'),
      //    CartItem(
      // id: '2', 
      // name: 'Jacket Boucle',
      //  price: 53.23, quantity: 1, imageUrl: AppSvgIcons.cloth, size: 'XL'),
       
  ].obs;
  
  double get subTotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double shippingFee = 5.50;
  double get total => subTotal + shippingFee;

  void addItem(CartItem item) {
    var existingItem = cartItems.firstWhereOrNull((e) => e.id == item.id);
    if (existingItem != null) {
      existingItem.quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
  }

  void removeItem(String id) {
    cartItems.removeWhere((item) => item.id == id);
  }

  void incrementQuantity(String id) {
    var item = cartItems.firstWhereOrNull((e) => e.id == id);
    if (item != null) {
      item.quantity++;
      cartItems.refresh();
    }
  }

  void decrementQuantity(String id) {
    var item = cartItems.firstWhereOrNull((e) => e.id == id);
    if (item != null && item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    }
  }
}

