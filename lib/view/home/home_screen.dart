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
  final UserController userController = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    discoverViewModel = Get.put(DiscoverViewModel());
    discoverViewModel.fetchPopstreams(); // Make sure this updates popstreams observable
  }

 

  @override
Widget build(BuildContext context) {
  log(userController.token.value);
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Obx(() {
      if (discoverViewModel.popstreams.isEmpty) {
        return LoadingPlaceHolder();
      }
      return VideoScrollScreen(popstreams: discoverViewModel.popstreams);
    }),
  );
}
}