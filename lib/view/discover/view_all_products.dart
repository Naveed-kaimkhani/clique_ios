import 'package:clique/components/all_products_appBar.dart';
import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllProductsScreen extends StatelessWidget {
  const ViewAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final ProductViewModel productViewModel = Get.find<ProductViewModel>();
      final ProductViewModel productViewModel = Get.isRegistered<ProductViewModel>()
    ? Get.find<ProductViewModel>()
    : Get.put(ProductViewModel(), permanent: true);
    return Container(
      // padding: EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: AllProductsAppBar(title: "All Products", icon: Icons.arrow_back_ios , isNotification: true,),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Obx(() {
             if (productViewModel.isLoading.value && productViewModel.products.isEmpty) {
              return _buildShimmerGrid(context);
            }
            
            
              return _buildProductGrid(context, productViewModel);
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, ProductViewModel productViewModel) {
    final size = MediaQuery.of(context).size;
    ScrollController _scrollController = ScrollController();

    // Add a listener to detect when user reaches the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Trigger load more when at the end
        productViewModel.loadMoreProducts();
      }
    });

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        controller: _scrollController,
        key: const ValueKey('products_grid'),
        padding: const EdgeInsets.only(bottom:  4.0, left: 20.0, right: 20.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: size.width * 0.04,
          childAspectRatio: 0.6,
        ),
        itemCount: productViewModel.products.length + 1, // +1 for the loading indicator
        itemBuilder: (_, index) {
          if (index == productViewModel.products.length) {
            
            if (index == productViewModel.products.length) {
  if (productViewModel.currentPage.value < productViewModel.totalPages.value) {
    return Padding(
      padding: const EdgeInsets.only(left:  28.0),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 2,),
          GradientText( "Fetching more products. Please wait...",fontSize: 12, gradient: AppColors.appGradientColors,),
          
        ],
      ),
    );
  } else {
    return const SizedBox.shrink(); // No more products
  }
}

          }

          final product = productViewModel.products[index];

          return ProductCard(
            weight: product.productWeight, // Assuming `weight` exists in `ProductModel`
            isShowDiscount: false,
            tdid: product.tdid??"",
            unit: product.unit,
            categories: product.categories??"",
            uid: product.id.toString(), // Assuming `id` exists in `ProductModel`
            backgroundImage: product.imageUrls,
            productName: product.productTitle, // Assuming `productTitle` exists in `ProductModel`
            productDescription: product.productDesc, // Assuming `productDescription` exists
            price: product.cost, // Assuming `price` exists in `ProductModel`
            oldPrice: product.msrp, // Assuming `oldPrice` exists in `ProductModel`
            discount: "23" ?? "No Discount", // Assuming `discount` exists in `ProductModel`
          );
        },
      ),
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return GridView.builder(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: size.width * 0.009,
      childAspectRatio: 0.6,
    ),
    itemCount: 6, // Number of shimmer items
    itemBuilder: (context, index) => Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

}