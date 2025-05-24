import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/data/models/store_product.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductListingScreen extends StatelessWidget {
  final List<Product> products;

  ProductListingScreen({super.key, required this.products});

  final ProductViewModel _productViewModel = Get.put(ProductViewModel());

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Decide number of columns based on width (adaptive)
    int crossAxisCount = 2; // default 2 for phones
    if (screenWidth > 900) {
      crossAxisCount = 4; // large tablets/desktops
    } else if (screenWidth > 600) {
      crossAxisCount = 3; // medium tablets
    }


    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Our Products'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onAddToCart: () async {
                Get.dialog(
                  const Center(
                      child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )),
                  barrierDismissible: false,
                );
                ProductModel? productDetails =
                    await _productViewModel.fetchProductByCode(product.sku);
                if (productDetails == null) {
                  Get.back(); // close loading
                  Get.snackbar(
                    'Error',
                    'Failed to load product details. Please try again.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return; // stop further execution
                }
                log(productDetails.productTitle.toString());
                Get.back();

                Get.toNamed(
                  RouteName.productDetailsScreen,
                  arguments: {
                    'uid': productDetails.id.toString(),
                    'backgroundImage': productDetails.imageUrls,
                    'productName': productDetails.productTitle,
                    'productDescription': productDetails.productDesc,
                    'price': productDetails.cost,
                    'oldPrice': productDetails.msrp,
                    'discount': "10",
                    'unit': productDetails.unit,
                    'categories': productDetails.categories,
                    'size': productDetails.productWeight,
                    'tdid': productDetails.tdid,
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adapt image height for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust image height relative to screen width / grid count (approximation)
    int crossAxisCount = 2;
    if (screenWidth > 900) {
      crossAxisCount = 4;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    }

    final imageHeight = (screenWidth / crossAxisCount) * 0.55;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: imageHeight,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  height: imageHeight,
                  child:
                      const Center(child: CircularProgressIndicator.adaptive()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  height: imageHeight,
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: onAddToCart,
                  icon: const Text('view details'),
                  label: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
