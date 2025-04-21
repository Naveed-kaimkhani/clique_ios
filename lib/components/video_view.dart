


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
  final Future<void> Function()? onRefresh; // ✅ Add this line

  const VideoView({
    super.key,
    required PageController pageController,
    required this.videoUrls,
    required this.controllers,
    required this.onPageChanged,
    required this.screenHeight,
        this.onRefresh, // ✅ Initialize here

    required this.screenWidth,
    required this.currentIndex,
  }) : _pageController = pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
         onRefresh: onRefresh ?? () async {}, 
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videoUrls.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) => _buildVideoItem(index),
        ),
      ),
    );
  }



//   Widget _buildVideoItem(int index) {
//   final controller = controllers[index];

//   return Stack(
//     children: [
//       SizedBox.expand(
//         child: controller != null && controller.value.isInitialized
//             ? Center(
//                 child: AspectRatio(
//                   aspectRatio: controller.value.aspectRatio,
//                   child: VideoPlayer(controller),
//                 ),
//               )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     ],
//   );
// }

Widget _buildVideoItem(int index) {
  final controller = controllers[index];

  return Stack(
    children: [
      SizedBox.expand(
        child: controller != null && controller.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                },
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    ],
  );
}


}
