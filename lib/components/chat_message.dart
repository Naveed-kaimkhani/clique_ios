import 'dart:developer';

import 'package:clique/components/reaction_sheet.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/chat/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../constants/app_colors.dart';

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;
  final chatViewModel = Get.find<ChatViewModel>();
  final userController = Get.find<UserController>();

  ChatMessageWidget({super.key, required this.message});

  final isUploading = false.obs;

  String convertTimestampTo24HourUTC(int timestamp) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
    final formatter = DateFormat('HH:mm');
    return formatter.format(dateTime.toUtc());
  }

  void showReactionsOverlay(BuildContext context, Offset position) {
    final overlay = Overlay.of(context); // ✅ Use passed context

    if (overlay == null) {
      print("Overlay not found");
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;

    double left = position.dx;
    if (!message.isMe) {
      left = position.dx - screenWidth * 0.2;
      if (left < 10) left = 10;
    }

    final overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: left,
        top: position.dy - 50,
        child: Material(
          color: Colors.transparent,
          child: ReactionSheet(
            onReactionSelected: (reaction) {
              chatViewModel.toggleReaction(
                  message.id, reaction, userController.uid.value);
              chatViewModel.hideReactionSheet();
            },
          ),
        ),
      ),
    );

    chatViewModel.showReactionSheet(overlayEntry, context); // 🔧 pass overlay
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final reactionStream = chatViewModel.getReactionsStream(message.id);

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
      onLongPress: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        showReactionsOverlay(context, position);
      },
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                gradient: message.isMe
                    ? AppColors.newGradientColors
                    : const LinearGradient(
                        colors: [Colors.white, Colors.white]),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: Radius.circular(message.isMe ? 15 : 0),
                  bottomRight: Radius.circular(message.isMe ? 0 : 15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        message.sender,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: message.isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),

                  // 🔁 Enhanced Reply Preview
                  if (message.parentId != null && message.parentMessage != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: message.isMe
                                ? Colors.white70
                                : AppColors.blueColor,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Parent message sender name
                            Text(
                              "Replying to ${message.parentMessage!.sender}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: message.isMe
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 4),
                            // Parent message content
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 8),
                              decoration: BoxDecoration(
                                color: message.isMe
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                message.parentMessage!.message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: message.isMe
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // 💬 Message Text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  // Bottom row with timestamp and status
                  // Bottom row with timestamp, status, and reply button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Reply button - appears on hover/long-press or permanently
                      IconButton(
                        icon: Icon(
                          Icons.reply,
                          size: 16,
                          color: message.isMe ? Colors.white70 : Colors.black54,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        onPressed: () {
                          // Handle reply action here
                          // onReplyPressed?.call(message);
                        },
                        tooltip: 'Reply',
                      ),
                      const SizedBox(width: 4),

                      // Reactions (if any)
                      StreamBuilder<Map<String, int>>(
                        stream: reactionStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const SizedBox();
                          }
                          return Row(
                            children: [
                              ...snapshot.data!.entries.map((entry) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 4),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: message.isMe
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      if (entry.value > 1)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2),
                                          child: Text(
                                            entry.value.toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: message.isMe
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(width: 4),
                            ],
                          );
                        },
                      ),

                      // Timestamp
                      Text(
                        convertTimestampTo24HourUTC(message.time),
                        style: TextStyle(
                          fontSize: 11,
                          color: message.isMe ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  if (message.parentId != null && message.parentMessage != null)
                    TextButton.icon(
                      onPressed: () {
                        // Get.to(() => MessageRepliesScreen(parentMessage: message));
                      },
                      icon: const Icon(Icons.forum,
                          size: 16, color: AppColors.blueColor),
                      label: Text(
                        "View more replies",
                        style: TextStyle(color: AppColors.blueColor),
                      ),
                      style: TextButton.styleFrom(
                        // backgroundColor: AppColors.blueColor,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(0, 0),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
