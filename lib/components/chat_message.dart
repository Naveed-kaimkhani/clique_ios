import 'package:clique/components/reaction_sheet.dart';
import 'package:clique/controller/user_controller.dart';
import 'package:clique/view/chat/chat_view_model.dart';
import 'package:clique/view_model/group_chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../constants/app_colors.dart'; // Assuming you have this file for colors

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
              chatViewModel.addReactionToMessage(message.id, reaction, userController.uid.value);
              chatViewModel.hideReactionSheet();
            },
//             onReactionSelected: (reaction) {
//   chatViewModel.toggleReaction(message.id, reaction, userController.uid.value);
//   chatViewModel.hideReactionSheet();
// },
          ),
        ),
      ),
    );

    // chatViewModel.showReactionSheet(overlayEntry, context); // 🔧 pass overlay
  }
  @override
  Widget build(BuildContext context) {
        final controller = Get.find<GroupChatViewModel>();

    final screenWidth = MediaQuery.of(context).size.width;
final reactionStream = chatViewModel.getReactionsStream(message.id);

    return GestureDetector(
          onHorizontalDragEnd: (_) => controller.setReplyToMessage(message),

      onLongPress: () {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        showReactionsOverlay(context, position); // ✅ pass local context
      },
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Chat Bubble
            Container(
              width: screenWidth * 0.7,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                gradient: message.isMe
                    ? AppColors.appGradientColors
                    : const LinearGradient(
                        colors: [Colors.white, Colors.white]),
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  Text(
                    message.message,
                    style: TextStyle(
                      color: message.isMe
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        convertTimestampTo24HourUTC(message.time),
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: message.isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),

             
            

StreamBuilder<Map<String, int>>(
  stream: reactionStream,
  builder: (context, snapshot) {
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const SizedBox();
    }

    final reactions = snapshot.data!;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: reactions.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: message.isMe ? Colors.white24 : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.key),
              const SizedBox(width: 4),
              Text(
                entry.value.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: message.isMe ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  },
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
