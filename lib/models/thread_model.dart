import 'dart:developer';

class ThreadModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String message;
  final bool isMe;
  final int time;
  final String? parentId;
  final List<ReactionModel> reactions;

  ThreadModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.message,
    required this.isMe,
    required this.time,
    required this.reactions,
    this.parentId,
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    final entities = json['data']['entities'];
    final sender = entities['sender']['entity'];

    // Optional reactions
    List<ReactionModel> parsedReactions = [];
    if ((json['data']['reactions'] ?? []) is List) {
      parsedReactions = (json['data']['reactions'] as List)
          .map((e) => ReactionModel.fromJson(e))
          .toList();
    }

    return ThreadModel(
      id: json['id'].toString(),
      senderId: sender['uid'],
      senderName: sender['name'],
      senderAvatar: sender['avatar'] ?? '',
      message: json['data']['text'] ?? '',
      parentId: json['parentId'],
      isMe: json['sender'] == sender['uid'], // Replace with logic to compare with logged-in user
      time: json['sentAt'],
      reactions: parsedReactions,
    );
  }
}

class ReactionModel {
  final String reaction;
  final int count;
  final bool reactedByMe;

  ReactionModel({
    required this.reaction,
    required this.count,
    required this.reactedByMe,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      reaction: json['reaction'] ?? '',
      count: json['count'] ?? 0,
      reactedByMe: json['reactedByMe'] ?? false,
    );
  }
}
