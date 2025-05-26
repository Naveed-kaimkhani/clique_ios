import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clique/components/organic_treats_widget.dart';
import 'package:clique/components/shop_all_widget.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view/product/product_listing_screen.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ShoppingWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final PopstreamModel popstream;
  final VoidCallback onTap;
  final VoidCallback resumeVideo;

  const ShoppingWidget({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.popstream,
    required this.onTap,
    required this.resumeVideo,
  }) : super(key: key);

  @override
  State<ShoppingWidget> createState() => _ShoppingWidgetState();
}

class _ShoppingWidgetState extends State<ShoppingWidget> {
  final ProductViewModel _productViewModel = Get.put(ProductViewModel());
  final userController = Get.find<UserController>();

  bool _isLoading = false;

  void _navigateToAllProducts() {
    widget.onTap();
    // Get.toNamed(RouteName.viewAllProductsScreen);

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductListingScreen(
              products: widget.popstream.storeProduct.first.products,
            )));
  }

  Future<void> _navigateToProductDetails() async {
    widget.onTap();

    try {
      final ProductModel? matchingProduct =
          _productViewModel.products.firstWhereOrNull(
        (product) => product.id.toString() == widget.popstream.partyId,
      );

      ProductModel? product = matchingProduct;
      setState(() {
        _isLoading = true;
      });
      product ??= await _productViewModel.fetchProductByCode(
          widget.popstream.storeProduct.first.products.first.sku);
      // If not found locally, fetch from API

      if (product != null) {
        Get.toNamed(
          RouteName.productDetailsScreen,
          arguments: _buildProductArguments(product),
        );
      } else {
        Utils.showCustomSnackBar(
            'Not Found', 'Product not found for this id.', ContentType.failure);
        //  Get.showSnackbar()
      }
    } catch (e) {
      Utils.showCustomSnackBar(
          'Not Found', 'Product not found for this id.', ContentType.failure);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: widget.screenHeight * 0.12,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                onTap: _navigateToAllProducts,
                child: ShopAllWidget(
                  popstream: widget.popstream,
                ),
                width: widget.screenWidth * 0.2,
              ),
              // _buildButton(
              //   onTap: _navigateToProductDetails,
              //   child: OrganicTreatsWidget(popstream: widget.popstream),
              //   width: widget.screenWidth * 0.65,
              // ),
              _buildButton(
                onTap: _navigateToAllProducts,
                width: widget.screenWidth * 0.35,
                child: CarouselSlider.builder(
                  itemCount:
                      widget.popstream.storeProduct.first.products.length,
                  itemBuilder: (context, index, realIndex) {
                    final product =
                        widget.popstream.storeProduct.first.products[index];
                    return OrganicTreatsWidget(
                      popstream: widget.popstream,
                            product: product, // Pass this to customize

                    );
                  },
                  options: CarouselOptions(
                    height: widget.screenHeight * 0.14,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    enableInfiniteScroll: true,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    required Widget child,
    required double width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: widget.screenHeight * 0.14,
        width: width,
        padding: EdgeInsets.all(widget.screenWidth * 0.02),
        margin: EdgeInsets.symmetric(horizontal: widget.screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: child,
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return AbsorbPointer(
      absorbing: true,
      child: Container(
        color: Colors.black.withOpacity(0.4),
        alignment: Alignment.center,
        child: const SpinKitFadingCircle(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
