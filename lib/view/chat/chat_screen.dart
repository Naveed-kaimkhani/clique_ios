import 'dart:developer';
import 'package:clique/components/chat_input.dart';
import 'package:clique/components/chat_message.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/models/message_model.dart';
import 'package:clique/view_model/group_chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controller/user_controller.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final int memberCount;
  final String guid;
  final String? profileImage;

  GroupChatScreen({
    super.key,
    required this.groupName,
    this.profileImage,
    required this.memberCount,
    required this.guid,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late GroupChatViewModel viewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingOlderMessages = false; // Flag to track loading older messages

  @override
  void initState() {
    super.initState();
    final UserController userController = Get.find<UserController>();

    viewModel = Get.put(GroupChatViewModel(
      groupId: widget.guid,
      token: userController.token.value,
      userId: userController.uid.value.toString(),
    ));

    _scrollController.addListener(_onScroll);

    // Scroll to bottom after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      log("Reached at top");
      setState(() {
        _isLoadingOlderMessages =
            true; // Set flag to true when loading older messages
      });
      viewModel.loadMoreMessages().then((_) {
        setState(() {
          _isLoadingOlderMessages =
              false; // Reset flag after loading is complete
        });
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    // Dispose the ScrollController
    _scrollController.dispose();

    // Dispose the ViewModel
    Get.delete<GroupChatViewModel>(); // Dispose the ViewModel

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GroupAppBar(
            profile: widget.profileImage,
            title: widget.groupName,
            memberCount: widget.memberCount,
          ),
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: viewModel.messagesStream,
              builder: (context, snapshot) {
                    if (snapshot.hasError ) {
                  return  Center(child: Text(snapshot.error.toString()));

                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadMessageAnimation();

                }

               if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return const Center(child: Text("No messages found"));
}
                final messages = snapshot.data!;
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  reverse:
                      false, // Set to false to show latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessageWidget(message: messages[index]);
                  },
                );
              },
            ),
          ),
          ChatInputWidget(
            onSend: (message) {
              viewModel.sendMessage(message).then((_) {
                _scrollToBottom(); // Scroll to bottom after sending a new message
              });
            },
          ),
        ],
      ),
    );
  }
}

class LoadMessageAnimation extends StatelessWidget {
  const LoadMessageAnimation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/lottie/chat_loading.json', width: 100),
          SizedBox(height: 16),
          Text(
            "Fetching hot gossip...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
