

import 'package:clique/components/custom_appbar.dart';
import 'package:clique/components/custom_button.dart';
import 'package:clique/components/profile_product_card.dart';
import 'package:clique/components/user_profile_card.dart';
import 'package:clique/view/chat/chat_list.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

    return Container(
      color: Colors.black,
      child: SafeArea(
        
        child: Scaffold(
          appBar:   CustomAppBar(title: 'Profile', icon: Icons.arrow_back_ios),
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
                        UserProfileCard(isInfluencer: false),
                        SizedBox(height: size.height * 0.02),
                        Center(
                          child: CustomButton(
                            text: 'Edit Profile',
                            onTap: () {},
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
                  ListView(
                    padding: EdgeInsets.only(top: 12.0),
                    children: [
                      ProfileProductCard(
                        uid: '1',
                        backgroundImage: 'assets/png/product.png',
                        productName: "Girl’s Full Blazers",
                        productDescription: "Crafted from premium, breathable cotton fabric",
                        price: 53.23,
                        oldPrice: 100.23,
                        discount: "10% OFF",
                      ),
                      ProfileProductCard(
                        uid: '2',
                        backgroundImage: 'assets/png/product2.png',
                        productName: "Girl’s Full Blazers",
                        productDescription: "Crafted from premium, breathable cotton fabric",
                        price: 53.23,
                        oldPrice: 100.23,
                        discount: "10% OFF",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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