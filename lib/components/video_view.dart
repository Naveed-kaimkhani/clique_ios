// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoView extends StatelessWidget {
//   final PageController _pageController;
//   final List<String> videoUrls;
//   final Map<int, VideoPlayerController> controllers;
//   final void Function(int) onPageChanged;
//   final double screenHeight;
//   final double screenWidth;
//   final int currentIndex;
//   final Future<void> Function()? onRefresh; // ✅ Add this line

//   const VideoView({
//     super.key,
//     required PageController pageController,
//     required this.videoUrls,
//     required this.controllers,
//     required this.onPageChanged,
//     required this.screenHeight,
//     this.onRefresh, // ✅ Initialize here

//     required this.screenWidth,
//     required this.currentIndex,
//   }) : _pageController = pageController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       body: RefreshIndicator(
//         onRefresh: onRefresh ?? () async {},
//         child: PageView.builder(
//           controller: _pageController,
//           scrollDirection: Axis.vertical,
//           itemCount: videoUrls.length,
//           onPageChanged: onPageChanged,
//           itemBuilder: (context, index) => _buildVideoItem(index),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoItem(int index) {
//     final controller = controllers[index];

//     if (controller == null || !controller.value.isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final chewieController = ChewieController(
//       videoPlayerController: controller,
//       autoPlay: true,
//       looping: true,
//       showControls: true, // Set to true if you want default Chewie UI
//       allowMuting: false,
//     );

//     return Stack(
//       children: [
//         SizedBox.expand(
//           child: GestureDetector(
//             onTap: () {
//               if (controller.value.isPlaying) {
//                 controller.pause();
//               } else {
//                 controller.play();
//               }
//             },
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: controller.value.aspectRatio,
//                 child: Chewie(controller: chewieController),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   } //
// }

// class VideoView extends StatefulWidget {
//   final PageController _pageController;
//   final List<String> videoUrls;
//   final Map<int, VideoPlayerController> controllers;
//   final void Function(int) onPageChanged;
//   final double screenHeight;
//   final double screenWidth;
//   final int currentIndex;
//   final Future<void> Function()? onRefresh;

//   const VideoView({
//     super.key,
//     required PageController pageController,
//     required this.videoUrls,
//     required this.controllers,
//     required this.onPageChanged,
//     required this.screenHeight,
//     this.onRefresh,
//     required this.screenWidth,
//     required this.currentIndex,
//   }) : _pageController = pageController;

//   @override
//   State<VideoView> createState() => _VideoViewState();
// }

// class _VideoViewState extends State<VideoView> {
//   final Map<int, ChewieController> _chewieControllers = {};
//   final Map<int, bool> _showControlsMap = {};

//   void _toggleControls(int index) {
//     setState(() {
//       _showControlsMap[index] = !(_showControlsMap[index] ?? false);
//     });
//   }

//   @override
//   void dispose() {
//     for (var controller in _chewieControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       body: RefreshIndicator(
//         onRefresh: widget.onRefresh ?? () async {},
//         child: PageView.builder(
//           controller: widget._pageController,
//           scrollDirection: Axis.vertical,
//           itemCount: widget.videoUrls.length,
//           onPageChanged: widget.onPageChanged,
//           itemBuilder: (context, index) => _buildVideoItem(index),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoItem(int index) {
//     final controller = widget.controllers[index];

//     if (controller == null || !controller.value.isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     // Create ChewieController if not already created
//     _chewieControllers.putIfAbsent(index, () {
//       return ChewieController(
//         videoPlayerController: controller,
//         autoPlay: true,
//         looping: true,
//         showControls: false, // start hidden
//         allowMuting: true,
//         allowFullScreen: true,
//       );
//     });

//     final chewieController = _chewieControllers[index]!;

//     return GestureDetector(
//       onTap: () => _toggleControls(index),
//       child: Stack(
//         children: [
//           SizedBox.expand(
//             child: Center(
//               child: AspectRatio(
//                 aspectRatio: controller.value.aspectRatio,
//                 child: Chewie(controller: chewieController),
//               ),
//             ),
//           ),
//           if (_showControlsMap[index] == true)
//             Positioned.fill(
//               child: Container(
//                 color: Colors.black26,
//                 child: Chewie(
//                   controller: ChewieController(
//                     videoPlayerController: controller,
//                     autoPlay: false,
//                     looping: true,
//                     showControls: true,
//                     allowMuting: true,
//                     allowFullScreen: true,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:chewie/chewie.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:video_player/video_player.dart';

// // class VideoView extends StatefulWidget {
// //   final PageController _pageController;
// //   final List<String> videoUrls;
// //   final Map<int, VideoPlayerController> controllers;
// //   final void Function(int) onPageChanged;
// //   final double screenHeight;
// //   final double screenWidth;
// //   final int currentIndex;
// //   final Future<void> Function()? onRefresh;

// //   const VideoView({
// //     super.key,
// //     required PageController pageController,
// //     required this.videoUrls,
// //     required this.controllers,
// //     required this.onPageChanged,
// //     required this.screenHeight,
// //     this.onRefresh,
// //     required this.screenWidth,
// //     required this.currentIndex,
// //   }) : _pageController = pageController;

// //   @override
// //   State<VideoView> createState() => _VideoViewState();
// // }

// // class _VideoViewState extends State<VideoView> {
// //   final Map<int, ChewieController> _chewieControllers = {};
// //   final RxMap<int, bool> _showControlsMap = RxMap<int, bool>();

// //   void _toggleControls(int index) {
// //     _showControlsMap[index] = !(_showControlsMap[index] ?? false);
// //   }

// //   @override
// //   void dispose() {
// //     for (var controller in _chewieControllers.values) {
// //       controller.dispose();
// //     }
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       extendBodyBehindAppBar: true,
// //       body: RefreshIndicator(
// //         onRefresh: widget.onRefresh ?? () async {},
// //         child: Padding(
// //           padding: const EdgeInsets.only(top: 20.0),
// //           child: PageView.builder(
// //             controller: widget._pageController,
// //             scrollDirection: Axis.vertical,
// //             itemCount: widget.videoUrls.length,
// //             onPageChanged: widget.onPageChanged,
// //             itemBuilder: (context, index) => _buildVideoItem(index),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildVideoItem(int index) {
// //     final controller = widget.controllers[index];

// //     if (controller == null || !controller.value.isInitialized) {
// //       return const Center(child: CircularProgressIndicator());
// //     }

// //     _chewieControllers.putIfAbsent(index, () {
// //       return ChewieController(
// //         videoPlayerController: controller,
// //         autoPlay: true,
// //         looping: true,
// //         showControls: false,
// //         allowMuting: true,
// //         allowFullScreen: true,
// //       );
// //     });

// //     final chewieController = _chewieControllers[index]!;

// //     return GestureDetector(
// //       onTap: () => _toggleControls(index),
// //       child: Obx(() => Stack(
// //             children: [
// //               SizedBox.expand(
// //                 child: Center(
// //                   child: AspectRatio(
// //                     aspectRatio: controller.value.aspectRatio,
// //                     child: Chewie(controller: chewieController),
// //                   ),
// //                 ),
// //               ),
// //               if (_showControlsMap[index] == true)
// //                 Positioned.fill(
// //                   child: Container(
// //                     color: Colors.black26,
// //                     child: Chewie(
// //                       controller: ChewieController(
// //                         videoPlayerController: controller,
// //                         autoPlay: false,
// //                         looping: true,
// //                         showControls: true,
// //                         allowMuting: true,
// //                         allowFullScreen: true,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //             ],
// //           )),
// //     );
// //   }
// // }

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
  final Future<void> Function()? onRefresh;
  const VideoView({
    super.key,
    required PageController pageController,
    required this.videoUrls,
    required this.onRefresh,
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

  // Widget _buildVideoItem(int index) {
  //   return Stack(
  //     children: [
  //       SizedBox.expand(
  //         child: controllers.containsKey(index) &&
  //                 controllers[index]!.value.isInitialized
  //             ? FittedBox(
  //                 fit: BoxFit.cover,
  //                 child: SizedBox(
  //                   width: controllers[index]!.value.size.width * 1.5,
  //                   height: controllers[index]!.value.size.height * 1.5,
  //                   child: VideoPlayer(controllers[index]!),
  //                 ),
  //               )
  //             : const Center(child: CircularProgressIndicator()),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildVideoItem(int index) {
    if (controllers.containsKey(index) &&
        controllers[index]!.value.isInitialized) {
      final controller = controllers[index]!;
      final aspectRatio = controller.value.aspectRatio;

      return Stack(
        children: [
          SizedBox.expand(
            child: Center(
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
