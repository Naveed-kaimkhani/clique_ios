import 'dart:convert';
import 'dart:developer';
import 'package:clique/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static Future<void> saveCart(List<ProductModel> products) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedProducts = products.map((product) {
      // print(product..toString());
      log("produt codeee kya ja rha hy ${product.productCode}");
      return jsonEncode(product.toMap());
    }).toList();
    await prefs.setStringList('cart_items', encodedProducts);
  }

  static Future<List<ProductModel>> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedProducts = prefs.getStringList('cart_items');
    if (encodedProducts == null) return [];

    return encodedProducts.map((encodedProduct) {
      return ProductModel.fromMap(jsonDecode(encodedProduct));
    }).toList();
  }

  static Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_items');
  }
}
