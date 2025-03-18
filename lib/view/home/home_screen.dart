
import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/home/video_scroll_screen.dart';
import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    
     Get.put(UserController());
 Get.put(DiscoverViewModel());
  }


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
