import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clique/core/api/api_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

class ThreadViewModel extends GetxController {
  final String groupId;
  final String token;
  final String userId;
  final int messageid;

  ThreadViewModel({
    required this.groupId,
    required this.token,
    required this.messageid,
    required this.userId,
  });
  final Rx<MessageModel?> replyingTo = Rx<MessageModel?>(null);

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
    _fetchInitialMessages(messageid); // Fetch initial 20 messages
    // _timer = Timer.periodic(Duration(milliseconds: 800), (timer) => _fetchInitialMessages());
  }

  @override
  void onClose() {
    _timer?.cancel();
    _messageController.close();
    super.onClose();
  }

  void setReplyToMessage(MessageModel message) {
    replyingTo.value = message;
  }

  void cancelReply() {
    replyingTo.value = null;
  }


  // Future<void> sendMessage(String message) async {
  //   final replyMessage = replyingTo.value;

  //   if (message.isEmpty) return;

  //   try {
  //     final response = await apiClient.post(
  //       url: ApiEndpoints.sendMessage,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "accept": "application/json",
  //         "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
  //         "onBehalfOf": userId,
  //       },
  //       body: jsonEncode({
  //         "category": "message",
  //         "type": "text",
  //         "data": {
  //           "text": message,
  //         },
  //         "receiver": groupId,
  //         "receiverType": "group",
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       _fetchInitialMessages(); // Refresh messages after sending a new one
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to send message: $e");
  //   }
  // }


  Future<void> _fetchInitialMessages(int messageId) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final response = await ApiClient.getMessages(
        url:
            "https://269435d754e8fd97.api-us.cometchat.io/v3/messages/$messageId/thread",
        headers: {
          "Content-Type": "application/json",
          "accept": "application/json",
          "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
          "onBehalfOf": userId,
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        final List<dynamic> rawMessages = responseData['data'] ?? [];

        if (rawMessages.isEmpty) {
          debugPrint("No messages found");
          return;
        }

        final List<Map<String, dynamic>> cleanedRawMessages = rawMessages
            .map((msg) {
              final sender = msg['data']?['entities']?['sender']?['entity'];
              if (sender == null ||
                  sender['name'] == null ||
                  sender['uid'] == null) return null;
              // log(msg['data']?['text']);
              // log(msg['replyCount'].toString());
              return {
                'id': msg['id'] ?? '',
                'name': sender['name'],
                'avatar': sender['avatar'] ??
                    'https://your-default-avatar-url.com/default.png',
                'uid': sender['uid'],
                'message': msg['data']?['text'] ?? '',
                'reactions': msg['data']?['reactions'] ?? [],
                'sentAt': msg['sentAt'],
                'replyCount': msg['replyCount'] ?? 0, // 👈 add this

                'parentId': msg['parentId'],
                'userId': userId,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();

        final List<MessageModel> formattedMessages =
            parseMessages(cleanedRawMessages);

        formattedMessages.sort((a, b) => (b.time).compareTo(a.time));

        _messages = formattedMessages;
        _messageController.add(_messages);

        final meta = {
          'previous': responseData['meta']?['previous'],
          'current': {
            'limit': 200,
            'count': formattedMessages.length,
          },
          'next': responseData['meta']?['next'],
        };
        debugPrint("Pagination Meta: $meta");
      }
    } catch (e) {
      debugPrint("Error fetching initial messages: $e");
    } finally {
      _isLoading = false;
    }
  }

  // Future<void> _fetchInitialMessages(int parentid) async {
  //   log(parentid.toString());
  //   if (_isLoading) return;
  //   _isLoading = true;

  //   try {
  //     final response = await ApiClient.getMessages(
  //       url:
  //           "https://269435d754e8fd97.api-us.cometchat.io/v3/messages/$parentid/thread",
  //       headers: {
  //         "Content-Type": "application/json",
  //         "accept": "application/json",
  //         "apikey": "f6985bc6a317824cc687e82794955efded6bf2b1",
  //         "onBehalfOf": userId,
  //       },
  //     );
  //     log(response.body);
  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       final List<ThreadModel> fetched = (jsonData['data'] as List)
  //           .map((e) => ThreadModel.fromJson(e))
  //           .toList();

  //       _messages.assignAll(fetched);
  //     }
  //   } catch (e) {
  //     log("Failed to fetch thread: $e");
  //   } finally {
  //     // isLoading.value = false;
  //   }
  // }

  Future<void> sendThread(String message, int messageId) async {
    // final replyMessage = replyingTo.value;
    log("replying to $messageId");
    if (message.isEmpty) return;

    try {
      final response = await apiClient.post(
        // url: ApiEndpoints.sendMessage,
        url:
            "https://269435d754e8fd97.api-us.cometchat.io/v3/messages/$messageId/thread",
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
      log(response.body);
      if (response.statusCode == 200) {
        _fetchInitialMessages(
            messageid); // Refresh messages after sending a new one
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }
}
