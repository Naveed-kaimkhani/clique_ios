
import 'dart:developer';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/home/video_scroll_screen.dart';
import 'package:clique/view/splash/loading_placeholder.dart';
import 'package:clique/view_model/discover_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late DiscoverViewModel discoverViewModel;

  @override
  void initState() {
    super.initState();
    Get.put(UserController());
    discoverViewModel = Get.put(DiscoverViewModel());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final videoUrls = discoverViewModel.popstreams
            .map((popstream) => popstream.videoUrl)
            .toList();
        log('videoUrls: $videoUrls');

        // Prevent navigation if videoUrls is empty
        if (videoUrls.isEmpty) {
          return LoadingPlaceHolder();
        }

        return VideoScrollScreen(videoUrls: videoUrls);
      }),
    );
  }
}
