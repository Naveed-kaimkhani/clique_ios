
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';
import '../constants/app_colors.dart'; // Assuming you have this file for colors

class ChatMessageWidget extends StatelessWidget {
  final MessageModel message;

  const ChatMessageWidget({super.key, required this.message});
String convertTimestampTo24HourUTC(int timestamp) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  final formatter = DateFormat('HH:mm');
  return formatter.format(dateTime.toUtc());
}


  @override
  Widget build(BuildContext context) {
    final utc = DateTime.fromMillisecondsSinceEpoch(message.time * 1000, isUtc: true).toUtc();
final local = DateTime.fromMillisecondsSinceEpoch(message.time * 1000, isUtc: true).toLocal();

log('UTC Time: ${utc.toString()}');
log('Local Time: ${local.toString()}');
    final screenWidth = MediaQuery.of(context).size.width;
// log(message.time.toString());
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Chat Bubble
          Container(
            width: screenWidth * 0.7,
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.all(screenWidth * 0.03),
            decoration: BoxDecoration(
              gradient: message.isMe
                  ? AppColors.appGradientColors // Use your gradient colors
                  : LinearGradient(colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
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
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      message.sender,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                Text(
                  message.message,
                  style: TextStyle(
                      color: message.isMe ? Colors.white : Colors.black),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    Text(message.time.toString()),
                    Text(
                      convertTimestampTo24HourUTC(message.time)
                      ,
                      style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: message.isMe ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}