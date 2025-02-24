// import 'package:flutter/material.dart';

// class TikTokAppBar extends StatefulWidget {
//   @override
//   _TikTokAppBarState createState() => _TikTokAppBarState();
// }

// class _TikTokAppBarState extends State<TikTokAppBar> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   PreferredSizeWidget _buildTabBar() {
//     return PreferredSize(
//       preferredSize: const Size.fromHeight(50),
//       child: TabBar(
//         controller: _tabController,
//         isScrollable: false,
//         indicator: const UnderlineTabIndicator(
//           borderSide: BorderSide(width: 3.0, color: Colors.white), // Small white underline
//           insets: EdgeInsets.symmetric(horizontal: 20.0),
//         ),
//         labelColor: Colors.white,
//         unselectedLabelColor: Colors.white.withOpacity(0.5),
//         labelStyle: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//         indicatorSize: TabBarIndicatorSize.label,
//         tabs: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Following"),
//               const SizedBox(width: 5),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: const Text(
//                   "LIVE",
//                   style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//           const Text("For you"),
//         ].map((tab) => Tab(child: tab)).toList(),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, // Fully transparent
//         elevation: 0,
//         title: _buildTabBar(),
//         centerTitle: true,
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 15),
//             child: Icon(Icons.search, color: Colors.white, size: 28),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.black, // TikTok has a dark background
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           Center(child: Text("Following Page", style: TextStyle(color: Colors.white))),
//           Center(child: Text("For You Page", style: TextStyle(color: Colors.white))),
//         ],
//       ),
//     );
//   }
// }
