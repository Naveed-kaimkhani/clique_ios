import 'dart:async';
import 'package:clique/components/chat_input.dart';
import 'package:clique/components/chat_message.dart';
import 'package:clique/components/group_appbar.dart';
import 'package:clique/components/load_message_shimmer.dart';
import 'package:clique/models/message_model.dart';
import 'package:clique/view/chat/chat_view_model.dart';
import 'package:clique/view_model/group_chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/user_controller.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupName;
  final int memberCount;
  final String guid;
  final String? profileImage;
  final int uid;

  GroupChatScreen({
    super.key,
    required this.groupName,
    this.profileImage,
    required this.uid,
    required this.memberCount,
    required this.guid,
  });

  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late GroupChatViewModel viewModel;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingOlderMessages = false;
  StreamSubscription<List<MessageModel>>? _messagesSubscription;
  bool _shouldScrollToBottom = true;

  final ChatViewModel controller = Get.put(ChatViewModel());
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

    // Subscribe to messages stream
    _messagesSubscription = viewModel.messagesStream.listen((messages) {
      if (_shouldScrollToBottom && messages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            // _scrollController
            //     .jumpTo(_scrollController.position.maxScrollExtent);
            _scrollController.jumpTo(0); // or animateTo(0)
          }
        });
      }
    });
  }

  void _onScroll() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.minScrollExtent &&
        !_isLoadingOlderMessages) {
      // setState(() {
      //   _isLoadingOlderMessages = true;
      //   _shouldScrollToBottom = false;
      // });

      final double offsetBefore = _scrollController.position.maxScrollExtent;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final double offsetAfter = _scrollController.position.maxScrollExtent;
          final double scrollOffsetDelta = offsetAfter - offsetBefore;

          _scrollController
              .jumpTo(_scrollController.position.pixels + scrollOffsetDelta);
        }
      });

      setState(() {
        _isLoadingOlderMessages = false;
      });
    }
  }

  void _scrollToBottom() {
    setState(() {
      _shouldScrollToBottom = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0, // Reversed list -> scroll to 0
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.hideReactionSheet();
    _messagesSubscription?.cancel();
    _scrollController.dispose();
    Get.delete<GroupChatViewModel>();

    // controller.hid
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<ChatViewModel>();
        if (controller.isReactionSheetVisible.value) {
          controller.hideReactionSheet();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GroupAppBar(
              profile: widget.profileImage,
              title: widget.groupName,
              memberCount: widget.memberCount,
              guid: widget.guid,
              uid: widget.uid,
            ),
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: viewModel.messagesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadMessageAnimation();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No messages found"));
                  }

                  final messages = snapshot.data!;

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    padding: EdgeInsets.all(16),
                    itemCount:
                        (_isLoadingOlderMessages ? 1 : 0) + messages.length,
                    itemBuilder: (context, index) {
                      if (_isLoadingOlderMessages && index == 0) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }

                      final messageIndex =
                          index - (_isLoadingOlderMessages ? 1 : 0);

                      // ✅ Safety check
                      if (messageIndex < 0 || messageIndex >= messages.length) {
                        return const SizedBox.shrink();
                      }
                      return ChatMessageWidget(
                        message: messages[messageIndex],
                        enableSwipe: true,
                        enableReactions: true,
                        showReplyPreview: true,
                        streamThreadMessagesCallback: (id) =>
                            viewModel.streamThreadMessages(id),
                      );
                      // return ChatMessageWidget(message: messages[messageIndex]);
                    },
                  );
                },
              ),
            ),
            ChatInputWidget(
              onSend: (message, replyingTo) {
                final ChatViewModel chatViewModel = Get.find<ChatViewModel>();
                final repliedMessage = chatViewModel.repliedMessage.value;

                if (repliedMessage == null) {
                  // No reply context; send a regular message
                  viewModel.sendMessage(message).then((_) {
                    _scrollToBottom();
                    setState(() {
                      viewModel.replyingTo.value = null;
                    });
                  });
                } else {
                  // Replying to an original message; send as a thread
                  viewModel
                      .sendThread(message, int.parse(repliedMessage.id))
                      .then((_) {
                    _scrollToBottom();
                    setState(() {
                      viewModel.replyingTo.value = null;
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
