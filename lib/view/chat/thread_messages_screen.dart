import 'dart:convert';

import 'package:clique/components/chat_message.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
class ThreadMessagesScreen extends StatefulWidget {
  final MessageModel parentMessage;

   ThreadMessagesScreen({super.key, required this.parentMessage});

  @override
  State<ThreadMessagesScreen> createState() => _ThreadMessagesScreenState();
}

class _ThreadMessagesScreenState extends State<ThreadMessagesScreen> {
  final messages = <MessageModel>[].obs;
  final isLoading = true.obs;

  final userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    fetchThreadMessages();
  }

  Future<void> fetchThreadMessages() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://269435d754e8fd97.api-us.cometchat.io/v3/messages/${widget.parentMessage.id}/thread',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'apikey': 'f6985bc6a317824cc687e82794955efded6bf2b1',
          'onBehalfOf': userController.uid.value.toString(),
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<MessageModel> fetched = (jsonData['data'] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList();

        messages.assignAll(fetched);
      }
    } catch (e) {
      print("Failed to fetch thread: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread'),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ChatMessageWidget(message: widget.parentMessage),
            const Divider(),
            ...messages.map((msg) => ChatMessageWidget(message: msg)).toList(),
          ],
        );
      }),
    );
  }
}
