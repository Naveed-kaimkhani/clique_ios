import 'dart:developer';

import 'package:clique/components/discover_screen_appBar.dart';
import 'package:clique/components/index.dart';
import 'package:clique/components/product_shimmer.dart';
import 'package:clique/components/shimmer_influence.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/data/models/product_model.dart';
import 'package:clique/view_model/group_view_model.dart';
import 'package:clique/view_model/influencer_viewmodel.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:clique/view_model/discover_viewmodel.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();
  final PageController controller =
      PageController(viewportFraction: 0.8, keepPage: true);
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _influencerScrollController = ScrollController();
  final InfluencerViewmodel _influencerViewModel =
      Get.put((InfluencerViewmodel()));
  final ProductViewModel _productViewModel =
      Get.isRegistered<ProductViewModel>()
          ? Get.find<ProductViewModel>()
          : Get.put(ProductViewModel());
  final GroupViewModel _groupViewModel = Get.put(GroupViewModel());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double titleFontSize = size.width * 0.05;

    return Scaffold(
      appBar: DiscoverScreenAppBar(
        title: "Discover",
        // icon: Icons.arrow_back_ios,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupSection(size, titleFontSize),
            _buildProductSection(size, titleFontSize),
            SizedBox(height: size.height * 0.02),
            _buildInfluencerSection(size, titleFontSize),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection(Size size, double titleFontSize) {
    return Container(
      height: size.height * 0.38,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSectionHeader(
              'Cliques', RouteName.viewAllCliquesScreen, titleFontSize),
          SizedBox(height: size.height * 0.015),
          _buildGroupList(size),
        ],
      ),
    );
  }

  Widget _buildProductSection(Size size, double titleFontSize) {
    return Container(
      color: Color(0xFFF7F8FA),
      child: Column(
        children: [
          _buildSectionHeader(
              'Products', RouteName.viewAllProductsScreen, titleFontSize),
          SizedBox(height: size.height * 0.015),
          _buildProductList(size),
        ],
      ),
    );
  }

  Widget _buildInfluencerSection(Size size, double titleFontSize) {
    return Column(
      children: [
        _buildSectionHeader(
            'Influencers', RouteName.viewAllInfluencersScreen, titleFontSize),
        SizedBox(height: size.height * 0.015),
        _buildInfluencerList(size),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String route, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => Get.toNamed(route),
            child: GradientText(
              "View all",
              gradient: AppColors.appGradientColors,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfluencerList(Size size) {
    return Obx(() {
      if (_influencerViewModel.isLoading.value) {
        // return _buildInfluencerShimmer(size); // Show shimmer effect while loading
        return SizedBox(
          height: size.height * 0.26,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return ShimmerInfluencerCard(); // Show shimmer effect for influencer cards
            },
          ),
        );
      }

      if (_influencerViewModel.error.value.isNotEmpty) {
        return Center(
            child: Text(_viewModel.error.value)); // Show error message if any
      }

      if (_influencerViewModel.influencers.isEmpty) {
        return Center(
            child: Text(
                'No influencers available')); // Show message if no influencers
      }

      return SizedBox(
        height: size.height * 0.26,
        child: ListView.builder(
          controller: _influencerScrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _influencerViewModel.influencers.length +
              1, // +1 for the "View All" button
          itemBuilder: (context, index) {
            if (index == _influencerViewModel.influencers.length) {
              return _buildViewAllButton(size,
                  RouteName.viewAllInfluencersScreen); // "View All" button
            }

            var influencer = _influencerViewModel.influencers[index];
            return InfluencerCard(
              isFollowing: influencer.isFollowing,
              id: influencer.id,
              influencerModel: influencer,
              backgroundImage: influencer
                  .coverPhoto, // Replace with actual image from influencer data if available
              profileImage: influencer
                  .profilePhoto, // Replace with actual profile image from influencer data if available
              name: influencer.name,
              followers:
                  '${influencer.followersCount} Followers', // Replace with actual followers count
            );
          },
        ),
      );
    });
  }

  Widget _buildProductList(Size size) {
    return Obx(() {
      if (_productViewModel.isLoading.value &&
          _productViewModel.products.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04),
          child: SizedBox(
            height: size.height * 0.32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) {
                return ShimmerProductCard();
              },
            ),
          ),
        );
      }
      if (_productViewModel.products.isEmpty) {
        return Center(child: Text('No products available'));
      }
      List<ProductModel> filteredProducts = [];
      Set<String> displayedCategories = Set<String>();

      for (var product in _productViewModel.products) {
        String category = product.categories ?? '';
        if (!displayedCategories.contains(category)) {
          filteredProducts.add(product);
          displayedCategories.add(category);
        }
      }

      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04),
        child: SizedBox(
          height: size.height * 0.32,
          child: ListView.builder(
            controller: _productScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: filteredProducts.length + 1,
            itemBuilder: (context, index) {
              if (index == filteredProducts.length) {
                return _buildViewAllButton(
                    size, RouteName.viewAllProductsScreen);
              }

              final product = filteredProducts[index];
              final discount =
                  ((product.msrp - product.cost) / product.msrp * 100).round();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: ProductCard(
                  weight: product.productWeight,
                  unit: product.unit,
                  productCode: product.productCode!,
                  tdid: product.tdid ?? "",
                  isShowDiscount: discount > 0,
                  uid: product.id.toString(),
                  categories: product.categories ?? '',
                  backgroundImage: product.imageUrls.isNotEmpty
                      ? product.imageUrls
                      : List<String>.empty(),
                  productName: product.productTitle,
                  productDescription: product.productDesc,
                  price: product.cost,
                  oldPrice: product.msrp,
                  discount: "$discount% OFF",
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildViewAllButton(Size size, String route) {
   
    return Center(
      child: GestureDetector(
        onTap: () => Get.toNamed(route),
        child: Container(
          margin: EdgeInsets.only(right: size.width * 0.06, left: 16),
          decoration: BoxDecoration(
            gradient: AppColors.appGradientColors,
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGroupList(Size size) {
    return Obx(() {
      if (_groupViewModel.isLoading.value) {
        return _buildGroupShimmer(size);
      }

      if (_groupViewModel.error.value.isNotEmpty) {
        return Center(child: Text(_viewModel.error.value));
      }

      if (_groupViewModel.groups.isEmpty) {
        return Center(child: Text('No groups available'));
      }

      return SizedBox(
        height: size.height * 0.25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _groupViewModel.groups.length + 1,
          itemBuilder: (context, index) =>
              index == _groupViewModel.groups.length
                  ? _buildViewAllButton(size, RouteName.viewAllCliquesScreen)
                  : GroupCard(
                      isJoin: _groupViewModel.groups[index].isJoined,
                      backgroundImage: AppSvgIcons.cloth,
                      profileImage: _groupViewModel.groups[index].icon,
                      name: _groupViewModel.groups[index].name,
                      followers:
                          '${_groupViewModel.groups[index].membersCount} members',
                      guid: _groupViewModel.groups[index].guid,
                      authToken: _viewModel.userController.token.value,
                      uid: _viewModel.userController.uid.value,
                      groupName: _groupViewModel.groups[index].name,
                      memberCount: _groupViewModel.groups[index].membersCount,
                    ),
        ),
      );
    });
  }

  Widget _buildGroupShimmer(Size size) {
    return SizedBox(
      height: size.height * 0.20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => _buildShimmerItem(size, index),
      ),
    );
  }

  Widget _buildShimmerItem(Size size, int index) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size.width * 0.75,
        margin: EdgeInsets.only(right: 16, left: index == 0 ? 16 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: _buildShimmerContent(size),
      ),
    );
  }

  Widget _buildShimmerContent(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: size.height * 0.1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: size.width * 0.4, height: 16, color: Colors.white),
              SizedBox(height: 8),
              Container(
                  width: size.width * 0.3, height: 12, color: Colors.white),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: size.width * 0.3, height: 24, color: Colors.white),
                  Container(
                    width: size.width * 0.2,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
