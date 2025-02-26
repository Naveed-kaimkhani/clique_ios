
import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';

class ViewAllProductsScreen extends StatelessWidget {
  const ViewAllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "All Products", icon: Icons.arrow_back_ios),
          backgroundColor: Colors.white,
          body: _buildProductGrid(context),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        key: const ValueKey('products_grid'),
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: size.width * 0.009,
          childAspectRatio: 0.6,
        ),
        itemCount: 4,
        itemBuilder: (_, index) => ProductCard(
          isShowDiscount: false,
          uid: index.toString(),
          backgroundImage: 'assets/png/product.png',
          productName: "Girl's Full Blazers",
          productDescription: "Crafted from premium, breathable cotton fabric",
          price: 53.23,
          oldPrice: 100.23,
          discount: "10% OFF",
        ),
      ),
    );
  }
}
