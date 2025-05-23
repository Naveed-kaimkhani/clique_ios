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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Our Products'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
                ProductModel? productDetails =
                    await _productViewModel.fetchProductByCode(product.sku);
                log(productDetails!.productTitle.toString());
                // _productViewModel.fetchProductByCode(product.sku);
                Get.toNamed(
                  RouteName.productDetailsScreen,
                  arguments: {
                    'uid': productDetails.id,
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // onTap: () => Get.to(() => ProductDetailScreen(product: product)),
        onTap: () {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 118,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  height: 120,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  height: 120,
                  child: const Icon(Icons.error),
                ),
              ),
            ),

            // Product Info
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Theme.of(context).primaryColor,
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
