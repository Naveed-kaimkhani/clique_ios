
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:get/get.dart';

class ProductCard extends StatelessWidget {
  final String backgroundImage;
  final String productName;
  final String productDescription;
  final double price;
  final double oldPrice;
  final String discount;
  final Color textColor;
  final String uid;
  final bool isShowDiscount;

  const ProductCard({
    required this.backgroundImage,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.oldPrice,
    required this.discount,
    this.textColor = Colors.white,
    super.key, required this.uid, required this.isShowDiscount,
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
    final fontSizeDiscount = screenWidth * 0.03; // 3% of screen width

    return GestureDetector(
      // onTap:  () =>Get.toNamed(RouteName.productDetailsScreen),
      onTap: (){
//         Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => ProductDetailsScreen(uid: uid,)),
// );
Get.toNamed(RouteName.productDetailsScreen,arguments: uid);
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        padding: EdgeInsets.only(left: padding,bottom: padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Background Image
            Hero(
              // key: Key(uid),
              tag: uid,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  backgroundImage,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
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
                // child: SvgPicture.asset(AppSvgIcons.bag, color: AppColors.black),
                child: Icon(Icons.favorite_outline),
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
                            Text(
                              "\$${oldPrice.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: fontSizeOldPrice,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        // Discount Badge
                    isShowDiscount?    Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: padding * 0.5,
                            vertical: padding * 0.25,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.appGradientColors,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            discount,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: fontSizeDiscount,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ):Container()
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