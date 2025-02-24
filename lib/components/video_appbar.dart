import 'package:clique/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MyResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController _tabController;

  const MyResponsiveAppBar({Key? key, required TabController tabController})
      : _tabController = tabController,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight * 0.3, // 6% of screen height
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appGradientColors,
        ),
      ),
      centerTitle: true,
      title: Text(
        "CLIQUE",
        style: TextStyle(
      
          color: Colors.white,
          fontSize: screenWidth * 0.05, // Adjust font size based on screen width
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        isScrollable: true, // Allow scrolling on smaller screens
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(fontSize: screenWidth * 0.04), // Adjust tab font size
        tabs: [
          Tab(text: "Pet Food"),
          Tab(text: "Pull Toys"),
          Tab(text: "Leashes"),
          Tab(text: "Collars"),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
