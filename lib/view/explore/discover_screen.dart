import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/gradient_text.dart';
import 'package:clique/components/group_card.dart';
import 'package:clique/components/influencer_card.dart';
import 'package:clique/components/product_card.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
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
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double titleFontSize = size.width * 0.05; // Responsive title size

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: 'Discover',),
                SizedBox(height: size.height * 0.02),
            
                _sectionTitle('Influencers',
                   () => navigationController.changeIndex(2,0), titleFontSize),
                SizedBox(height: size.height * 0.015),
                _buildHorizontalList(size),
            
                SizedBox(height: size.height * 0.033),
                groupList(size, titleFontSize),
            
                SizedBox(height: size.height * 0.018),
                _sectionTitle('Products',  () => navigationController.changeIndex( 2,2), titleFontSize),
                SizedBox(height: size.height * 0.015),
                _buildProductList(size),
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
      color: Color(0xFFF7F8FA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _sectionTitle('Cliques', () => navigationController.changeIndex(2,1), titleFontSize),
          SizedBox(height: size.height * 0.015),
          _buildGroupHorizontalList(size),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, VoidCallback onViewAll, double fontSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
           TextButton(
            onPressed: onViewAll,
            child: GradientText(
              "View all",
              gradient: AppColors.appGradientColors,
              fontSize:MediaQuery.of(context).size.width* 0.04, // Responsive font size (4% of screen width)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(Size size) {
    return SizedBox(
      height: size.height * 0.26,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          InfluencerCard(
            backgroundImage: AppSvgIcons.cloth,
            profileImage: AppSvgIcons.profile,
            name: 'Isabella Wilson',
            followers: '10.5k Followers',
          ),
          InfluencerCard(
            backgroundImage: AppSvgIcons.cloth,
            profileImage: AppSvgIcons.profile,
            name: 'Amelia Taylor',
            followers: '10.5k Followers',
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(Size size) {
    return SizedBox(
      height: size.height * 0.38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ProductCard(
            isShowDiscount: true,
            uid: '1',
            backgroundImage: 'assets/png/product.png',
            productName: "Girl's Full Blazers",
            productDescription: "Crafted from premium, breathable cotton fabric",
            price: 53.23,
            oldPrice: 100.23,
            discount: "10% OFF",
          ),
          ProductCard(
            isShowDiscount: true,
            uid: '2',
            backgroundImage: 'assets/png/product2.png',
            productName: "Girl's Moisturizing Shampoo",
            productDescription: "Crafted from premium, breathable cotton fabric",
            price: 53.23,
            oldPrice: 100.23,
            discount: "10% OFF",
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHorizontalList(Size size) {
    return SizedBox(
      height: size.height * 0.25,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GroupCard(
            backgroundImage: AppSvgIcons.cloth,
            profileImage: AppSvgIcons.profile,
            name: 'MenswearDog',
            followers: '1200 members',
          ),
          GroupCard(
            backgroundImage: AppSvgIcons.cloth,
            profileImage: AppSvgIcons.profile,
            name: 'Pet Health',
            followers: '10.5k Followers',
          ),
        ],
      ),
    );
  }
}
