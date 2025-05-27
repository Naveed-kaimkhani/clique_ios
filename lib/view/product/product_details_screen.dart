import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clique/components/category_product_card.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/components/product_shimmer.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view/profile/update_profile_screen.dart';
import 'package:clique/view_model/cart_quantity_controller.dart';
import 'package:clique/view_model/favorite_controller.dart';
import 'package:clique/view_model/product_details_controller.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final selectedImageIndex = 0.obs;

  final ProductController controller = Get.put(ProductController());

  final FavoriteController favoriteController = Get.put(FavoriteController());

  final cartItemCount = 0.obs;

  final isAnimating = false.obs;

  final userController = Get.find<UserController>();

  final ProductViewModel _productViewModel = Get.find<ProductViewModel>();

  final cartQuantityController = Get.find<CartQuantityController>();
  @override
  void initState() {
    super.initState();

    if (controller.productData.isEmpty) {
      if (Get.arguments != null) {
        controller.setProductData(Get.arguments);
      } else {
        // Navigate back since there's no valid data to show
        Future.microtask(() =>
            Get.back()); // Use Future.microtask to avoid setState during build
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // controller.setProductData(Get.arguments);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildProductView(size, context),
        ],
      ),
    );
  }

  Widget _buildProductView(Size size, context) {
    return SizedBox(
      height: size.height,
      child: Stack(
        children: [
          _buildHeroImage(size),
          _buildTopBar(size, context),
          _buildImageSelector(size),
          _buildProductDetails(size),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Size size) {
    final TransformationController _transformationController =
        TransformationController();
    final _dragStartOffset = 0.0.obs;

    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Obx(() => Hero(
            tag: controller.productData['uid'],
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
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: CachedNetworkImage(
                      key: ValueKey<int>(controller.selectedImageIndex.value),
                      imageUrl: controller
                          .productImages[controller.selectedImageIndex.value],
                      fit: BoxFit.cover,
                      width: size.width,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: size.width,
                          height:
                              size.height * 0.4, // Adjust the height as needed
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildTopBar(Size size, context) {
    return Positioned(
      top: size.height * 0.05,
      left: size.width * 0.015,
      right: size.width * 0.04,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(Icons.arrow_back_ios, () => Get.back()),
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
                    controller.productImages.length,
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
                    child: _buildImageThumbnail(
                        size, controller.selectedImageIndex.value),
                  ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () => isExpanded.toggle(),
                  icon: Icon(
                      isExpanded.value
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black54),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildImageThumbnail(Size size, int index) {
    return GestureDetector(
      onTap: () => controller.selectedImageIndex.value = index,
      child: Obx(() => Container(
            margin: EdgeInsets.only(bottom: size.height * 0.01),
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
              child: CachedNetworkImage(
                imageUrl: controller.productImages[index],
                width: size.width * 0.11,
                height: size.height * 0.07,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: size.width * 0.11,
                    height: size.height * 0.07,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 20),
              ),
            ),
          )),
    );
  }

  Widget _buildProductDetails(Size size) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      // maxChildSize: 0.95,

      maxChildSize: 1,
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
                            SizedBox(height: size.height * 0.01),
                            _buildDescriptionSection(size),
                            SizedBox(height: size.height * 0.015),
                            SizedBox(height: size.height * 0.02),
                            _buildAddToCartButton(size, context),
                            _buildProductSection(size, size.width * 0.06),
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

  Widget _buildProductSection(Size size, double titleFontSize) {
    return Container(
      color: Color(0xFFF7F8FA),
      child: Column(
        children: [
          // _buildSectionHeader('Products', RouteName.viewAllProductsScreen, titleFontSize),
          SizedBox(height: size.height * 0.015),
          _buildProductList(size),
        ],
      ),
    );
  }

  Widget _buildProductList(Size size) {
    final ScrollController _productScrollController = ScrollController();

    return Obx(() {
      if (_productViewModel.isLoading.value &&
          _productViewModel.products.isEmpty) {
        return SizedBox(
          height: size.height * 0.32,

          // height: size.height * 0.5,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              return ShimmerProductCard();
            },
          ),
        );
      }

      if (_productViewModel.error.value.isNotEmpty) {
        return Center(child: Text(_productViewModel.error.value));
      }

      if (_productViewModel.products.isEmpty) {
        return Center(child: Text('No products available'));
      }

      // ✅ Filter only products where category == "pet food"
      final filteredProducts = _productViewModel.products
          .where((product) =>
              (product.categories) == controller.productData['categories'])
          .toList();

      if (filteredProducts.isEmpty) {
        return Center(
            child: Text(
                'No products in "${controller.productData['categories']}" category'));
      }

      return SizedBox(
        height: size.height * 0.32,
        child: ListView.builder(
          controller: _productScrollController,
          scrollDirection: Axis.horizontal,
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final discount =
                ((product.msrp - product.cost) / product.msrp * 100).round();

            return ProductCategoryCard(
              uid: product.id.toString(),
              backgroundImage: product.imageUrls.isNotEmpty
                  ? product.imageUrls
                  : List<String>.empty(),
              productName: product.productTitle,
              productDescription: product.productDesc,
              price: product.cost,
              oldPrice: product.msrp,
              discount: "$discount% OFF",
              weight: product.productWeight,
              unit: product.unit,
              isShowDiscount: false,
              categories: product.categories ?? "",
            );
          },
        ),
      );
    });
  }

  Widget _buildProductTitle(Size size) {
    return Obx(() => Text(
          controller.productData['productName'],
          style: TextStyle(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _buildPriceSection(Size size) {
    return Obx(() => Row(
          children: [
            GradientText(
              "\$${controller.productData['price'].toString()}",
              gradient: AppColors.appGradientColors,
              fontSize: size.width * 0.06,
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              "\$${controller.productData['oldPrice'].toString()}",
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ));
  }

  var isDescriptionExpanded = false.obs;

  Widget _buildDescriptionSection(Size size) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              removeHtmlTags(controller.productData['productDescription']),
              style: TextStyle(
                fontSize: size.width * 0.04,
                color: Colors.grey,
              ),
              maxLines: isDescriptionExpanded.value ? null : 2,
              overflow: TextOverflow.fade,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          GestureDetector(
            onTap: () {
              isDescriptionExpanded.toggle();
            },
            child: GradientText(
              isDescriptionExpanded.value ? "Read Less <<" : "Read More >>",
              gradient: AppColors.appGradientColors,
              fontSize: size.width * 0.04,
            ),
          ),
        ],
      );
    });
  }

  String removeHtmlTags(String text) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return text.replaceAll(exp, '');
  }

  Widget _buildAddToCartButton(Size size, context) {
    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        height: size.height * 0.064,
        child: ElevatedButton.icon(
          onPressed: () {
            if (userController.phone.value.isNotEmpty) {
              final product = ProductModel(
                id: int.parse(controller.productData['uid']),
                tdid: controller.productData['tdid'],
                productWeight: controller.productData['size'],
                productTitle: controller.productData['productName'],
                productDesc: controller.productData['productDescription'],
                brandName: controller.productData['productName'],
                unit: controller.productData['unit'],
                cost: controller.productData['price'],
                msrp: controller.productData['oldPrice'],
                productCode: controller.productData['product_code'],
                imageUrls: controller.productData['backgroundImage'],
                thumbnailUrl: controller.productData['backgroundImage'][0],
                categories: controller.productData['categories'],
              );
              cartQuantityController.addProduct(product);
            } else {
              Utils.showCustomSnackBar(
                  "Warning",
                  "Please enter your phone number to checkout",
                  ContentType.warning);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen()));
            }
          },
          icon: Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            "Add to cart",
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
