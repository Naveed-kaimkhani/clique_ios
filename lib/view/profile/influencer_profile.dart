



import 'package:clique/constants/index.dart';
import 'package:flutter/material.dart';

import '../../components/index.dart';

class InfluencerProfile extends StatefulWidget {
  @override
  State<InfluencerProfile> createState() => InfluencerProfileState();
}

class InfluencerProfileState extends State<InfluencerProfile>
    with SingleTickerProviderStateMixin {
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
      decoration: BoxDecoration(
        gradient: AppColors.appGradientColors,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          appBar: CustomAppBar(
            title: 'Profile',
            icon: Icons.arrow_back_ios,
          ),
          backgroundColor: Colors.white,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.02),
                      UserProfileCard(isInfluencer: true, username: "Brian Brunner"),
                      SizedBox(height: size.height * 0.02),
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
                      tabs: const [
                        Tab(
                          child: Text(
                            'Posts',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Posts Tab Content
                ListView(
                  padding: EdgeInsets.only(top: 12.0),
                  children: [
                    PostWidget(),
                    PostWidget(),
                  ],
                ),

                // Products Tab Content
                ListView(
                  padding: EdgeInsets.only(top: 12.0),
                  children: [
                    ProfileProductCard(
                      uid: '1',
                      backgroundImage: 'assets/png/product.png',
                      productName: "Girl’s Full Blazers",
                      productDescription:
                          "Crafted from premium, breathable cotton fabric",
                      price: 53.23,
                      oldPrice: 100.23,
                      discount: "10% OFF",
                    ),
                    ProfileProductCard(
                      uid: '2',
                      backgroundImage: 'assets/png/product2.png',
                      productName: "Girl’s Full Blazers",
                      productDescription:
                          "Crafted from premium, breathable cotton fabric",
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