
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatelessWidget {
   final TabController _tabController;
  final PageController _pageController;
  final List<String> videoUrls;
  final Map<int, VideoPlayerController> controllers;
  final void Function(int) onPageChanged;
  final double screenHeight;
  final double screenWidth;
  final int currentIndex; // Add this parameter

  const VideoView({
   super.key,
    required TabController tabController,
    required PageController pageController,
    required this.videoUrls,
    required this.controllers,
    required this.onPageChanged,
    required this.screenHeight,
    required this.screenWidth,
    required this.currentIndex, // Add to constructor
  })  : _tabController = tabController,
        _pageController = pageController;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        // appBar: _buildAppBar(context),
        body: Stack(
          children: [
            _buildTabBarView(),
            // Padding(
            //   padding: const EdgeInsets.only(left:208.0),
            //   child: 
            // )
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text.rich(
//   TextSpan(
//     text: 'My Feed\n ',
//     style: TextStyle(
//       color: Colors.white,
//       fontSize: screenWidth * 0.037,
//       fontWeight: FontWeight.bold,
//       decoration: TextDecoration.underline,
//       decorationColor: Colors.white, // 👈 Explicitly set underline color
//         decorationThickness: 2.5, // 👈 Increase thickness here

//     ),
//   ),
// )


//                 ],
//               ),
//             ),
            // _buildTabBar(),
            // _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(screenHeight * 0.08),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(fontSize: screenWidth * 0.038),
        tabs: [
          Tab(
              child: Text("Pet Food",
                  style: TextStyle(
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.bold))
                      ),
          Tab(
              child: Text("Pull Toys",
                  style: TextStyle(
                      fontSize: screenWidth * 0.036,
                      fontWeight: FontWeight.bold))),
          Tab(
              child: Text("Leashes",
                  style: TextStyle(
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.bold))),
          Tab(
              child: Text("Collars",
                  style: TextStyle(
                      fontSize: screenWidth * 0.037,
                      fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: List.generate(4, (index) => _buildVideoPageView()),
    );
  }

  Widget _buildVideoPageView() {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) => _buildVideoItem(index),
    );
  }

  Widget _buildVideoItem(int index) {
    return Stack(
      children: [
        SizedBox.expand(
          child: controllers.containsKey(index) &&
                  controllers[index]!.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controllers[index]!.value.size.width * 1.5,
                    height: controllers[index]!.value.size.height * 1.5,
                    child: VideoPlayer(controllers[index]!),
                  ),
                )
              : 
          const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }


}
