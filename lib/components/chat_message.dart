import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/chat/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/message_model.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool enableSwipe;
  final bool enableReactions;
  final bool showReplyPreview;
  final Stream<List<MessageModel>> Function(String parentMessageId)?
      streamThreadMessagesCallback;

  ChatMessageWidget({
    Key? key,
    required this.message,
    this.enableSwipe = true,
    this.enableReactions = true,
    this.showReplyPreview = true,
    this.streamThreadMessagesCallback,
  }) : super(key: key);

  final chatViewModel = Get.find<ChatViewModel>();
  final userController = Get.find<UserController>();

  String convertTimestampTo24HourUTC(int timestamp) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime.toUtc());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final reactionStream =
    //     enableReactions ? chatViewModel.getReactionsStream(message.id) : null;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 15) {
          log("Swiped right on message: ${message.id}");
          chatViewModel.setReplyMessage(message);
        } else if (details.primaryDelta != null &&
            details.primaryDelta! < -15) {
          log("Swiped left on message: ${message.id}");
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // If this is a reply message and we're not showing preview, just show it
          if (message.parentId != null && !showReplyPreview)
            _buildReplyBubble(context, message),

          // For parent messages or when showing preview
          if (message.parentId == null || showReplyPreview)
            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parent message with padding
                  if (message.parentId == null)
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: _buildMessageContent(context, message),
                    ),

                  // Replies section
                  if (message.parentId == null && showReplyPreview)
                    StreamBuilder<List<MessageModel>>(
                      stream: streamThreadMessagesCallback != null
                          ? streamThreadMessagesCallback!(message.id)
                          : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator.adaptive(backgroundColor: Colors.white, strokeWidth: 2),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Error loading replies',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Column(
                            children: [
                              // Add dividers between replies
                              ...List<Widget>.generate(
                                  snapshot.data!.length * 2 - 1, (index) {
                                if (index.isOdd) {
                                  return const Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 12,
                                    endIndent: 12,
                                    color: Colors.grey,
                                  );
                                }
                                return _buildReplyBubble(
                                  context,
                                  snapshot.data![index ~/ 2],
                                );
                              }),
                            ],
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReplyBubble(BuildContext context, MessageModel message) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        // color: Colors.white,
        border: Border(
          left: BorderSide(
            color: Colors.grey[300]!,
            // color: Colors.white,
            width: 3,
          ),
        ),
      ),
      child: _buildMessageContent(context, message),
    );
  }

  Widget _buildMessageContent(BuildContext context, MessageModel message) {
    final reactionStream =
        enableReactions ? chatViewModel.getReactionsStream(message.id) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sender name
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            message.sender,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ),

        // Message text
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            message.message,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ),

        // Timestamp and reactions
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (enableReactions && reactionStream != null)
              StreamBuilder<Map<String, int>>(
                stream: reactionStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox();
                  }
                  return Row(
                    children: [
                      ...snapshot.data!.entries
                          .map(
                            (entry) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  if (entry.value > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        entry.value.toString(),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  );
                },
              ),
            Text(
              convertTimestampTo24HourUTC(message.time),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
