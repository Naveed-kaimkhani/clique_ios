

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

// Future<List<Group>> fetchGroups(String token) async {
//   final response = await http.get(
//     Uri.parse('https://cactisocial.com/api-clique/public/api/v1/cometchat/groups'),
//     headers: {
//       'Authorization': 'Bearer 63|9dM3rfqqIBCkelTcgGCgoMTNQn5MRJde3glXauj956689575',
//       'Content-Type': 'application/json',
//     },
//   );
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     return (data['data'] as List).map((group) => Group.fromJson(group)).toList();
//   } else {
//     throw Exception('Failed to load groups');
//   }
// }