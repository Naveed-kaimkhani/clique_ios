// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class SearchController extends GetxController {
//   var searchQuery = ''.obs;
// }

// class SearchScreen extends StatelessWidget {
//   final SearchController controller = Get.put(SearchController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // White background
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200], // Light background for TextField
//             borderRadius: BorderRadius.circular(12), // Rounded corners
//           ),
//           child: TextField(
//             onChanged: (value) => controller.searchQuery.value = value,
//             decoration: InputDecoration(
//               hintText: "Search...",
//               prefixIcon: Icon(Icons.search, color: Colors.grey),
//               border: InputBorder.none,
//               contentPadding: EdgeInsets.symmetric(vertical: 14),
//             ),
//           ),
//         ),
//       ),
//       body: Obx(() {
//         if (controller.searchQuery.value.isNotEmpty) {
//           return ListView.builder(
//             padding: EdgeInsets.all(16),
//             itemCount: 10, // Mock data count
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text("Result ${index + 1}"),
//                 subtitle: Text("Matching: ${controller.searchQuery.value}"),
//               );
//             },
//           );
//         }
//         return SizedBox.shrink(); // Hides everything when no search input
//       }),
//     );
//   }
// }
