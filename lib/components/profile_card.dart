// import 'package:clique/constants/app_svg_icons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class ProfileCard extends StatelessWidget {
//   final bool isInfluencer;
//   const ProfileCard({super.key, required this.isInfluencer});

//   @override
//   Widget build(BuildContext context) {
    
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Container(
//       width: 396,
//       height: 262,
//       margin: EdgeInsets.symmetric(horizontal: 16),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 5,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: Row(
//         // mainAxisAlignment: MainAxisAlignment.center,
//         // crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//                Column(
//         crossAxisAlignment:isInfluencer? CrossAxisAlignment.center: CrossAxisAlignment.start,
//         mainAxisAlignment:isInfluencer?MainAxisAlignment.center: MainAxisAlignment.start,
//         children: [
//             Image.asset(
//             AppSvgIcons.profile,
//             height: screenWidth * 0.35, // 45% of screen width
//             width: screenWidth * 0.35,
//               fit: BoxFit.cover, // Ensures it fills the given size

//           ),
//           Text(
//             'Brian Brunner',
//             style: TextStyle(
//                 fontSize: 26, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             '@brianbrunner',
//             style: TextStyle(
//                 fontSize: 16, color: Colors.grey),
//           ),
//         ],
//       ),
//           SizedBox(width: 60),
//      isInfluencer?    Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//                   _buildStatColumn("120", "Posts"),
//           _buildStatColumn("1200", "Followers"),
//           _buildStatColumn("120", "Following"),
//             ],
//           ):SizedBox()
          
//         ],
//       ),
//     );
//   }

//   Widget _buildStatColumn(String value, String label) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           value,
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           label,
//           style: TextStyle(fontSize: 15, color: Colors.grey),
//         ),
//         SizedBox(height: 8,),
        
//       ],
//     );
//   }
// }

import 'package:clique/constants/app_svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileCard extends StatelessWidget {
  final bool isInfluencer;
  const ProfileCard({super.key, required this.isInfluencer});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9, // 90% of screen width
      height: screenHeight * 0.3, // 30% of screen height
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05), // 5% margin
      padding: EdgeInsets.all(screenWidth * 0.04), // 4% padding
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: isInfluencer ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              mainAxisAlignment: isInfluencer ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Image.asset(
                  AppSvgIcons.profile,
                  height: screenWidth * 0.35, // 25% of screen width
                  width: screenWidth * 0.35,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: screenHeight * 0.01), // 2% of screen height
                Text(
                  'Brian Brunner',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06, // 6% of screen width
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@brianbrunner',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04, // 4% of screen width
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: screenWidth * 0.05), // 5% of screen width
          if (isInfluencer)
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStatColumn("120", "Posts", screenWidth),
                  _buildStatColumn("1200", "Followers", screenWidth),
                  _buildStatColumn("120", "Following", screenWidth),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, double screenWidth) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.05, // 5% of screen width
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.035, // 3.5% of screen width
            color: Colors.grey,
          ),
        ),
        SizedBox(height: screenWidth * 0.02), // 2% of screen width
      ],
    );
  }
}