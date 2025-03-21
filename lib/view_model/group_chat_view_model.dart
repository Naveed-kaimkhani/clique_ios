import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';


// // view_models/group_chat_view_model.dart
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
//   bool hasMoreMessages = true;
//   int _currentPage = 1;
//   // final int _messagesPerPage = 5; // Number of messages to load per page

//   List<MessageModel> _messages = [];

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchMessages(false);
//     _timer = Timer.periodic(Duration(milliseconds: 800), (timer) => _fetchMessages(false));
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     _messageController.close();
//     super.onClose();
//   }
// Future<void> _fetchMessages(bool loadMore) async {
//   if (_isLoading || (loadMore && !hasMoreMessages)) return;
//   _isLoading = true;

//   try {
//     log("hitting api to load more");
//     // Determine API URL based on pagination state
//     String apiUrl = "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages?limit=${loadMore ? 1000 : 10}";
//     log(loadMore.toString());
//     log(_messages.isNotEmpty.toString());
//     if (loadMore && _messages.isNotEmpty) {
//       // Fetch older messages with timestamp parameter
//       int lastMessageTimestamp = _messages.first.time; // Get timestamp of oldest message
//       int oneDayBack = lastMessageTimestamp - (8000); // Subtract 1 day in seconds
//       apiUrl += "&timeStamp=$oneDayBack";
//       log("url added");
//     }
//     log(apiUrl);
//     final response = await ApiClient.getMessages(
//       url: apiUrl,
//       headers: {"Authorization": "Bearer $token"},
//     );

//     log(response.statusCode.toString());
//     // log(response.body);

//     if (response.statusCode == 200) {
//       final dynamic responseData = jsonDecode(response.body);

//       if (responseData is Map<String, dynamic> && responseData.containsKey("messages")) {
//         final messagesData = responseData["messages"];

//         if (messagesData is List && messagesData.isNotEmpty) {
//           final List<MessageModel> newMessages = messagesData
//               .map((msg) => MessageModel.fromJson({...msg, 'userId': userId}))
//               .toList();

//           if (loadMore) {
//             _messages.insertAll(0, newMessages); // Add older messages at the start
//           } else {
//             _messages = newMessages.reversed.toList(); // Show latest messages first
//           }

//           _messageController.add(_messages);
//         } else {
//           hasMoreMessages = false; // No more messages to load
//         }
//       }
//     }
//   } catch (e) {
//     debugPrint("Error fetching messages: $e");
//   } finally {
//     _isLoading = false;
//   }
// }


//   Future<void> loadMoreMessages() async {
   
//     if (!_isLoading && hasMoreMessages) {
//  log(
//       "load more called"
//     );
//       await _fetchMessages( true);
//     }
//   }

//   Future<void> sendMessage(String message) async {
//     if (message.isEmpty) return;

//   DateTime startTime = DateTime.now();
//     try {
//       final response = await apiClient.post(
//         url: ApiEndpoints.sendMessage,
//         headers: {
//           "Content-Type": "application/json",
//           "accept": "application/json",
//           "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
//           "onBehalfOf": userId,
          
//           // "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           // "group_id": groupId,
//           // "sender_uid": userId,
//           // "message": message,
//             "category": "message",
//             "type": "text",
//             "data": {
//             "text": message
//             },
//             "receiver": groupId,
//             "receiverType": "group"
//         }),
//       );
// DateTime endTime = DateTime.now();
//     Duration apiDuration = endTime.difference(startTime);

//     debugPrint("Send Message API Call Duration: ${apiDuration.inMilliseconds} ms");

//       if (response.statusCode == 200) {
//         // Refresh messages after sending a new one
//         _fetchMessages(false);
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send message: $e");
//     }
//   }
// }



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
  List<MessageModel> _messages = [];

  @override
  void onInit() {
    super.onInit();
    _fetchInitialMessages(); // Fetch initial 20 messages
    _timer = Timer.periodic(Duration(milliseconds: 800), (timer) => _fetchMessages(false));
  }

  @override
  void onClose() {
    _timer?.cancel();
    _messageController.close();
    super.onClose();
  }

  // Fetch initial 20 messages
  Future<void> _fetchInitialMessages() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final response = await ApiClient.getMessages(
        url: "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages?limit=20",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey("messages")) {
          final messagesData = responseData["messages"];

          if (messagesData is List && messagesData.isNotEmpty) {
            _messages = messagesData
                .map((msg) => MessageModel.fromJson({...msg, 'userId': userId}))
                .toList()
                .reversed
                .toList(); // Reverse to show latest messages first

            _messageController.add(_messages);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching initial messages: $e");
    } finally {
      _isLoading = false;
    }
  }

  // Fetch messages with pagination
  Future<void> _fetchMessages(bool loadMore) async {
    if (_isLoading || (loadMore && !hasMoreMessages)) return;
    _isLoading = true;

    try {
      String apiUrl = "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages?limit=20";

      if (loadMore && _messages.isNotEmpty) {
        // Fetch older messages with timestamp parameter
        int lastMessageTimestamp = _messages.first.time; // Timestamp of the oldest message
        int oneDayBack = lastMessageTimestamp - 86400; // Subtract 1 day in seconds (Unix format)
        apiUrl += "&timeStamp=$oneDayBack";
      }

      final response = await ApiClient.getMessages(
        url: apiUrl,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey("messages")) {
          final messagesData = responseData["messages"];

          if (messagesData is List && messagesData.isNotEmpty) {
            final List<MessageModel> newMessages = messagesData
                .map((msg) => MessageModel.fromJson({...msg, 'userId': userId}))
                .toList();

            if (loadMore) {
              _messages.insertAll(0, newMessages); // Add older messages at the start
            } else {
              _messages = newMessages.reversed.toList(); // Show latest messages first
            }

            _messageController.add(_messages);
          } else {
            hasMoreMessages = false; // No more messages to load
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (!_isLoading && hasMoreMessages) {
      await _fetchMessages(true); // Fetch older messages
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      final response = await apiClient.post(
        url: ApiEndpoints.sendMessage,
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
          "onBehalfOf": userId,
        },
        body: jsonEncode({
          "category": "message",
          "type": "text",
          "data": {
            "text": message,
          },
          "receiver": groupId,
          "receiverType": "group",
        }),
      );

      if (response.statusCode == 200) {
        _fetchMessages(false); // Refresh messages after sending a new one
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }
}