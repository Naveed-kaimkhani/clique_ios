import 'package:clique/components/profile_product_card.dart';
import 'package:clique/data/models/store_product.dart';
import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsSection extends StatelessWidget {
  final String userEmail;
  ProductsSection({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final DiscoverViewModel popstreamViewModel = Get.find<DiscoverViewModel>();

    return Obx(() {
      // Step 1: Filter popstreams by createdByfdsfsdf
      final String currentUserId =
          userEmail; // Replace with your current user's ID
      final List<StoreProduct> filteredStoreProducts = popstreamViewModel
          .popstreams
          .where((popstream) => popstream.createdBy == currentUserId)
          .expand((popstream) =>
              popstream.storeProduct) // Flatten all storeProducts
          .toList();
      if (filteredStoreProducts.isEmpty) {
        return Center(child: Text("No product uploaded"));
      }
      // Step 3: Display the filtered products
      return ListView.builder(
        padding: const EdgeInsets.only(top: 12.0),
        itemCount: filteredStoreProducts.first.products.length,
        itemBuilder: (context, index) {
          final product = filteredStoreProducts.first.products[index];

          return ProfileProductCard(
            uid: product.sku,
            size: product.quantity,
            unit: "",
            categories: "",
            backgroundImage: [product.imageUrl],
            productName: product.name,
            productDescription: product.description,
            price: product.price,
            oldPrice: 10,
            tdid: "",
            discount: "",
          );
        },
      );
    });
  }
}
