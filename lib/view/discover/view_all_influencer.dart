import 'package:clique/components/clique_tab_card.dart';
import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';

class ViewAllInfluencersScreen extends StatelessWidget {
  const ViewAllInfluencersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "All Influencers", icon: Icons.arrow_back_ios),
          backgroundColor: Colors.white,
          body: _buildInfluencersGrid(context),
        ),
      ),
    );
  }

  Widget _buildInfluencersGrid(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        key: const ValueKey('influencers_grid'),
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: size.width * 0.02,
          mainAxisSpacing: size.height * 0.03,
          childAspectRatio: 0.6,
        ),
        itemCount: 12,
        itemBuilder: (_, index) => InfluencerCard(
          backgroundImage: AppSvgIcons.cloth,
          profileImage: AppSvgIcons.profile,
          name: 'Isabella Wilson',
          followers: '10.5k Followers',
        ),
      ),
    );
  }
}

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

class ViewAllCliquesScreen extends StatelessWidget {
  const ViewAllCliquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: "All Cliques", icon: Icons.arrow_back_ios),
          backgroundColor: Colors.white,
          body: _buildCliquesList(),
        ),
      ),
    );
  }

  Widget _buildCliquesList() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: const ValueKey('groups_list'),
        padding: const EdgeInsets.all(10),
        itemCount: 12,
        itemBuilder: (_, index) => CliqueTabCard(
          backgroundImage: AppSvgIcons.cloth,
          profileImage: AppSvgIcons.profile,
          name: 'MenswearDog',
          followers: '1200 members',
        ),
      ),
    );
  }
}
