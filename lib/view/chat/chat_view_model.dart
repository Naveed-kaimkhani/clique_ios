
// import 'dart:convert';
// import 'package:clique/core/api/api_endpoints.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class ChatViewModel extends GetxController {
//   // Controls the visibility of the reaction sheet
//   RxBool isReactionSheetVisible = false.obs;

//   // Method to show the reaction sheet
//   void showReactionSheet() {
//     isReactionSheetVisible.value = true;
//   }

//   // Method to hide the reaction sheet
//   void hideReactionSheet() {
//     isReactionSheetVisible.value = false;
//   }

//   // Toggle reaction sheet (optional convenience method)
//   void toggleReactionSheet() {
//     isReactionSheetVisible.value = !isReactionSheetVisible.value;
//   }

//   // Add reaction to a message
//   Future<void> addReactionToMessage(String messageId, String reaction) async {
//     final url = Uri.parse(ApiEndpoints.addReaction);
//     final body = {
//       'messageId': messageId,
//       'reaction': reaction,
//       'userId': 'your_user_id', // Replace with actual user ID if needed
//     };

//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//           'apikey': 'your_api_key',
//         },
//         body: jsonEncode(body),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Get.snackbar('Success', 'Reaction added');
//         hideReactionSheet(); // Hide sheet after reacting
//       } else {
//         Get.snackbar('Error', 'Failed to add reaction');
//         print(response.body);
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
// }

import 'dart:convert';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatViewModel extends GetxController {
  final RxBool isReactionSheetVisible = false.obs;
  OverlayEntry? _reactionOverlay;

  void showReactionSheet(OverlayEntry entry,context) {
    _reactionOverlay?.remove(); // Remove any existing overlay
    _reactionOverlay = entry;
    isReactionSheetVisible.value = true;
    // Overlay.of(Get.context!)?.insert(entry);
    Overlay.of(context, rootOverlay: true)?.insert(entry);
  }

  void hideReactionSheet() {
    _reactionOverlay?.remove();
    _reactionOverlay = null;
    isReactionSheetVisible.value = false;
  }

  Future<void> addReactionToMessage(String messageId, String reaction) async {
    final url = Uri.parse(ApiEndpoints.addReaction);
    final body = {
      'messageId': messageId,
      'reaction': reaction,
      'userId': 'your_user_id', // Replace with actual user ID
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'apikey': 'your_api_key',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Reaction added');
      } else {
        Get.snackbar('Error', 'Failed to add reaction');
        print(response.body);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}