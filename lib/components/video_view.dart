

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
      return const Center(
          child: CircularProgressIndicator.adaptive(
        backgroundColor: Colors.white,
      ));
    }
  }
}
