
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:video_player/video_player.dart';

// class VideoView extends StatelessWidget {
//    final TabController _tabController;
//   final PageController _pageController;
//   final List<String> videoUrls;
//   final Map<int, VideoPlayerController> controllers;
//   final void Function(int) onPageChanged;
//   final double screenHeight;
//   final double screenWidth;
//   final int currentIndex; // Add this parameter

//   const VideoView({
//    super.key,
//     required TabController tabController,
//     required PageController pageController,
//     required this.videoUrls,
//     required this.controllers,
//     required this.onPageChanged,
//     required this.screenHeight,
//     required this.screenWidth,
//     required this.currentIndex, // Add to constructor
//   })  : _tabController = tabController,
//         _pageController = pageController;


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         extendBodyBehindAppBar: true,
//         // appBar: _buildAppBar(context),
//         body: Stack(
//           children: [
//             _buildTabBarView(),
//           ],
//         ),
//       ),
//     );
//   }


//   Widget _buildTabBarView() {
//     return TabBarView(
//       controller: _tabController,
//       children: List.generate(4, (index) => _buildVideoPageView()),
//     );
//   }

//   Widget _buildVideoPageView() {
//     return PageView.builder(
//       controller: _pageController,
//       scrollDirection: Axis.vertical,
//       itemCount: videoUrls.length,
//       onPageChanged: onPageChanged,
//       itemBuilder: (context, index) => _buildVideoItem(index),
//     );
//   }

//   Widget _buildVideoItem(int index) {
//     return Stack(
//       children: [
//         SizedBox.expand(
//           child: controllers.containsKey(index) &&
//                   controllers[index]!.value.isInitialized
//               ? FittedBox(
//                   fit: BoxFit.cover,
//                   child: SizedBox(
//                     width: controllers[index]!.value.size.width * 1.5,
//                     height: controllers[index]!.value.size.height * 1.5,
//                     child: VideoPlayer(controllers[index]!),
//                   ),
//                 )
//               : 
//           const Center(child: CircularProgressIndicator()),
//         ),
//       ],
//     );
//   }


// }


import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatelessWidget {
  final PageController _pageController;
  final List<String> videoUrls;
  final Map<int, VideoPlayerController> controllers;
  final void Function(int) onPageChanged;
  final double screenHeight;
  final double screenWidth;
  final int currentIndex;

  const VideoView({
    super.key,
    required PageController pageController,
    required this.videoUrls,
    required this.controllers,
    required this.onPageChanged,
    required this.screenHeight,
    required this.screenWidth,
    required this.currentIndex,
  }) : _pageController = pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        onPageChanged: onPageChanged,
        itemBuilder: (context, index) => _buildVideoItem(index),
      ),
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
              : const Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}
