import 'package:clique/components/index.dart';
import 'package:clique/components/product_section.dart';
import 'package:clique/components/profile_appBar.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/chat/chat_list.dart';
import 'package:clique/view/profile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
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
    String isUser = userController.role.value;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileSAppBar(
        title: 'Profile',
        isInfluencer: isUser == "influencer",
      ),
      // backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.02), // Responsive spacing
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProfileScreen()));
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
            ProductsSection(
              userEmail: userController.userEmail.value,
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
