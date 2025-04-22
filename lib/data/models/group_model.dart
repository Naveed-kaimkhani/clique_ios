

class Group {
  final String guid;
  final String name;
  final String type;
  final int membersCount;
  final String conversationId;
  // final int createdAt;
  final String owner;
  // final int updatedAt;
  final String? icon; 
  final bool isJoined;

  Group({
    required this.guid,
    required this.name,
    required this.isJoined,
    required this.type,
    required this.membersCount,
    required this.conversationId,
    // required this.createdAt,
    required this.owner,
    // required this.updatedAt,
    this.icon,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      guid: json['guid'],
      name: json['name'],
      type: json['type'],
      isJoined: json['is_joined'],
      membersCount: json['membersCount'] ?? 0,
      
      // membersCount: 2,
      conversationId: json['conversationId'],
      // createdAt: json['createdAt'],
      owner: json['owner'] ?? '0',
      // updatedAt: json['updatedAt'],
      icon: json['icon'] ?? 'https://cdn-icons-png.freepik.com/256/1998/1998627.png?semt=ais_hybrid',
      // icon: null,
    );
  }
}
