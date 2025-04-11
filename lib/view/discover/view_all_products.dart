
// import 'package:clique/components/index.dart';
// import 'package:clique/constants/index.dart';
// import 'package:flutter/material.dart';

// class ViewAllProductsScreen extends StatelessWidget {
//   const ViewAllProductsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: AppColors.appGradientColors,
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Scaffold(
//           appBar: CustomAppBar(title: "All Products", icon: Icons.arrow_back_ios),
//           backgroundColor: Colors.white,
//           body: _buildProductGrid(context),
//         ),
//       ),
//     );
//   }

//   Widget _buildProductGrid(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 300),
//       child: GridView.builder(
//         key: const ValueKey('products_grid'),
//         padding: const EdgeInsets.all(10),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: size.width * 0.009,
//           childAspectRatio: 0.6,
//         ),
//         itemCount: 4,
//         itemBuilder: (_, index) => ProductCard(
//           isShowDiscount: false,
//           uid: index.toString(),
//           backgroundImage: 'assets/png/product.png',
//           productName: "Girl's Full Blazers",
//           productDescription: "Crafted from premium, breathable cotton fabric",
//           price: 53.23,
//           oldPrice: 100.23,
//           discount: "10% OFF",
//         ),
//       ),
//     );
//   }
// }


import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllProductsScreen extends StatelessWidget {
  const ViewAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductViewModel productViewModel = Get.find<ProductViewModel>();
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "All Products", icon: Icons.arrow_back_ios),
          backgroundColor: Colors.white,
          body: Obx(() {
            if (productViewModel.isLoading.value && productViewModel.products.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return _buildProductGrid(context, productViewModel);
          }),
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
          crossAxisSpacing: size.width * 0.009,
          childAspectRatio: 0.6,
        ),
        itemCount: productViewModel.products.length + 1, // +1 for the loading indicator
        itemBuilder: (_, index) {
          if (index == productViewModel.products.length) {
            // Check if we're at the end of the list
            if (productViewModel.currentPage.value < productViewModel.totalPages.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SizedBox(); // Empty container when no more products to load
            }
          }

          final product = productViewModel.products[index];

          return ProductCard(
            weight: product.productWeight, // Assuming `weight` exists in `ProductModel`
            isShowDiscount: false,
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
}
