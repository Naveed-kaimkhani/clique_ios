import 'package:clique/components/shopping_widget.dart';
import 'package:clique/controller/navigation_controller.dart';
import 'package:clique/view/bottom_navigation_bar.dart';
import 'package:clique/view/discover/discover_screen.dart';
import 'package:clique/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
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

class _VideoScrollScreenState extends State<VideoScrollScreen> with SingleTickerProviderStateMixin {
  static const int _tabCount = 4;
  
  late final PageController _pageController;
  late final List<VideoPlayerController> _controllers;
  late final TabController _tabController;
  final NavigationController _navigationController = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _tabController = TabController(length: _tabCount, vsync: this);
    _pageController = PageController();
    _controllers = _initializeVideoControllers();
  }

  List<VideoPlayerController> _initializeVideoControllers() {
    final controllers = <VideoPlayerController>[];
    
    for (final url in widget.videoUrls) {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      controllers.add(controller);
      
      controller.initialize().then((_) {
        if (mounted) {
          setState(() {});
          controller.play();
          controller.setLooping(false);
        }
      });
    }
    
    return controllers;
  }

  void _onNavItemTapped(int index) {
    _navigationController.changeIndex(index, 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    _tabController.dispose();
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildMainContent(Size screenSize) {
    return Obx(() {
      return switch (_navigationController.selectedIndex.value) {
        0 => VideoView(
          tabController: _tabController,
          pageController: _pageController,
          widget: widget,
          controllers: _controllers,
          screenHeight: screenSize.height,
          screenWidth: screenSize.width,
        ),
        1 => const DiscoverScreen(),
        3 => ProfileScreen(),
        _ => const Center(child: Text('Page not found')),
      };
    });
  }

  Widget _buildShoppingWidget(Size screenSize) {
    return Obx(() => _navigationController.selectedIndex.value == 0
      ? ShoppingWidget(
          screenHeight: screenSize.height,
          screenWidth: screenSize.width,
        )
      : const SizedBox.shrink());
  }

  Widget _buildBottomNavBar() {
    return Obx(() => CustomBottomNavBar(
      onTap: _onNavItemTapped,
      selectedIndex: _navigationController.selectedIndex.value,
    ));
  }
}

class VideoView extends StatelessWidget {
  final TabController _tabController;
  final PageController _pageController;
  final VideoScrollScreen widget;
  final List<VideoPlayerController> _controllers;
  final double screenHeight;
  final double screenWidth;

  const VideoView({
    super.key,
    required TabController tabController,
    required PageController pageController,
    required this.widget,
    required List<VideoPlayerController> controllers,
    required this.screenHeight,
    required this.screenWidth,
  }) : _tabController = tabController,
       _pageController = pageController,
       _controllers = controllers;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: _buildTabBarView(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: _buildTabBar(),
    );
  }

  PreferredSize _buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(screenHeight * 0.06),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: TextStyle(fontSize: screenWidth * 0.038),
        tabs: [
          Tab(child: Text("Pet Food", style: TextStyle(fontSize: screenWidth * 0.037, fontWeight: FontWeight.bold))),
          
          Tab(child: Text("Pull Toys", style: TextStyle(fontSize: screenWidth * 0.036, fontWeight: FontWeight.bold))),
          
          Tab(child: Text("Leashes", style: TextStyle(fontSize: screenWidth * 0.037, fontWeight: FontWeight.bold))),
          
          Tab(child: Text("Collars", style: TextStyle(fontSize: screenWidth * 0.037, fontWeight: FontWeight.bold))),
          
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
      itemCount: widget.videoUrls.length,
      itemBuilder: (context, index) => _buildVideoItem(index),
    );
  }

Widget _buildVideoItem(int index) {
  return Stack(
    children: [
      SizedBox.expand(
        child: _controllers[index].value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controllers[index].value.size.width * 1.5,
                  height: _controllers[index].value.size.height * 1.5,
                  child: VideoPlayer(_controllers[index]),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    ],
  );
}

}
