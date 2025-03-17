import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';


// view_models/group_chat_view_model.dart
class GroupChatViewModel extends GetxController {
  final String groupId;
  final String token;
  final String userId;

  GroupChatViewModel({
    required this.groupId,
    required this.token,
    required this.userId,
  });

  final StreamController<List<MessageModel>> _messageController =
      StreamController<List<MessageModel>>.broadcast();
  Stream<List<MessageModel>> get messagesStream => _messageController.stream;

  final ApiClient apiClient = Get.find<ApiClient>();
  Timer? _timer;
  bool _isLoading = false;
  bool hasMoreMessages = true;
  int _currentPage = 1;
  // final int _messagesPerPage = 5; // Number of messages to load per page

  List<MessageModel> _messages = [];

  @override
  void onInit() {
    super.onInit();
    _fetchMessages();
    _timer = Timer.periodic(Duration(milliseconds: 800), (timer) => _fetchMessages());
  }

  @override
  void onClose() {
    _timer?.cancel();
    _messageController.close();
    super.onClose();
  }
Future<void> _fetchMessages({bool loadMore = false}) async {
  if (_isLoading || (loadMore && !hasMoreMessages)) return;

  _isLoading = true;

  try {
    final response = await ApiClient.getMessages(
      url: "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages",
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      log("fetcheddddd");
      log(response.body);
      log(response.statusCode.toString());

      final dynamic responseData = jsonDecode(response.body);

      if (responseData is Map<String, dynamic> && responseData.containsKey("message")) {
        // Handle the case where the response is a JSON object with a "message" key
        if (responseData["message"] == "No messages found") {
          // If no messages are found, send an empty list
          _messages = [];
        }
      } else if (responseData is List<dynamic>) {
        // Handle the case where the response is a JSON array
        final List<MessageModel> newMessages = responseData
            .map((msg) => MessageModel.fromJson({
                  ...msg,
                  'userId': userId, // Pass userId for comparison
                }))
            .toList();

        if (loadMore) {
          // Append older messages to the end of the list
          _messages.addAll(newMessages);
        } else {
          // Replace the list with new messages (latest messages first)
          _messages = newMessages.reversed.toList(); // Reverse to show latest first
        }
      }

      // Add the updated messages to the stream
      _messageController.add(_messages);
    }
  } catch (e) {
    debugPrint("Error fetching messages: $e");
  } finally {
    _isLoading = false;
  }
}
  // Future<void> _fetchMessages({bool loadMore = false}) async {
  //   if (_isLoading || (loadMore && !hasMoreMessages)) return;

  //   _isLoading = true;

  //   try {
  //     final response = await ApiClient.getMessages(
  //       url: "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages",
  //       headers: {"Authorization": "Bearer $token"},
  //     );

  //     if (response.statusCode == 200) {
  //       log("fetcheddddd");
  //       log(response.body);
  //       log(response.statusCode.toString());
  //       final List<dynamic> responseData = jsonDecode(response.body);
        
       
  //       final List<MessageModel> newMessages = responseData
  //           .map((msg) => MessageModel.fromJson({
  //                 ...msg,
  //                 'userId': userId, // Pass userId for comparison
  //               }))
  //           .toList();

  //       if (loadMore) {
  //         // Append older messages to the end of the list
  //         _messages.addAll(newMessages);
  //       } else {
  //         // Replace the list with new messages (latest messages first)
  //         _messages = newMessages.reversed.toList(); // Reverse to show latest first
  //       }

  //       _messageController.add(_messages);

  //       // Check if there are more messages to load
  //       // if (newMessages.length < _messagesPerPage) {
  //       //   hasMoreMessages = false;
  //       // } else {
  //       //   _currentPage++;
  //       // }
  //     }
  //   } catch (e) {
  //     debugPrint("Error fetching messages: $e");
  //   } finally {
  //     _isLoading = false;
  //   }
  // }

  Future<void> loadMoreMessages() async {
    if (!_isLoading && hasMoreMessages) {
      await _fetchMessages(loadMore: true);
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

  DateTime startTime = DateTime.now();
    try {
      final response = await apiClient.post(
        url: ApiEndpoints.sendMessage,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
          "onBehalfOf": userId,
          
          // "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          // "group_id": groupId,
          // "sender_uid": userId,
          // "message": message,
            "category": "message",
            "type": "text",
            "data": {
            "text": message
            },
            "receiver": groupId,
            "receiverType": "group"
        }),
      );
DateTime endTime = DateTime.now();
    Duration apiDuration = endTime.difference(startTime);

    debugPrint("Send Message API Call Duration: ${apiDuration.inMilliseconds} ms");

      if (response.statusCode == 200) {
        // Refresh messages after sending a new one
        _fetchMessages();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:clique/core/api/api_client.dart';
// import 'package:clique/core/api/api_endpoints.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../models/message_model.dart';

// class GroupChatViewModel extends GetxController {
//   final String groupId;
//   final String token;
//   final String userId;

//   GroupChatViewModel({
//     required this.groupId,
//     required this.token,
//     required this.userId,
//   });

//   final StreamController<List<MessageModel>> _messageController =
//       StreamController<List<MessageModel>>.broadcast();
//   Stream<List<MessageModel>> get messagesStream => _messageController.stream;

//   final ApiClient apiClient = Get.find<ApiClient>();
//   Timer? _timer;
//   bool _isLoading = false;

//   List<MessageModel> _messages = [];

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchMessages();
//     _timer = Timer.periodic(Duration(milliseconds: 800), (timer) => _fetchMessages());
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     _messageController.close();
//     super.onClose();
//   }

//   Future<void> _fetchMessages() async {
//     if (_isLoading) return;

//     _isLoading = true;

//     try {
//       final response = await ApiClient.getMessages(
//         url: "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages",
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         log("Fetched messages");
//         log(response.statusCode.toString());

//         final Map<String, dynamic> responseData = jsonDecode(response.body);

//         // Check if the response contains the "message" key
//         if (responseData.containsKey("message") && responseData["message"] == "No messages found") {
//           // If no messages are found, send an empty list
//           _messages = [];
//         } else {
//           // Otherwise, parse the messages
//           final List<dynamic> messagesList = responseData['data']; // Adjust this key if needed
//           _messages = messagesList
//               .map((msg) => MessageModel.fromJson({
//                     ...msg,
//                     'userId': userId, // Pass userId for comparison
//                   }))
//               .toList();
//         }

//         // Add the updated messages to the stream
//         _messageController.add(_messages);
//       }
//     } catch (e) {
//       debugPrint("Error fetching messages: $e");
//     } finally {
//       _isLoading = false;
//     }
//   }

//   Future<void> sendMessage(String message) async {
//     if (message.isEmpty) return;

//     DateTime startTime = DateTime.now();
//     try {
//       final response = await apiClient.post(
//         url: ApiEndpoints.sendMessage,
//         headers: {
//           "Content-Type": "application/json",
//           "accept": "application/json",
//           "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
//           "onBehalfOf": userId,
//         },
//         body: jsonEncode({
//           "category": "message",
//           "type": "text",
//           "data": {
//             "text": message,
//           },
//           "receiver": groupId,
//           "receiverType": "group",
//         }),
//       );

//       DateTime endTime = DateTime.now();
//       Duration apiDuration = endTime.difference(startTime);

//       debugPrint("Send Message API Call Duration: ${apiDuration.inMilliseconds} ms");

//       if (response.statusCode == 200) {
//         // Refresh messages after sending a new one
//         _fetchMessages();
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send message: $e");
//     }
//   }
// }