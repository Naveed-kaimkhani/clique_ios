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
   final List<PopstreamModel> popstreams; // Changed from List<String> videoUrls


  const VideoScrollScreen({
    super.key,
    required this.popstreams,
  });

  @override
  State<VideoScrollScreen> createState() => _VideoScrollScreenState();
}

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
    final videoUrl = widget.popstreams[index].videoUrl; // Get URL from PopstreamModel
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

  /// Dispose of videos that are off-screen
  void _disposeVideo(int index) {
    if (_controllers.containsKey(index)) {
      _controllers[index]!.dispose();
      _controllers.remove(index);
    }
  }

  /// Handles page changes for lazy loading
 
  void _onPageChanged(int index) {
    _disposeVideo(_currentIndex.value - 1);
    _disposeVideo(_currentIndex.value + 1);

    _currentIndex.value = index;
    currentPopstream.value = widget.popstreams[index];
    _loadVideo(_currentIndex.value);
    _loadVideo(_currentIndex.value + 1);
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

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Obx(() => _buildMainContent(screenSize)),
            
           _buildMainContent(screenSize),
            // Obx(() => _buildShoppingWidget(screenSize)),
            
            _buildShoppingWidget(screenSize),
            Obx(() => _buildBottomNavBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Size screenSize) {
    return Obx(() {
      switch (_navigationController.selectedIndex.value) {
        case 0:
          return VideoView(
            tabController: _tabController,
            pageController: _pageController,
            videoUrls: widget.popstreams.map((p) => p.videoUrl).toList(),
            controllers: _controllers,
            onPageChanged: _onPageChanged,
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
            currentIndex: _currentIndex.value, // Pass current index
          );
        case 1:
          return const DiscoverScreen();
        case 3:
          return ProfileScreen();
        default:
          return const Center(child: Text('Page not found'));
      }
    });
  }


 Widget _buildShoppingWidget(Size screenSize) {
  return Obx(() => _navigationController.selectedIndex.value == 0 &&
          currentPopstream.value != null
      ? ShoppingWidget(
          screenHeight: screenSize.height,
          screenWidth: screenSize.width,
          popstream: currentPopstream.value!,
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
    _navigationController.changeIndex(index, 0);
  }
}
