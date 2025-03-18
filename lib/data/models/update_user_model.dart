class UpdateUserModel {
  final String name;
  final String email;
  final String phone;
  final String profilePhoto;
  final String coverPhoto;

  UpdateUserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePhoto,
    required this.coverPhoto,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
