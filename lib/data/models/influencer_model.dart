class InfluencerModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final DateTime? emailVerifiedAt;
  final String? cometchatAuthToken;
  final String? profilePhoto;
  final String? coverPhoto;
  final int followersCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFollowing;

  InfluencerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.emailVerifiedAt,
    this.cometchatAuthToken,
    this.profilePhoto,
    this.coverPhoto,
    required this.followersCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isFollowing,
  });

  // Factory method to create an InfluencerModel from JSON
  factory InfluencerModel.fromJson(Map<String, dynamic> json) {
    return InfluencerModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      cometchatAuthToken: json['cometchat_auth_token'],
      profilePhoto: json['profile_photo_url'],
      coverPhoto: json['cover_photo_url'],
      followersCount: json['followers_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isFollowing: json['is_following'] ?? false,
    );
  }

  // Method to convert an InfluencerModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'cometchat_auth_token': cometchatAuthToken,
      'profile_photo': profilePhoto,
      'cover_photo': coverPhoto,
      'followers_count': followersCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_following': isFollowing,
    };
  }
}