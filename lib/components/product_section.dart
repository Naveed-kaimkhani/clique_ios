

import 'package:clique/components/profile_product_card.dart';
import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsSection extends StatelessWidget {
  final String userEmail;
  // final UserController userController = Get.find<UserController>();
   ProductsSection({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final DiscoverViewModel popstreamViewModel = Get.find<DiscoverViewModel>();
   final ProductViewModel productViewModel = Get.isRegistered<ProductViewModel>()
    ? Get.find<ProductViewModel>()
    : Get.put(ProductViewModel());


    return Obx(() {
      // Step 1: Filter popstreams by createdByfdsfsdf
      final String currentUserId =userEmail; // Replace with your current user's ID
      final List<String> filteredPartyIds = popstreamViewModel.popstreams
          .where((popstream) => popstream.createdBy == currentUserId)
          .map((popstream) => popstream.partyId)
          .toSet() // Get unique partyIds
          .toList();
      // Step 2: Filter products by partyIds
      final filteredProducts = productViewModel.products
          .where((product) => filteredPartyIds.contains(product.id.toString()))
          .toList();

      if (productViewModel.isLoading.value ||
          popstreamViewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (filteredProducts.isEmpty) {
        return const Center(child: Text('No related products found.'));
      }

      // Step 3: Display the filtered products
      return ListView.builder(
        padding: const EdgeInsets.only(top: 12.0),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
           final discount = ((product.msrp - product.cost) / product.msrp * 100).round();

          return 
          ProfileProductCard(
            uid: product.id.toString() ,
            size: product.productWeight,
            unit: product.unit,
            categories: product.categories??"Dog Treats", 
            backgroundImage: product.imageUrls ,
            productName: product.productTitle ,
            productDescription: product.productDesc ,
            price: product.cost,
            oldPrice: product.msrp,
            discount:  "$discount % OFF",
          );
        },
      );
    });
  }
}
