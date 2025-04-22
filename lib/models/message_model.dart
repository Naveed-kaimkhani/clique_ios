// class MessageModel {
//   final String sender;
//   final String id;
//   final String message;
//   final bool isMe;
//   final int time;
//   final List<String> seenBy;

//   MessageModel({
//     required this.sender,
//     required this.message,
//     required this.isMe,
//     required this.id,
//     required this.time,
//     this.seenBy = const [],
//   });

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       sender: json['name'],
//       message: json['message'],
//       id: json['id'],
//       isMe: json['uid'] == json['userId'], // Compare with logged-in user ID
//       time: json['sentAt'],
//       seenBy: List<String>.from(json['seenBy'] ?? []),
//     );
//   }
// }

class MessageModel {
  final String sender;
  final String id;
  final String message;
  final bool isMe;
  final int time;
  final List<String> seenBy;
  final List<ReactionModel> reactions;

  MessageModel({
    required this.sender,
    required this.message,
    required this.isMe,
    required this.id,
    required this.time,
    this.seenBy = const [],
    this.reactions = const [],
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    List<ReactionModel> parsedReactions = [];

    // Safely parse reactions only if it's a valid list
    if (json['reactions'] is List) {
      parsedReactions = (json['reactions'] as List)
          .map((e) => ReactionModel.fromJson(e))
          .toList();
    }

    return MessageModel(
      sender: json['name'],
      message: json['message'],
      id: json['id'],
      isMe: json['uid'] == json['userId'],
      time: json['sentAt'],
      seenBy: List<String>.from(json['seenBy'] ?? []),
      reactions: parsedReactions,
    );
  }
}


class ReactionModel {
  final String reaction;
  final int count;

  ReactionModel({
    required this.reaction,
    required this.count,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) {
    return ReactionModel(
      reaction: json['reaction'] ?? '',
      count: json['count'] ?? 0,
    );
  }
}
