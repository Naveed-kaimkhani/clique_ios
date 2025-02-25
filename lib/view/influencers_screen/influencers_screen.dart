
import 'package:clique/components/clique_tab_card.dart';
import 'package:clique/controller/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/index.dart';
import '../../constants/index.dart';

class InfluencersScreen extends StatefulWidget {
  final int initialTabIndex;

  const InfluencersScreen({
    super.key, 
    required this.initialTabIndex,
  });

  @override
  State<InfluencersScreen> createState() => _InfluencersScreenState();
}

class _InfluencersScreenState extends State<InfluencersScreen> with SingleTickerProviderStateMixin {
  static const _tabCount = 3;

  late final TabController _tabController;
  late final NavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = Get.put(NavigationController());
    _initializeTabController();
  }

  void _initializeTabController() {
    _tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    
    _tabController.addListener(() {
      _navigationController.tabController.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: 'Influencers'),
          backgroundColor: Colors.white,
          body: _buildNestedScrollView(context),
        ),
      ),
    );
  }

  Widget _buildNestedScrollView(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        _buildHeader(context),
        _buildTabBar(),
      ],
      body: TabBarView(
        controller: _tabController,
        // physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          InfluencersGridView(),
          GroupGridView(),
          ProductGridView(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }

  SliverPersistentHeader _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.grey,
          tabAlignment: TabAlignment.fill,
          splashBorderRadius: BorderRadius.circular(8),
          tabs: const [
            Tab(text: "Influencers"),
            Tab(text: "Cliques"), 
            Tab(text: "Products"),
          ],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _SliverTabBarDelegate(this.tabBar);

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
    return tabBar != oldDelegate.tabBar;
  }
}

class InfluencersGridView extends StatelessWidget {
  const InfluencersGridView({super.key});

  @override
  Widget build(BuildContext context) {
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
        itemBuilder: (_, index) =>  InfluencerCard(
          backgroundImage: AppSvgIcons.cloth,
          profileImage: AppSvgIcons.profile,
          name: 'Isabella Wilson',
          followers: '10.5k Followers',
        ),
      ),
    );
  }
}

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
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

class GroupGridView extends StatelessWidget {
  const GroupGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: const ValueKey('groups_list'),
        padding: const EdgeInsets.all(10),
        itemCount: 12,
        itemBuilder: (_, index) =>  CliqueTabCard(
          backgroundImage: AppSvgIcons.cloth,
          profileImage: AppSvgIcons.profile,
          name: 'MenswearDog',
          followers: '1200 members',
        ),
      ),
    );
  }
}




