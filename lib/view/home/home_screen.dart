


// import 'dart:developer';

// import 'package:clique/controller/user_controller.dart';
// import 'package:clique/view/home/video_scroll_screen.dart';
// import 'package:clique/view_model/discover_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
//   // final DiscoverViewModel discoverViewModel = Get.put(DiscoverViewModel());
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
//         // Combine all video URLs from popstreams
//         final videoUrls = discoverViewModel.popstreams
//             .map((popstream) => popstream.videoUrl)
//             .toList();
//       log('videoUrls: $videoUrls');
//         return VideoScrollScreen(videoUrls: 
        
//         ["https://q-revo-uploads.s3-accelerate.amazonaws.com/clique/74831818115917583530061501318/popstreams/17422338943050.mp4", "https://dmx0bt6ajflhp.cloudfront.net/clique/72667878657059/Uploaded%20Files/screen-20250217-233706.mp4"]
//         );
//       }),
//     );
//   }
// }



import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/home/video_scroll_screen.dart';
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
        // final videoUrls = discoverViewModel.popstreams
        //     .map((popstream) => popstream.videoUrl)
        //     .toList();
        final videoUrls=  ["https://videos.pexels.com/video-files/8473407/8473407-hd_1080_1920_25fps.mp4"];
        log('videoUrls: $videoUrls');

        // Prevent navigation if videoUrls is empty
        if (videoUrls.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return VideoScrollScreen(videoUrls: videoUrls);
      }),
    );
  }
}
