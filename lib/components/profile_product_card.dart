import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProfileProductCard extends StatelessWidget {
  final String uid;
  final List<String> backgroundImage;
  final String productName;
  final String productDescription;
  var price;
  var oldPrice;
  final String discount;
  final String tdid;
  final String size;
  final String categories;
  final String unit;
  final Color textColor;

  final ProductViewModel _productViewModel = Get.put(ProductViewModel());
  ProfileProductCard({
    required this.size,
    required this.backgroundImage,
    required this.productName,
    required this.tdid,
    required this.categories,
    required this.unit,
    required this.productDescription,
    required this.price,
    required this.oldPrice,
    required this.discount,
    this.textColor = Colors.white,
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final cardWidth = screenWidth * 0.6; // 60% of screen width
    final cardHeight = screenHeight * 0.35; // 35% of screen height
    final padding = screenWidth * 0.03; // 3% of screen width
    final fontSizeTitle = screenWidth * 0.05; // 5% of screen width
    final fontSizeDescription = screenWidth * 0.03; // 3% of screen width
    final fontSizePrice = screenWidth * 0.04; // 4% of screen width
    // final fontSizeDiscount = screenWidth * 0.03; // 3% of screen width

    return GestureDetector(
      onTap: () async {
// apply searching here
        Get.dialog(
          const Center(
              child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          )),
          barrierDismissible: false,
        );
        ProductModel? product = await _productViewModel.fetchProductByCode(uid);
        // If not found locally, fetch from API
        Get.back();
        if (product != null) {
          Get.toNamed(
            RouteName.productDetailsScreen,
            arguments: _buildProductArguments(product),
          );
        } else {
          Utils.showCustomSnackBar('Not Found',
              'Product not found for this id.', ContentType.failure);
          //  Get.showSnackbar()
        }
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        padding:
            EdgeInsets.only(left: padding, right: padding, bottom: padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Hero(
              tag: uid,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: backgroundImage.first,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors
                              .grey, // or Colors.black if you want a dark shimmer
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Container(
                      width: double.infinity,
                      height: cardWidth * 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Details (Bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: padding * 0.5),
                    Text(
                      Utils.removeHtmlTags(productDescription),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: fontSizeDescription,
                      ),
                    ),
                    SizedBox(height: padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Row(
                          children: [
                            Text(
                              "\$${price}",
                              style: TextStyle(
                                color: textColor,
                                fontSize: fontSizePrice,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: padding * 0.5),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _buildProductArguments(ProductModel product) {
    return {
      'uid': product.id.toString(),
      'backgroundImage': product.imageUrls,
      'productName': product.productTitle,
      'productDescription': product.productDesc,
      'price': product.cost,
      'oldPrice': product.msrp,
      'discount': '',
      'unit': product.unit,
      'categories': product.categories,
      'size': product.productWeight,
      'tdid': product.tdid,
    };
  }
}
