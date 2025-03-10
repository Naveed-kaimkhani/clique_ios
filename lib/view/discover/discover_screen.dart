
import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
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
  final PageController controller = PageController(viewportFraction: 0.8, keepPage: true);
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _influencerScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double titleFontSize = size.width * 0.05;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.appGradientColors),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: 'Discover'),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
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
          _buildSectionHeader('Cliques', RouteName.viewAllCliquesScreen, titleFontSize),
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
          _buildSectionHeader('Products', RouteName.viewAllProductsScreen, titleFontSize),
          SizedBox(height: size.height * 0.015),
          _buildProductList(size),
        ],
      ),
    );
  }

  Widget _buildInfluencerSection(Size size, double titleFontSize) {
    return Column(
      children: [
        _buildSectionHeader('Influencers', RouteName.viewAllInfluencersScreen, titleFontSize),
        SizedBox(height: size.height * 0.015),
        _buildInfluencerList(size),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String route, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
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
    return SizedBox(
      height: size.height * 0.26,
      child: ListView.builder(
        controller: _influencerScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => index == 2 
          ? _buildViewAllButton(size, RouteName.viewAllInfluencersScreen)
          : InfluencerCard(
              backgroundImage: AppSvgIcons.cloth,
              profileImage: AppSvgIcons.profile,
              name: index == 0 ? 'Isabella Wilson' : 'Amelia Taylor',
              followers: '10.5k Followers',
            ),
      ),
    );
  }

  Widget _buildProductList(Size size) {
    return SizedBox(
      height: size.height * 0.38,
      child: ListView.builder(
        controller: _productScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) => index == 2
          ? _buildViewAllButton(size, RouteName.viewAllProductsScreen)
          : ProductCard(
              isShowDiscount: true,
              uid: (index + 1).toString(),
              backgroundImage: index == 0 ? 'assets/png/product.png' : 'assets/png/product2.png',
              productName: index == 0 ? "Girl's Full Blazers" : "Girl's Moisturizing Shampoo",
              productDescription: "Crafted from premium, breathable cotton fabric",
              price: 53.23,
              oldPrice: 100.23,
              discount: "10% OFF",
            ),
      ),
    );
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
      if (_viewModel.isLoading.value) {
        return _buildGroupShimmer(size);
      }
      
      if (_viewModel.error.value.isNotEmpty) {
        return Center(child: Text(_viewModel.error.value));
      }

      if (_viewModel.groups.isEmpty) {
        return Center(child: Text('No groups available'));
      }

      return SizedBox(
        height: size.height * 0.25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _viewModel.groups.length + 1,
          itemBuilder: (context, index) => index == _viewModel.groups.length
            ? _buildViewAllButton(size, RouteName.viewAllCliquesScreen)
            : GroupCard(
                backgroundImage: AppSvgIcons.cloth,
                profileImage: _viewModel.groups[index].icon,
                name: _viewModel.groups[index].name,
                followers: '${_viewModel.groups[index].membersCount} members',
                guid: _viewModel.groups[index].guid,
                authToken: _viewModel.userController.token.value,
                uid: _viewModel.userController.uid.value,
                groupName: _viewModel.groups[index].name,
                memberCount: _viewModel.groups[index].membersCount,
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
              Container(width: size.width * 0.4, height: 16, color: Colors.white),
              SizedBox(height: 8),
              Container(width: size.width * 0.3, height: 12, color: Colors.white),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: size.width * 0.3, height: 24, color: Colors.white),
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
