import 'dart:developer';

import 'package:clique/components/index.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/chat/chat_list.dart';
import 'package:clique/view/profile/update_profile.dart';
import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:clique/view_model/product_view_model.dart';
import 'package:clique/view_model/stripe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/index.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserController userController = Get.find<UserController>();

  // final StripeViewModel _groupViewModel = Get.put(StripeViewModel());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
  String isUser= userController.role.value;
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar:   CustomAppBar(title: 'Profile',isNotification: isUser=="influencer",),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       
                        // SizedBox(height: size.height * 0.02), // Responsive spacing
                        Obx(() => UserProfileCard(
                          profileImage: userController.profilePhoto.value,
                          isInfluencer: false,
                          posts: 1,
                          followers: 1,
                          following: 2,
                          username: userController.userName.value,
                        )),
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: CustomButton(
                            text: 'Edit Profile',
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateProfileScreen()));

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: _SliverTabBarDelegate(
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Colors.black,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: "Cliques"),
                          Tab(text: "Products"),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Cliques Tab Content
                 ChatList(),
                  
                  // Products Tab Content
                  ProductsSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class ProductsSection extends StatelessWidget {
//       final DiscoverViewModel _viewModel = Get.find<DiscoverViewModel>();
//     // final String currentUserId = 'your_user_id_here'; // replace with actual ID or value from controller

//    ProductsSection({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.only(top: 12.0),
//       children: [
//         ProfileProductCard(
//           uid: '1',
//           backgroundImage: 'assets/png/product.png',
//           productName: "Girl's Full Blazers",
//           productDescription: "Crafted from premium, breathable cotton fabric",
//           price: 53.23,
//           oldPrice: 100.23,
//           discount: "10% OFF",
//         ),
//         ProfileProductCard(
//           uid: '2',
//           backgroundImage: 'assets/png/product2.png',
//           productName: "Girl's Full Blazers",
//           productDescription: "Crafted from premium, breathable cotton fabric",
//           price: 53.23,
//           oldPrice: 100.23,
//           discount: "10% OFF",
//         ),
//       ],
//     );
//   }
// }

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}


/////////////////////////
///
///
///
///
///
class ProductsSection extends StatelessWidget {
  
  final UserController userController = Get.find<UserController>();
   ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final DiscoverViewModel popstreamViewModel = Get.find<DiscoverViewModel>();
   final ProductViewModel productViewModel = Get.isRegistered<ProductViewModel>()
    ? Get.find<ProductViewModel>()
    : Get.put(ProductViewModel());


    return Obx(() {
      // Step 1: Filter popstreams by createdByfdsfsdf
      final String currentUserId =userController.userEmail.value; // Replace with your current user's ID
      final List<String> filteredPartyIds = popstreamViewModel.popstreams
          .where((popstream) => popstream.createdBy == currentUserId)
          .map((popstream) => popstream.partyId)
          .toSet() // Get unique partyIds
          .toList();
          log("profile sc4reen filteredPartyIds: $filteredPartyIds");
      // Step 2: Filter products by partyIds
      final filteredProducts = productViewModel.products
          .where((product) => filteredPartyIds.contains(product.id.toString()))
          .toList();

      if (productViewModel.isLoading.value ||
          popstreamViewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (filteredProducts.isEmpty) {
        return const Center(child: Text('No related products found.'));
      }

      // Step 3: Display the filtered products
      return ListView.builder(
        padding: const EdgeInsets.only(top: 12.0),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
           final discount = ((product.msrp - product.cost) / product.msrp * 100).round();

          return 
          ProfileProductCard(
            uid: product.id.toString() ,
            backgroundImage: product.imageUrls.first ,
            productName: product.productTitle ,
            productDescription: product.productDesc ,
            price: product.cost,
            oldPrice: product.msrp,
            discount:  "$discount % OFF",
          );
        },
      );
    });
  }
}
