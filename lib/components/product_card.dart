
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final List<String> backgroundImage;
  final String productName;
  final String productDescription;
   var price;
  var oldPrice;
  final String discount;
  final String categories;
  
  final String weight;
  final Color textColor;
  final String uid;
  
  final String unit;
  final bool isShowDiscount;

  final FavoriteController favoriteController = Get.put(FavoriteController());
   ProductCard({
    required this.weight,
    required this.categories,
    required this.unit,
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

    final size = MediaQuery.of(context).size;
    // Get screen width and height using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive dimensions
    final cardWidth = screenWidth * 0.6; // 60% of screen width
    final cardHeight = screenHeight * 0.35; // 35% of screen height
    final padding = screenWidth * 0.03; // 3% of screen width
    final fontSizeTitle = screenWidth * 0.038; // 5% of screen width
    final fontSizeDescription = screenWidth * 0.03; // 3% of screen width
    final fontSizePrice = screenWidth * 0.04; // 4% of screen width
    final fontSizeOldPrice = screenWidth * 0.035; // 3.5% of screen width
    // final fontSizeDiscount = screenWidth * 0.03; // 3% of screen width

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.only(bottom: padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
    
    
    GestureDetector(
   
        onTap: (){
       
  Get.toNamed(
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
      'size':weight,
    },
  );

      },
    
      child: Hero(
        tag: uid,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
      children: [
        CachedNetworkImage(
          imageUrl: backgroundImage.first,
          width: double.infinity,
          height: 276,
          fit: BoxFit.cover,
          placeholder: (context, url) => LoadImageShimmer(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          width: double.infinity,
          height: 276,
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
    ),
    
    
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
              child: Obx(() {
      final isLiked = favoriteController.isFavorite(uid);
      return LikeButton(
        size: size.width * 0.06,
        isLiked: isLiked,
        onTap: (bool liked) async {

          favoriteController.toggleFavorite(uid);
          return !liked;
        },
        likeBuilder: (bool liked) {
          return Icon(
            liked ? Icons.favorite : Icons.favorite_border,
            color: liked ? AppColors.appColor : Colors.black,
            size: size.width * 0.07,
          );
        },
      );
    }),
            ),
          ),
// Product Details (Bottom)
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: GestureDetector(
             
                      onTap: (){
                     
                Get.toNamed(
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
                    'size':weight,
                  },
                );
              
                    },
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
                    // SizedBox(height: padding * 0.5),
                    Text(
                      Utils.removeHtmlTags(productDescription),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: fontSizeDescription,
                      ),
                    ),
                    
                    SizedBox(height: screenWidth * 0.01),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadImageShimmer extends StatelessWidget {
  const LoadImageShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 276,
          color: Colors.white,
        ),
      );
  }
}