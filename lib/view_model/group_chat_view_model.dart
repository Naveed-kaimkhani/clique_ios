// view_models/group_chat_view_model.dart
import 'dart:async';
import 'dart:convert';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

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
//   bool _isFirstLoad = true;
//   bool _isSending = false;

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

//   Future<void> _fetchMessages() async {
//     try {
//       final response = await ApiClient.getMessages(
//         url: ApiEndpoints.groupMessages(groupId),
//         headers: {"Authorization": "Bearer $token"},
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = jsonDecode(response.body);
//         final List<MessageModel> messages = responseData
//             .map((msg) => MessageModel.fromJson({
//                   ...msg,
//                   'userId': userId, // Pass userId for comparison
//                 }))
//             .toList();

//         _messageController.add(messages);

//         if (_isFirstLoad) {
//           _isFirstLoad = false;
//         }
//       }
//     } catch (e) {
//       debugPrint("Error fetching messages: $e");
//     }
//   }

//   Future<void> sendMessage(String message) async {
//     if (message.isEmpty || _isSending) return;

//     _isSending = true;

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
//         // Message sent successfully
//       } else if (response.statusCode == 429) {
//         Get.snackbar("Too Many Requests", "Please wait a moment.");
//       } else {
//         Get.snackbar("Error", "Failed to send message.");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Something went wrong: $e");
//     } finally {
//       _isSending = false;
//     }
//   }
// }



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
  bool _isFirstLoad = true;
  bool _isLoading = false;
  bool _hasMoreMessages = true;
  int _currentPage = 1;
  final int _messagesPerPage = 20; // Number of messages to load per page

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
    if (_isLoading || (loadMore && !_hasMoreMessages)) return;

    _isLoading = true;

    try {
      // final response = await ApiClient.get(
      //   url: "${ApiEndpoints.groupMessages(groupId)}?page=$_currentPage&limit=$_messagesPerPage",
      //   headers: {"Authorization": "Bearer $token"},
      // );
            final response = await ApiClient.getMessages(
        url: ApiEndpoints.groupMessages(groupId),
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
          // Append older messages to the beginning of the list
          _messages.insertAll(0, newMessages);
        } else {
          // Replace the list with new messages
          _messages = newMessages;
        }

        _messageController.add(_messages);

        // Check if there are more messages to load
        if (newMessages.length < _messagesPerPage) {
          _hasMoreMessages = false;
        } else {
          _currentPage++;
        }

        if (_isFirstLoad) {
          _isFirstLoad = false;
        }
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadMoreMessages() async {
    if (!_isLoading && _hasMoreMessages) {
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