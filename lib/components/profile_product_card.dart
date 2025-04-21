import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProfileProductCard extends StatelessWidget {
  final String uid;
  final List<String> backgroundImage;
  final String productName;
  final String productDescription;
   var price;
   var oldPrice;
  final String discount;
  
  final String size;
  
  final String categories;
  
  final String unit;
  final Color textColor;

   ProfileProductCard({
    required this.size,
    required this.backgroundImage,
    required this.productName,
    
    required this.categories,
    required this.unit,
    required this.productDescription,
    required this.price,
    required this.oldPrice,
    required this.discount,
    this.textColor = Colors.white,
    super.key, required this.uid,
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
    final fontSizeOldPrice = screenWidth * 0.035; // 3.5% of screen width
    // final fontSizeDiscount = screenWidth * 0.03; // 3% of screen width

    return GestureDetector(
      onTap:  () =>  Get.toNamed(
    RouteName.productDetailsScreen,
    arguments: {
      'uid': uid,
      'backgroundImage': backgroundImage,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'oldPrice': oldPrice,
      'discount': discount,
      'unit': unit, 
      'categories':categories,
      'size': size,

    },
  ),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        padding: EdgeInsets.only(left: padding, right: padding, bottom: padding),
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
      color: Colors.grey, // or Colors.black if you want a dark shimmer
    ),
  ),
  errorWidget: (context, url, error) => const Icon(Icons.error),
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
      
            // Cart Icon (Top Right)
            Positioned(
              top: padding,
              right: padding,
              child: Container(
                padding: EdgeInsets.all(padding * 0.5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(AppSvgIcons.bag, color: AppColors.black),
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
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
  productDescription,
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
                              "\$${price.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: textColor,
                                fontSize: fontSizePrice,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: padding * 0.5),
                            // Text(
                            //   "\$${oldPrice.toStringAsFixed(2)}",
                            //   style: TextStyle(
                            //     color: textColor.withOpacity(0.7),
                            //     fontSize: fontSizeOldPrice,
                            //     decoration: TextDecoration.lineThrough,
                            //   ),
                            // ),
                            Stack(
  children: [
    Text(
      "\$${oldPrice.toStringAsFixed(2)}",
      style: TextStyle(
        color: textColor.withOpacity(0.7),
        fontSize: fontSizeOldPrice,
      ),
    ),
    Positioned(
      top: fontSizeOldPrice * 0.8, // Positioning the line at the center of text
      left: 0,
      right: 0,
      child: Container(
        height: 1, // Thickness of line
        color: Colors.white, // Custom color for line
      ),
    ),
  ],
)
                          ],
                        ),
                        // Discount Badge
                        // Container(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: padding * 0.5,
                        //     vertical: padding * 0.25,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     gradient: AppColors.appGradientColors,
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Text(
                        //     discount,
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: fontSizeDiscount,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
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
}