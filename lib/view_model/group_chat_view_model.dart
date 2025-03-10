import 'dart:async';
import 'dart:convert';
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

  Timer? _timer;
  bool _isLoading = false;
  bool hasMoreMessages = true;
  int _currentPage = 1;
  final int _messagesPerPage = 5; // Number of messages to load per page

  List<MessageModel> _messages = [];

  @override
  void onInit() {
    super.onInit();
    _fetchMessages();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => _fetchMessages());
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
        url: "https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages?page=$_currentPage&limit=$_messagesPerPage",
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
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

        _messageController.add(_messages);

        // Check if there are more messages to load
        if (newMessages.length < _messagesPerPage) {
          hasMoreMessages = false;
        } else {
          _currentPage++;
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
      await _fetchMessages(loadMore: true);
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    try {
      final response = await ApiClient.post(
        url: ApiEndpoints.sendMessage,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "group_id": groupId,
          "sender_uid": userId,
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        // Refresh messages after sending a new one
        _fetchMessages();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }
}
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

//   Timer? _timer;
//   bool _isLoading = false;
//   bool hasMoreMessages = true;
//   int _currentPage = 1;
//   final int _messagesPerPage = 5; // Number of messages to load per page

//   List<MessageModel> _messages = [];

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchMessages();
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) => _fetchMessages());
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     _messageController.close();
//     super.onClose();
//   }

//   Future<void> _fetchMessages({bool loadMore = false}) async {
//     log("loading message for grup");
//     log(groupId);
//     if (_isLoading || (loadMore && !hasMoreMessages)) return;

//     _isLoading = true;

//     try {
//       final response = await ApiClient.getMessages(
//         url:"https://dev.moutfits.com/api/v1/cometchat/groups/$groupId/messages",
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = jsonDecode(response.body);
//         final List<MessageModel> newMessages = responseData
//             .map((msg) => MessageModel.fromJson({
//                   ...msg,
//                   'userId': userId, // Pass userId for comparison
//                 }))
//             .toList();

//         if (loadMore) {
//           // Append older messages to the end of the list
//           _messages.addAll(newMessages);
//         } else {
//           // Replace the list with new messages (latest messages first)
//           _messages = newMessages.reversed.toList(); // Reverse to show latest first
//         }

//         _messageController.add(_messages);

//         // Check if there are more messages to load
//         if (newMessages.length < _messagesPerPage) {
//           hasMoreMessages = false;
//         } else {
//           _currentPage++;
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching messages: $e");
//     } finally {
//       _isLoading = false;
//     }
//   }

//   Future<void> loadMoreMessages() async {
//     if (!_isLoading && hasMoreMessages) {
//       await _fetchMessages(loadMore: true);
//     }
//   }

//   Future<void> sendMessage(String message) async {
//     if (message.isEmpty) return;

//     try {
//       final response = await ApiClient.post(
//         url: ApiEndpoints.sendMessage,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({
//           "group_id": groupId,
//           "sender_uid": userId,
//           "message": message,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // Refresh messages after sending a new one
//         _fetchMessages();
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Failed to send message: $e");
//     }
//   }
// }