
// import 'dart:developer';
// import 'package:clique/controller/user_controller.dart';
// import 'package:clique/view/home/video_scroll_screen.dart';
// import 'package:clique/view/splash/loading_placeholder.dart';
// import 'package:clique/view_model/discover_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   late DiscoverViewModel discoverViewModel;

//   @override
//   void initState() {
//     super.initState();
//     Get.put(UserController());
//     discoverViewModel = Get.put(DiscoverViewModel());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Obx(() {
//         // final videoUrls = discoverViewModel.popstreams
//         //     .map((popstream) => popstream.videoUrl)
//         //     .toList();
//         // log('videoUrls: $videoUrls');

//         // Prevent navigation if videoUrls is empty
//         if (discoverViewModel.popstreams.isEmpty) {
//           return LoadingPlaceHolder();
//         }

//         return VideoScrollScreen(popstreams: discoverViewModel.popstreams,);
//       }),
//     );
//   }
// }


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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: Obx(() {
  //       // Only observe the specific reactive variable
  //       if (discoverViewModel.popstreams.isEmpty) {
  //         return LoadingPlaceHolder();
  //       }
  //       log(
  //         "videoUrls: ${discoverViewModel.popstreams.map((popstream) => popstream.videoUrl).toList()}",
  //       );
  //       return 
  //       Obx(() => VideoScrollScreen(
  //         popstreams: discoverViewModel.popstreams,
  //       ));
  //     }),
  //   );
  //        }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Obx(() {
      if (discoverViewModel.popstreams.isEmpty) {
        return LoadingPlaceHolder();
      }
      log("videoUrls: ${discoverViewModel.popstreams.map((p) => p.videoUrl).toList()}");
      return VideoScrollScreen(popstreams: discoverViewModel.popstreams);
    }),
  );
}
}