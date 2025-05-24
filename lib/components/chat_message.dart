// import 'dart:developer';

// import 'package:clique/components/reaction_sheet.dart';
// import 'package:clique/controller/user_controller.dart';
// import 'package:clique/view/chat/chat_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../models/message_model.dart';
// import '../constants/app_colors.dart';

// class ChatMessageWidget extends StatelessWidget {
//   final MessageModel message;
//   final bool enableSwipe;
//   final bool enableReactions;
//   final bool showReplyPreview;
//   final Stream<List<MessageModel>> Function(String parentMessageId)?
//       streamThreadMessagesCallback;

//   ChatMessageWidget({
//     Key? key,
//     required this.message,
//     this.enableSwipe = true,
//     this.enableReactions = true,
//     this.showReplyPreview = true,
//     this.streamThreadMessagesCallback, // accept callback here
//   }) : super(key: key);

//   final chatViewModel = Get.find<ChatViewModel>();
//   final userController = Get.find<UserController>();

//   String convertTimestampTo24HourUTC(int timestamp) {
//     final dateTime =
//         DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
//     final formatter = DateFormat('HH:mm');
//     return formatter.format(dateTime.toUtc());
//   }

//   void showReactionsOverlay(BuildContext context, Offset position) {
//     final overlay = Overlay.of(context);
//     if (overlay == null) return;

//     final screenWidth = MediaQuery.of(context).size.width;
//     double left = position.dx;

//     if (!message.isMe) {
//       left = position.dx - screenWidth * 0.2;
//       if (left < 10) left = 10;
//     }

//     final overlayEntry = OverlayEntry(
//       builder: (_) => Positioned(
//         left: left,
//         top: position.dy - 50,
//         child: Material(
//           color: Colors.transparent,
//           child: ReactionSheet(
//             onReactionSelected: (reaction) {
//               chatViewModel.toggleReaction(
//                   message.id, reaction, userController.uid.value);
//               chatViewModel.hideReactionSheet();
//             },
//           ),
//         ),
//       ),
//     );

//     chatViewModel.showReactionSheet(overlayEntry, context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final reactionStream =
//         enableReactions ? chatViewModel.getReactionsStream(message.id) : null;

//     return GestureDetector(
//       onHorizontalDragUpdate: enableSwipe
//           ? (details) {
//               if (details.primaryDelta != null && details.primaryDelta! > 15) {
//                 log("Swiped right on message: ${message.id}");
//                 chatViewModel.setReplyMessage(message);
//               } else if (details.primaryDelta != null &&
//                   details.primaryDelta! < -15) {
//                 log("Swiped left on message: ${message.id}");
//               }
//             }
//           : null,
//       onLongPress: enableReactions
//           ? () {
//               final RenderBox renderBox =
//                   context.findRenderObject() as RenderBox;
//               final position = renderBox.localToGlobal(Offset.zero);
//               showReactionsOverlay(context, position);
//             }
//           : null,
//       child: Align(
//         alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
//         child: Column(
//           crossAxisAlignment:
//               message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Container(
//               constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding: EdgeInsets.all(screenWidth * 0.03),
//               decoration: BoxDecoration(
//                 gradient: message.isMe
//                     ? AppColors.appGradientColors
//                     : const LinearGradient(
//                         colors: [Colors.white, Colors.white]),
//                 borderRadius: BorderRadius.only(
//                   topLeft: const Radius.circular(15),
//                   topRight: const Radius.circular(15),
//                   bottomLeft: Radius.circular(message.isMe ? 15 : 0),
//                   bottomRight: Radius.circular(message.isMe ? 0 : 15),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 8,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (!message.isMe)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 5),
//                       child: Text(
//                         message.sender,
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: message.isMe ? Colors.white : Colors.black,
//                         ),
//                       ),
//                     ),

//                   // Optional Reply Preview
//                   if (showReplyPreview &&
//                       message.parentId != null &&
//                       message.parentMessage != null)
//                     _buildReplyPreview(),

//                   // Message Text
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Text(
//                       message.message,
//                       style: TextStyle(
//                         color: message.isMe ? Colors.white : Colors.black,
//                         fontSize: 15,
//                       ),
//                     ),
//                   ),

//                   // Timestamp & Reactions Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       if (enableReactions && reactionStream != null)
//                         StreamBuilder<Map<String, int>>(
//                           stream: reactionStream,
//                           builder: (context, snapshot) {
//                             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                               return const SizedBox();
//                             }
//                             return Row(
//                               children: [
//                                 ...snapshot.data!.entries.map((entry) {
//                                   return Container(
//                                     margin: const EdgeInsets.only(right: 4),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: message.isMe
//                                           ? Colors.white.withOpacity(0.2)
//                                           : Colors.grey.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           entry.key,
//                                           style: const TextStyle(fontSize: 14),
//                                         ),
//                                         if (entry.value > 1)
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 2),
//                                             child: Text(
//                                               entry.value.toString(),
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: message.isMe
//                                                     ? Colors.white
//                                                     : Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                       ],
//                                     ),
//                                   );
//                                 }).toList(),
//                                 const SizedBox(width: 4),
//                               ],
//                             );
//                           },
//                         ),

//                       // Timestamp
//                       Text(
//                         convertTimestampTo24HourUTC(message.time),
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: message.isMe ? Colors.white70 : Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReplyPreview() {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           left: BorderSide(
//             color: message.isMe ? Colors.white70 : AppColors.appColor,
//             width: 3,
//           ),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Replying to ${message.parentMessage!.sender}",
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: message.isMe ? Colors.white70 : Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
//               decoration: BoxDecoration(
//                 color: message.isMe
//                     ? Colors.white.withOpacity(0.1)
//                     : Colors.grey.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 message.parentMessage!.message,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: message.isMe
//                       ? Colors.white.withOpacity(0.9)
//                       : Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             StreamBuilder<List<MessageModel>>(
//               stream: streamThreadMessagesCallback != null
//                   ? streamThreadMessagesCallback!(message.parentMessage!.id)
//                   : null,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Text(
//                     'Error loading replies',
//                     style: TextStyle(color: Colors.red),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return Text(
//                     'No replies yet',
//                     style: TextStyle(color: Colors.grey),
//                   );
//                 } else {
//                   final replies = snapshot.data!;
//                   return SizedBox(
//                     height: 150,
//                     child: ListView.builder(
//                       itemCount: replies.length,
//                       itemBuilder: (context, index) {
//                         final reply = replies[index];
//                         return ListTile(
//                           // leading: CircleAvatar(
//                           //   backgroundImage: NetworkImage(reply.avatar),
//                           // ),
//                           title: Text(reply.sender),
//                           subtitle: Text(
//                             reply.message,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

// }

// ///
// import 'package:clique/components/reaction_sheet.dart';
// import 'package:clique/controller/user_controller.dart';
// import 'package:clique/view/chat/chat_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// import '../models/message_model.dart';

// class ChatMessageWidget extends StatelessWidget {
//   final MessageModel message;
//   final bool enableSwipe;
//   final bool enableReactions;
//   final bool showReplyPreview;
//   final Stream<List<MessageModel>> Function(String parentMessageId)?
//       streamThreadMessagesCallback;

//   ChatMessageWidget({
//     Key? key,
//     required this.message,
//     this.enableSwipe = true,
//     this.enableReactions = true,
//     this.showReplyPreview = true,
//     this.streamThreadMessagesCallback,
//   }) : super(key: key);

//   final chatViewModel = Get.find<ChatViewModel>();
//   final userController = Get.find<UserController>();

//   String convertTimestampTo24HourUTC(int timestamp) {
//     final dateTime =
//         DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
//     final formatter = DateFormat('HH:mm');
//     return formatter.format(dateTime.toUtc());
//   }

//   void showReactionsOverlay(BuildContext context, Offset position) {
//     final overlay = Overlay.of(context);
//     if (overlay == null) return;

//     final screenWidth = MediaQuery.of(context).size.width;
//     double left = position.dx;

//     if (!message.isMe) {
//       left = position.dx - screenWidth * 0.2;
//       if (left < 10) left = 10;
//     }

//     final overlayEntry = OverlayEntry(
//       builder: (_) => Positioned(
//         left: left,
//         top: position.dy - 50,
//         child: Material(
//           color: Colors.transparent,
//           child: ReactionSheet(
//             onReactionSelected: (reaction) {
//               chatViewModel.toggleReaction(
//                   message.id, reaction, userController.uid.value);
//               chatViewModel.hideReactionSheet();
//             },
//           ),
//         ),
//       ),
//     );

//     chatViewModel.showReactionSheet(overlayEntry, context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final reactionStream =
//         enableReactions ? chatViewModel.getReactionsStream(message.id) : null;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // If this is a reply message and we're not showing preview, just show it
//         if (message.parentId != null && !showReplyPreview)
//           _buildMessageBubble(context, message, isReply: true),

//         // For parent messages or when showing preview
//         if (message.parentId == null || showReplyPreview)
//           Container(
//             constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 4,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Parent message
//                 if (message.parentId == null)
//                   _buildMessageContent(context, message),

//                 // Replies section
//                 if (message.parentId == null && showReplyPreview)
//                   StreamBuilder<List<MessageModel>>(
//                     stream: streamThreadMessagesCallback != null
//                         ? streamThreadMessagesCallback!(message.id)
//                         : null,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Padding(
//                           padding: EdgeInsets.all(8.0),
//                           child: Center(child: CircularProgressIndicator()),
//                         );
//                       } else if (snapshot.hasError) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'Error loading replies',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         );
//                       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                         return const SizedBox();
//                       } else {
//                         return Column(
//                           children: [
//                             const Divider(height: 1, thickness: 1),
//                             ...snapshot.data!
//                                 .map(
//                                   (reply) => Padding(
//                                     padding: const EdgeInsets.only(top: 8),
//                                     child: _buildMessageContent(
//                                       context,
//                                       reply,
//                                       isReply: true,
//                                     ),
//                                   ),
//                                 )
//                                 .toList(),
//                           ],
//                         );
//                       }
//                     },
//                   ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildMessageBubble(BuildContext context, MessageModel message,
//       {bool isReply = false}) {
//     return Container(
//       constraints:
//           BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: isReply ? Colors.grey[100] : Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             spreadRadius: 1,
//           ),
//         ],
//       ),
//       child: _buildMessageContent(context, message, isReply: isReply),
//     );
//   }

//   Widget _buildMessageContent(BuildContext context, MessageModel message,
//       {bool isReply = false}) {
//     final reactionStream =
//         enableReactions ? chatViewModel.getReactionsStream(message.id) : null;

//     return Padding(
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Sender name
//           Padding(
//             padding: const EdgeInsets.only(bottom: 4),
//             child: Text(
//               message.sender,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//           ),

//           // Message text
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4),
//             child: Text(
//               message.message,
//               style: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 15,
//               ),
//             ),
//           ),

//           // Timestamp and reactions
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               if (enableReactions && reactionStream != null)
//                 StreamBuilder<Map<String, int>>(
//                   stream: reactionStream,
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const SizedBox();
//                     }
//                     return Row(
//                       children: [
//                         ...snapshot.data!.entries
//                             .map(
//                               (entry) => Container(
//                                 margin: const EdgeInsets.only(right: 4),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 6, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       entry.key,
//                                       style: const TextStyle(fontSize: 14),
//                                     ),
//                                     if (entry.value > 1)
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 2),
//                                         child: Text(
//                                           entry.value.toString(),
//                                           style: TextStyle(
//                                             fontSize: 10,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                             .toList(),
//                       ],
//                     );
//                   },
//                 ),
//               Text(
//                 convertTimestampTo24HourUTC(message.time),
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:clique/components/reaction_sheet.dart';
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
    final reactionStream =
        enableReactions ? chatViewModel.getReactionsStream(message.id) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // If this is a reply message and we're not showing preview, just show it
        if (message.parentId != null && !showReplyPreview)
          _buildReplyBubble(context, message),

        // For parent messages or when showing preview
        if (message.parentId == null || showReplyPreview)
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.7),
            margin: const EdgeInsets.symmetric(vertical: 6),
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
                    padding: const EdgeInsets.all(12),
                    child: _buildMessageContent(context, message),
                  ),

                // Replies section
                if (message.parentId == null && showReplyPreview)
                  StreamBuilder<List<MessageModel>>(
                    stream: streamThreadMessagesCallback != null
                        ? streamThreadMessagesCallback!(message.id)
                        : null,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
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
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
    );
  }

  Widget _buildReplyBubble(BuildContext context, MessageModel message) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
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
