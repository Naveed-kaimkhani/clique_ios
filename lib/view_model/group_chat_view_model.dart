import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:clique/core/api/api_client.dart';
import 'package:clique/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';



class GroupChatViewModel extends GetxController {
  final String groupId;
  final String token;
  final String userId;

  GroupChatViewModel({
    required this.groupId,
    required this.token,
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
    _fetchInitialMessages(); // Fetch initial 20 messages
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
  // Fetch initial 20 messages
  Future<void> _fetchInitialMessages() async {
    if (_isLoading) return;
    _isLoading = true;

    try {

      final response = await ApiClient.getMessages(
        url: "https://cactisocial.com/api-clique/public/api/v1/cometchat/groups/$groupId/messages?limit=200",
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
           log("msg lenght");
              log(_messages.length.toString());
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

  Future<void> loadMoreMessages() async {
   
      // await _loadMoreMessages(); 
  }

  Future<void> sendMessage(String message) async {
      final replyMessage = replyingTo.value;

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
        _fetchInitialMessages(); // Refresh messages after sending a new one
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }
}


