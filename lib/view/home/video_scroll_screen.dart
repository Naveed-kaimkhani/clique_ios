import 'package:clique/components/shopping_widget.dart';
import 'package:clique/components/video_view.dart';
import 'package:clique/controller/navigation_controller.dart';
import 'package:clique/data/models/pop_stream_model.dart';
import 'package:clique/view/bottom_navigation_bar.dart';
import 'package:clique/view/discover/discover_screen.dart';
import 'package:clique/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoScrollScreen extends StatefulWidget {
  final RxList<PopstreamModel> popstreams;
  final Future<void> Function()? onRefresh;

  const VideoScrollScreen({
    super.key,
    this.onRefresh,
    required this.popstreams,
  });

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

// i am facing an issue that its a instagram app that shows reels. issue is when i scroll to next video the sound of previous video keep plays. i want to stop the sound and pause the previous video
class _VideoScrollScreenState extends State<VideoScrollScreen>
    with SingleTickerProviderStateMixin {
  static const int _tabCount = 4;

  late final PageController _pageController;
  late final TabController _tabController;
  final NavigationController _navigationController =
      Get.put(NavigationController());

  final Map<int, VideoPlayerController> _controllers =
      {}; // Lazy-loaded controllers
  final RxInt _currentIndex = 0.obs; // Make currentIndex reactive
  final Rx<PopstreamModel?> currentPopstream = Rx<PopstreamModel?>(null);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _pageController = PageController();
    if (widget.popstreams.isNotEmpty) {
      currentPopstream.value = widget.popstreams.first;
    }
    _loadVideo(_currentIndex.value);
  }

  void _loadVideo(int index) {
    if (index < 0 || index >= widget.popstreams.length) return;

    if (!_controllers.containsKey(index)) {
      final videoUrl =
          widget.popstreams[index].videoUrl; // Get URL from PopstreamModel
      final controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      _controllers[index] = controller;

      controller.initialize().then((_) {
        if (mounted) {
          setState(() {});

          if (index == _currentIndex.value) {
            controller.play(); // Only play the current video
          } else {
            controller.setVolume(0); // Prevent audio bleed
            controller.pause(); // Ensure it's not playing
          }

          controller.setLooping(true);
        }
      });
    } else {
      // Even if already initialized, ensure only current plays
      _controllers.forEach((i, c) {
        if (i == _currentIndex.value) {
          c.play();
          c.setVolume(1);
        } else {
          c.pause();
          c.setVolume(0);
        }
      });
    }
  }

  void _onPageChanged(int index) {
    // Pause and mute the previous video
    if (_controllers.containsKey(_currentIndex.value)) {
      final prevController = _controllers[_currentIndex.value]!;
      prevController.pause();
      prevController.setVolume(0);
    }

    _currentIndex.value = index;
    currentPopstream.value = widget.popstreams[index];

    // Load and play the current video
    _loadVideo(index);

    // Optionally preload next (for smooth UX)
    _loadVideo(index + 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildMainContent(screenSize),
          _buildShoppingWidget(screenSize),
          Obx(() => _buildBottomNavBar()),
        ],
      ),
    );
  }

  Widget _buildMainContent(Size screenSize) {
    return Obx(() {
      switch (_navigationController.selectedIndex.value) {
        case 0:
          return Obx(() {
            return VideoView(
              pageController: _pageController,
              videoUrls: widget.popstreams.map((p) => p.videoUrl).toList(),
              controllers: _controllers,
              onPageChanged: _onPageChanged,
              screenHeight: screenSize.height,
              screenWidth: screenSize.width,
              onRefresh: widget.onRefresh,
              currentIndex: _currentIndex.value,
            );
          });
        case 1:
          return const DiscoverScreen();
        case 3:
          return ProfileScreen();
        default:
          return const Center(child: Text('Page not found'));
      }
    });
  }

  void _pauseCurrentVideo() {
    if (_controllers.containsKey(_currentIndex.value)) {
      final controller = _controllers[_currentIndex.value]!;
      controller.pause();
      controller.setVolume(0);
    }
  }

  void _resumeCurrentVideo() {
    if (_controllers.containsKey(_currentIndex.value)) {
      final controller = _controllers[_currentIndex.value]!;
      controller.setVolume(1); // Unmute
      controller.play(); // Resume playback
    }
  }

  Widget _buildShoppingWidget(Size screenSize) {
    return Obx(() => _navigationController.selectedIndex.value == 0 &&
            currentPopstream.value != null
        ? ShoppingWidget(
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
            popstream: currentPopstream.value!,
            resumeVideo: _resumeCurrentVideo, // 👈 Add this

            onTap: _pauseCurrentVideo,
          )
        : const SizedBox.shrink());
  }

  Widget _buildBottomNavBar() {
    return CustomBottomNavBar(
      onTap: _onNavItemTapped,
      selectedIndex: _navigationController.selectedIndex.value,
    );
  }

  void _onNavItemTapped(int index) {
    if (index != 0) {
      // We're leaving the video screen, pause all videos
      _controllers.forEach((_, controller) {
        controller.pause();
        controller.setVolume(0);
      });
    } else {
      // Coming back to video screen, play the current one
      if (_controllers.containsKey(_currentIndex.value)) {
        _controllers[_currentIndex.value]!
          ..play()
          ..setVolume(1);
      }
    }

    _navigationController.changeIndex(index, 0);
  }
}
