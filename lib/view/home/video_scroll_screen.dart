import 'package:clique/components/shopping_widget.dart';
import 'package:clique/controller/navigation_controller.dart';
import 'package:clique/view/bottom_navigation_bar.dart';
import 'package:clique/view/discover/discover_screen.dart';
import 'package:clique/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class VideoScrollScreen extends StatefulWidget {
  final List<String> videoUrls;

  const VideoScrollScreen({
    super.key,
    required this.videoUrls,
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
  int _currentIndex = 0; // Track current index

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this);
    _pageController = PageController();
    _loadVideo(_currentIndex); // Load first video initially
  }

  // void _loadVideo(int index) {
  //   if (index < 0 || index >= widget.videoUrls.length) return;

  //   if (!_controllers.containsKey(index)) {
  //     final controller =
  //         VideoPlayerController.networkUrl(Uri.parse(widget.videoUrls[index]));
  //     _controllers[index] = controller;

  //     controller.initialize().then((_) {
  //       if (mounted) {
  //         setState(() {});

  //         if (index == _currentIndex) {
  //           controller.play(); // Play the current video
  //         } else {
  //           controller.setVolume(0); // Prevent audio bleed
  //           controller.pause(); // Ensure it's not playing
  //         }

  //         controller.setLooping(false);
  //       }
  //     });
  //   } else {
  //     // Even if already initialized, ensure only current plays
  //     _controllers.forEach((i, c) {
  //       if (i == _currentIndex) {
  //         c.play();
  //         c.setVolume(1);
  //       } else {
  //         c.pause();
  //         c.setVolume(0);
  //       }
  //     });
  //   }

  //   // Preload next and previous video
  //   if (index + 1 < widget.videoUrls.length)
  //     _loadVideo(index + 1); // Preload next video
  //   if (index - 1 >= 0) _loadVideo(index - 1); // Preload previous video
  // }


  void _loadVideo(int index) {
    if (index < 0 || index >= widget.videoUrls.length) return;

    if (!_controllers.containsKey(index)) {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrls[index]));
      _controllers[index] = controller;

      controller.initialize().then((_) {
        if (mounted) {
          setState(() {});

          if (index == _currentIndex) {
            controller.play(); // Only play the current video
          } else {
            controller.setVolume(0); // Prevent audio bleed
            controller.pause(); // Ensure it's not playing
          }

          controller.setLooping(false);
        }
      });
    } else {
      // Even if already initialized, ensure only current plays
      _controllers.forEach((i, c) {
        if (i == _currentIndex) {
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
    _disposeVideo(_currentIndex - 1); // Dispose previous
    _disposeVideo(_currentIndex + 1); // Dispose next

    _currentIndex = index;
    _loadVideo(_currentIndex); // Load current video
    _loadVideo(_currentIndex + 1); // Preload next video
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
            Obx(() => _buildMainContent(screenSize)),
            Obx(() => _buildShoppingWidget(screenSize)),
            Obx(() => _buildBottomNavBar()),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(Size screenSize) {
    switch (_navigationController.selectedIndex.value) {
      case 0:
        return VideoView(
          tabController: _tabController,
          pageController: _pageController,
          videoUrls: widget.videoUrls,
          controllers: _controllers,
          onPageChanged: _onPageChanged,
          screenHeight: screenSize.height,
          screenWidth: screenSize.width,
        );
      case 1:
        return const DiscoverScreen();
      case 3:
        return ProfileScreen();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  Widget _buildShoppingWidget(Size screenSize) {
    return _navigationController.selectedIndex.value == 0
        ? ShoppingWidget(
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
          )
        : const SizedBox.shrink();
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

class VideoView extends StatelessWidget {
  final TabController _tabController;
  final PageController _pageController;
  final List<String> videoUrls;
  final Map<int, VideoPlayerController> controllers;
  final void Function(int) onPageChanged;
  final double screenHeight;
  final double screenWidth;

  const VideoView({
    super.key,
    required TabController tabController,
    required PageController pageController,
    required this.videoUrls,
    required this.controllers,
    required this.onPageChanged,
    required this.screenHeight,
    required this.screenWidth,
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
            _buildTabBar(),
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
                      fontWeight: FontWeight.bold))),
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

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Center(
            child: Icon(Icons.video_library, color: Colors.white, size: 100),
          ),
        ),
      ),
    );
  }
}
