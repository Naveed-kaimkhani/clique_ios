// models/message_model.dart
class MessageModel {
  final String sender;
  final String message;
  final bool isMe;
  final int time;
  final List<String> seenBy;

  MessageModel({
    required this.sender,
    required this.message,
    required this.isMe,
    required this.time,
    this.seenBy = const [],
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['name'],
      message: json['message'],
      isMe: json['uid'] == json['userId'], // Compare with logged-in user ID
      time: json['sentAt'],
      seenBy: List<String>.from(json['seenBy'] ?? []),
    );
  }
}