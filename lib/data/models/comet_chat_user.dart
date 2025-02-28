class CometChatUser {
  final String uid;
  final String name;
  final String link;
  final String avatar;
  // final Metadata metadata;
  final String status;
  final String role;
  final int createdAt;
  final String authToken;

  CometChatUser({
    required this.uid,
    required this.name,
    required this.link,
    required this.avatar,
    // required this.metadata,
    required this.status,
    required this.role,
    required this.createdAt,
    required this.authToken,
  });

  factory CometChatUser.fromJson(Map<String, dynamic> json) {
    return CometChatUser(
      uid: json['uid'],
      name: json['name'],
      link: json['link'],
      avatar: json['avatar'],
      // metadata: Metadata.fromJson(json['metadata']),
      status: json['status'],
      role: json['role'],
      createdAt: json['createdAt'],
      authToken: json['authToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "link": link,
      "avatar": avatar,
      // "metadata": metadata.toJson(),
      "status": status,
      "role": role,
      "createdAt": createdAt,
      "authToken": authToken,
    };
  }
}
