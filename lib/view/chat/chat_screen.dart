import 'dart:async';
import 'dart:convert';
import 'package:avatar_stack/positions.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/components/send_button.dart';
import 'package:clique/constants/app_colors.dart';
import 'package:clique/constants/app_svg_icons.dart';
import 'package:clique/data/repositories/group_chat_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:avatar_stack/animated_avatar_stack.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final int memberCount;
  final String guid;

  const GroupChatScreen({
    super.key,
    required this.groupName,
    required this.memberCount,
    required this.guid,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final StreamController<List<Map<String, dynamic>>> _messageController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  final TextEditingController _textController = TextEditingController();
  final GroupChatRepository _chatRepository = GroupChatRepository();
  
  Timer? _timer;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() {
    _fetchMessages();
    _startMessagePolling();
  }

  void _startMessagePolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchMessages());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _messageController.close();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _chatRepository.fetchMessages(widget.guid);
      if (messages != null) {
        _messageController.add(messages);
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isEmpty) return;

    setState(() => _isUploading = true);

    try {
      final success = await _chatRepository.sendMessage(
        widget.guid,
        _textController.text,
      );

      if (success) {
        _textController.clear();
        await _fetchMessages();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery);
    // TODO: Implement image upload functionality
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupAppBar(
                title: widget.groupName, 
                memberCount: widget.memberCount
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              _buildMessageList(),
              _buildChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Expanded(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _messageController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading messages"));
          }

          final messages = snapshot.data ?? [];
          return ListView.builder(
            reverse: false,
            itemCount: messages.length,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            itemBuilder: (_, index) => ChatMessageWidget(message: messages[index]),
          );
        },
      ),
    );
  }

  Widget _buildChatInput() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.04
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildMessageTextField(),
          ),
          SizedBox(width: screenWidth * 0.03),
          SendButton(onSend: _sendMessage)
        ],
      ),
    );
  }

  Widget _buildMessageTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 214, 211, 211))
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file, color: AppColors.black),
            onPressed: _pickImage,
          ),
        ],
      ),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final Map<String, dynamic> message;

  const ChatMessageWidget({
    super.key, 
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMe = message['isMe'] as bool;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.7,
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              gradient: isMe ? AppColors.appGradientColors : null,
              color: isMe ? null : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              message['message'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }
}
