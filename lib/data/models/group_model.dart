import 'package:clique/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Group {
  final String guid;
  final String name;
  final String type;
  final int membersCount;
  final String conversationId;
  final int createdAt;
  final String owner;
  final int updatedAt;
  final String? icon;

  Group({
    required this.guid,
    required this.name,
    required this.type,
    required this.membersCount,
    required this.conversationId,
    required this.createdAt,
    required this.owner,
    required this.updatedAt,
    this.icon,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      guid: json['guid'],
      name: json['name'],
      type: json['type'],
      membersCount: json['membersCount'],
      conversationId: json['conversationId'],
      createdAt: json['createdAt'],
      owner: json['owner'],
      updatedAt: json['updatedAt'],
      icon: json['icon'],
    );
  }
}

Future<List<Group>> fetchGroups() async {
  final response = await http.get(
    Uri.parse('https://dev.moutfits.com/api/v1/cometchat/groups'),
    headers: {
      'Authorization': 'Bearer 63|9dM3rfqqIBCkelTcgGCgoMTNQn5MRJde3glXauj956689575',
      'Content-Type': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['data'] as List).map((group) => Group.fromJson(group)).toList();
  } else {
    throw Exception('Failed to load groups');
  }
}