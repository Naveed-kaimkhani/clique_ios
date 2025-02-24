import 'package:clique/components/gradient_text.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/controller/fav_controller.dart';
import 'package:clique/controller/size_selector.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';

class ProductDetailsScreen extends StatelessWidget {
  final selectedImageIndex = 0.obs;
  final List<String> productImages = [
    'assets/png/product.jpg',
    'assets/png/blezer.png',
    'assets/png/product.jpg',
    'assets/png/product.jpg',
  ];
  final String uid = Get.arguments;
  final FavoriteController favoriteController = Get.put(FavoriteController());
  final cartItemCount = 0.obs;
  final isAnimating = false.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildProductView(size),
        ],
      ),
    );
  }

  Widget _buildProductView(Size size) {
    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          _buildHeroImage(size),
          _buildTopBar(size),
          _buildImageSelector(size),
          _buildProductDetails(size),
          _buildDiscountTag(size),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Size size) {
    final TransformationController _transformationController = TransformationController();
    final _dragStartOffset = 0.0.obs;

    return Obx(() => Hero(
      tag: uid,
      child: GestureDetector(
        onVerticalDragStart: (details) {
          _dragStartOffset.value = details.localPosition.dy;
        },
        onVerticalDragUpdate: (details) {
          if (details.localPosition.dy - _dragStartOffset.value > 100) {
            Get.back();
          }
        },
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1.0,
          maxScale: 4.0,
          child: SizedBox(
            width: size.width,
            height: size.height * 0.6,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Image.asset(
                productImages[selectedImageIndex.value],
                key: ValueKey<int>(selectedImageIndex.value),
                fit: BoxFit.cover,
                width: size.width,
              ),
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildTopBar(Size size) {
    return Positioned(
      top: size.height * 0.05,
      left: size.width * 0.04,
      right: size.width * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(Icons.arrow_back, () => Get.back()),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: LikeButton(
                  size: size.width * 0.06,
                  isLiked: favoriteController.isFavorite.value,
                  onTap: (isLiked) async {
                    favoriteController.toggleFavorite();
                    return !isLiked;
                  },
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? AppColors.appColor : Colors.black,
                      size: size.width * 0.07,
                    );
                  },
                ),
                )
              ),
              SizedBox(width: size.width * 0.02),
              Stack(
                children: [
                  Obx(() => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    transform: isAnimating.value 
                        ? Matrix4.translationValues(0, -10, 0)
                        : Matrix4.translationValues(0, 0, 0),
                    child: _iconButton(
                      Icons.shopping_cart_outlined,
                      () {
                        isAnimating.value = true;
                        cartItemCount.value++;
                        Future.delayed(Duration(milliseconds: 300), () {
                          isAnimating.value = false;
                        });
                      },
                    ),
                  )),
                  if (cartItemCount.value > 0)
                    Positioned(
                      right: 0,
                      child: Obx(() => Container(
                        padding: EdgeInsets.all(4),
                        margin:  EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cartItemCount.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.03,
                          ),
                        ),
                      )),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildImageSelector(Size size) {
    final isExpanded = false.obs;
    
    return Positioned(
      top: size.height * 0.11,
      right: size.width * 0.04,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isExpanded.value)
              ...List.generate(
                productImages.length,
                (index) => _buildImageThumbnail(size, index),
              ).map((widget) => Padding(
                padding: EdgeInsets.only(bottom: size.height * 0.005),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget,
                ),
              ))
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageThumbnail(size, selectedImageIndex.value),
              ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              onPressed: () => isExpanded.toggle(),
              icon: Icon(
                isExpanded.value 
                  ? Icons.keyboard_arrow_up 
                  : Icons.keyboard_arrow_down,
                color: Colors.black54
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildImageThumbnail(Size size, int index) {
    return GestureDetector(
      onTap: () => selectedImageIndex.value = index,
      child: Obx(() => Container(
        margin: EdgeInsets.only(bottom: size.height * 0.01),
        // padding: EdgeInsets.all(size.width * 0.01),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedImageIndex.value == index
                ? AppColors.appColor
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            productImages[index],
            width: size.width * 0.11,
            height: size.height * 0.07,
            fit: BoxFit.cover,
          ),
        ),
      )),
    );
  }

  Widget _buildProductDetails(Size size) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          width: size.width,
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<Offset>(
                    begin: const Offset(0, 1), // Start from bottom
                    end: const Offset(0, 0), // End at original position
                  ),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, Offset offset, child) {
                    return Transform.translate(
                      offset: offset * 150,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 800),
                        opacity: 1.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProductTitle(size),
                            SizedBox(height: size.height * 0.006),
                            _buildPriceSection(size),
                            SizedBox(height: size.height * 0.01),
                            _buildRatingSection(size),
                            SizedBox(height: size.height * 0.01),
                            _buildDescriptionSection(size),
                            SizedBox(height: size.height * 0.015),
                            SizeSelector(),
                            SizedBox(height: size.height * 0.05),
                            _buildAddToCartButton(size),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductTitle(Size size) {
    return Text(
      "Girl's Full Blazers",
      style: TextStyle(
        fontSize: size.width * 0.08,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPriceSection(Size size) {
    return Row(
      children: [
        GradientText(
          "\$53.23",
          gradient: AppColors.appGradientColors,
          fontSize: size.width * 0.06,
        ),
        SizedBox(width: size.width * 0.02),
        Text(
          "\$100.23",
          style: TextStyle(
            fontSize: size.width * 0.05,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(Size size) {
    return Row(
      children: [
        Icon(Icons.star, color: Colors.orange, size: size.width * 0.05),
        SizedBox(width: size.width * 0.01),
        Text(
          "4.9 (321 Reviews)",
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Crafted from premium, breathable cotton fabric",
          style: TextStyle(
            fontSize: size.width * 0.04,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        GradientText(
          "Read More>>",
          gradient: AppColors.appGradientColors,
          fontSize: size.width * 0.04,
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(Size size) {
    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.064,
        child: ElevatedButton.icon(
          onPressed: () => Get.toNamed(RouteName.cartScreen, arguments: uid),
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            "Add to Cart",
            style: TextStyle(
              fontSize: size.width * 0.04,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountTag(Size size) {
    return Positioned(
      top: size.height * 0.52,
      right: size.width * 0.04,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.01,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.appGradientColors,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '10% OFF',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.04,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}