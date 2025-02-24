
import 'package:clique/view/home/video_scroll_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  final List<String> _videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    // 'https://www.pexels.com/video/woman-doing-a-jump-rope-exercise-2785536/',
    // 'https://www.pexels.com/video/road-trip-4434242/',
    // // 'https://cdn.pixabay.com/video/2023/03/15/154787-808530571_large.mp4'
    // 'https://pixabay.com/videos/road-sunrise-trees-forest-lights-147898/',
    
    // 'https://pixabay.com/videos/road-sunrise-trees-forest-lights-147898/',
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // body: TabBarView(
      //   controller: _tabController,
      //   children: List.generate(4, (index) => VideoScrollScreen(videoUrls: _videoUrls)),
      // ),
         body:VideoScrollScreen(videoUrls: _videoUrls),
      // body: Container(),
    );
  }
}
