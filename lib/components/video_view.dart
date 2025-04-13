


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
