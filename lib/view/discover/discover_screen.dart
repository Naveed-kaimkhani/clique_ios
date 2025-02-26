
import 'package:clique/components/index.dart';
import 'package:clique/constants/index.dart';
import 'package:clique/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DiscoverScreen extends StatefulWidget {
  

  const DiscoverScreen({super.key,});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final PageController controller = PageController(viewportFraction: 0.8, keepPage: true);
  final NavigationController navigationController = Get.find<NavigationController>();
  
  final ScrollController _groupScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _influencerScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double titleFontSize = size.width * 0.05; // Responsive title size

    return Container(
      // color: Colors.black,
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(title: 'Discover'),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: size.height * 0.02),
            
            
                groupList(size, titleFontSize),
            
                // SizedBox(height: size.height * 0.018),
                Container(
                  color: Color(0xFFF7F8FA),
                  child: Column(
                    children: [
                      _sectionTitle('Products',  () => Get.toNamed(RouteName.viewAllProductsScreen), titleFontSize),
                      SizedBox(height: size.height * 0.015),
                      _buildProductList(size),
                    ],
                  ),
                ),
                
                SizedBox(height: size.height * 0.02),
                _sectionTitle('Influencers',
                   () => Get.toNamed(RouteName.viewAllInfluencersScreen), titleFontSize),
              
                  SizedBox(height: size.height * 0.015),
                  _buildHorizontalList(size),
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container groupList(Size size, double titleFontSize) {
    return Container(
      height: size.height * 0.38, // Responsive height
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _sectionTitle('Cliques', () =>Get.toNamed(RouteName.viewAllCliquesScreen), titleFontSize),
          SizedBox(height: size.height * 0.015),
          _buildGroupHorizontalList(size),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, VoidCallback onViewAll, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
           TextButton(
            onPressed: onViewAll,
            child: Row(
              children: [
                GradientText(
                  "View all",
                  gradient: AppColors.appGradientColors,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
                // Icon(Icons.arrow_forward, color: Colors.blue, size: MediaQuery.of(context).size.width * 0.05),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(Size size) {
    return SizedBox(
      height: size.height * 0.26,
      child: ListView.builder(
        controller: _influencerScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 3, // 2 cards + 1 arrow button
        itemBuilder: (context, index) {
          if (index == 2) {
            return Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(RouteName.viewAllInfluencersScreen),
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
          return InfluencerCard(
            backgroundImage: AppSvgIcons.cloth,
            profileImage: AppSvgIcons.profile,
            name: index == 0 ? 'Isabella Wilson' : 'Amelia Taylor',
            followers: '10.5k Followers',
          );
        },
      ),
    );
  }

  Widget _buildProductList(Size size) {
    return SizedBox(
      height: size.height * 0.38,
      child: ListView.builder(
        controller: _productScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 3, // 2 cards + 1 arrow button
        itemBuilder: (context, index) {
          if (index == 2) {
            return Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(RouteName.viewAllProductsScreen),
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
          return ProductCard(
            isShowDiscount: true,
            uid: (index + 1).toString(),
            backgroundImage: index == 0 ? 'assets/png/product.png' : 'assets/png/product2.png',
            productName: index == 0 ? "Girl's Full Blazers" : "Girl's Moisturizing Shampoo",
            productDescription: "Crafted from premium, breathable cotton fabric",
            price: 53.23,
            oldPrice: 100.23,
            discount: "10% OFF",
          );
        },
      ),
    );
  }

  Widget _buildGroupHorizontalList(Size size) {
    return SizedBox(
      height: size.height * 0.25,
      child: ListView.builder(
        controller: _groupScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 3, // 2 cards + 1 arrow button
        itemBuilder: (context, index) {
          if (index == 2) {
            return Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(RouteName.viewAllCliquesScreen),
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
          return GroupCard(
            backgroundImage: AppSvgIcons.cloth,
            profileImage: AppSvgIcons.profile,
            name: index == 0 ? 'MenswearDog' : 'Pet Health',
            followers: index == 0 ? '1200 members' : '10.5k Followers',
          );
        },
      ),
    );
  }
}
