
import 'package:clique/view/home/video_scroll_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  final List<String> _videoUrls = [
    // 
    'https://assets.mixkit.co/active_storage/video_items/100627/1730161415/100627-video-720.mp4',
    'https://assets.mixkit.co/active_storage/video_items/100608/1730160112/100608-video-720.mp4',

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
